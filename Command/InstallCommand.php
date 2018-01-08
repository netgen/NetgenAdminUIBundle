<?php

namespace Netgen\Bundle\AdminUIBundle\Command;

use Exception;
use eZ\Publish\API\Repository\Exceptions\NotFoundException;
use InvalidArgumentException;
use Netgen\Bundle\AdminUIBundle\Installer\Generator\ConfigurationGenerator;
use Netgen\Bundle\AdminUIBundle\Installer\Generator\LegacySiteAccessGenerator;
use RuntimeException;
use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Question\ChoiceQuestion;
use Symfony\Component\Console\Question\ConfirmationQuestion;
use Symfony\Component\Console\Question\Question;
use Symfony\Component\HttpKernel\Kernel;
use Symfony\Component\Process\ProcessBuilder;

class InstallCommand extends ContainerAwareCommand
{
    /**
     * @var \Symfony\Component\Console\Input\InputInterface
     */
    protected $input;

    /**
     * @var \Symfony\Component\Console\Output\OutputInterface
     */
    protected $output;

    /**
     * @var \Symfony\Component\Console\Helper\QuestionHelper
     */
    protected $questionHelper;

    /**
     * Configures the command.
     */
    protected function configure()
    {
        $this->setDefinition(
            array(
                new InputOption('site-access-name', '', InputOption::VALUE_REQUIRED, 'Siteaccess name'),
                new InputOption('language-code', '', InputOption::VALUE_REQUIRED, 'Language code'),
                new InputOption('site-access-group', '', InputOption::VALUE_REQUIRED, 'Siteaccess group'),
            )
        );
        $this->setDescription('Netgen Admin UI installation');
        $this->setName('ngadminui:install');
    }

    /**
     * Runs the command interactively.
     *
     * @param \Symfony\Component\Console\Input\InputInterface $input
     * @param \Symfony\Component\Console\Output\OutputInterface $output
     *
     * @return int
     */
    protected function interact(InputInterface $input, OutputInterface $output)
    {
        $this->input = $input;
        $this->output = $output;
        $this->questionHelper = $this->getHelper('question');

        if (Kernel::VERSION_ID < 20700) {
            throw new RuntimeException(
                'Installation is not possible. Netgen Admin UI requires Symfony 2.7 or later to work.'
            );
        }

        if (!$this->getContainer()->hasParameter('ezpublish_legacy.root_dir')) {
            throw new RuntimeException(
                sprintf(
                    "%s\n%s",
                    'Installation is not possible because eZ Publish Legacy is not present.',
                    'Netgen Admin UI requires eZ Publish Community 2014.12 (Netgen Variant), eZ Publish 5.4.x or eZ Platform with Legacy Bridge to work.'
                )
            );
        }

        $this->writeSection('Welcome to the Netgen Admin UI installation');

        while (!$this->doInteract()) {
        }

        return 0;
    }

    /**
     * Collects all the data interactively.
     *
     * @return bool
     */
    protected function doInteract()
    {
        $siteAccess = $this->askForData(
            'site-access-name',
            'Enter the name of the Netgen Admin UI siteaccess',
            'ngadminui',
            function ($siteaccess) {
                if (!preg_match('/^[a-z][a-z0-9_]*$/', $siteaccess)) {
                    throw new InvalidArgumentException(
                        'Siteaccess name is not valid. It must start with a letter, followed by any combination of letters, numbers and underscore.'
                    );
                }

                $existingSiteAccesses = $this->getContainer()->getParameter('ezpublish.siteaccess.list');
                if (in_array($siteaccess, $existingSiteAccesses, true)) {
                    throw new InvalidArgumentException(
                        sprintf('Siteaccess "%s" already exists.', $siteaccess)
                    );
                }

                return $siteaccess;
            }
        );

        $this->output->writeln('');

        $languageCode = $this->askForData(
            'language-code',
            'Enter the language code in which the Netgen Admin UI will be translated',
            'eng-GB',
            function ($languageCode) {
                $languageService = $this->getContainer()->get('ezpublish.api.repository')->getContentLanguageService();

                try {
                    $languageService->loadLanguage($languageCode);
                } catch (NotFoundException $e) {
                    throw new InvalidArgumentException(
                        sprintf('Language code "%s" does not exist.', $languageCode)
                    );
                }

                return $languageCode;
            }
        );

        $this->output->writeln('');

        $availableGroups = array_keys($this->getContainer()->getParameter('ezpublish.siteaccess.groups'));
        $availableGroups[] = 'default';

        $siteAccessGroup = $this->askForChoiceData(
            'site-access-group',
            'Enter the siteaccess group name on which the Netgen Admin UI configuration will be based. This is usually the name of your frontend siteaccess group',
            $availableGroups,
            current($availableGroups)
        );

        $this->writeSection('Summary before installation');

        $this->output->writeln(
            array(
                'You are going to generate legacy <info>' . $siteAccess . '</info> siteaccess with <info>' . $languageCode . '</info> language code based on <info>' . $siteAccessGroup . '</info> siteaccess group.',
                '',
            )
        );

        if (
            !$this->questionHelper->ask(
                $this->input,
                $this->output,
                $this->getConfirmationQuestion(
                    'Do you confirm installation (answering <comment>no</comment> will restart the process)',
                    true
                )
            )
        ) {
            $this->output->writeln('');

            return false;
        }

        return true;
    }

    /**
     * Runs the command.
     *
     * @param \Symfony\Component\Console\Input\InputInterface $input
     * @param \Symfony\Component\Console\Output\OutputInterface $output
     *
     * @return int
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        if (!$input->isInteractive()) {
            $output->writeln('<error>This command only supports interactive execution</error>');

            return 1;
        }

        $this->writeSection('Installation');

        // Generate legacy siteaccess
        $legacySiteAccessGenerator = new LegacySiteAccessGenerator(
            $this->getContainer(),
            $this->questionHelper
        );

        $legacySiteAccessGenerator->generate($this->input, $this->output);

        // Generate configuration
        $configurationGenerator = new ConfigurationGenerator(
            $this->getContainer(),
            $this->questionHelper
        );

        $configurationGenerator->generate($this->input, $this->output);

        $errors = array();
        $runner = $this->getRunner($errors);

        // Generate legacy autoloads
        $runner($this->generateLegacyAutoloads());

        $this->writeInstallerSummary($errors);

        return 0;
    }

    /**
     * Generates legacy autoloads.
     *
     * @return array
     */
    protected function generateLegacyAutoloads()
    {
        $this->output->writeln('');
        $this->output->write('Generating legacy autoloads... ');

        $currentWorkingDirectory = getcwd();

        try {
            chdir($this->getContainer()->getParameter('ezpublish_legacy.root_dir'));

            $processBuilder = new ProcessBuilder(
                array(
                    'php',
                    'bin/php/ezpgenerateautoloads.php',
                    '--quiet',
                )
            );

            $process = $processBuilder->getProcess();

            $process->setTimeout(3600);
            $process->run(
                function ($type, $buffer) {
                    echo $buffer;
                }
            );

            chdir($currentWorkingDirectory);

            if (!$process->isSuccessful()) {
                return array(
                    '- Run the following command from your ezpublish_legacy root to generate legacy autoloads:',
                    '',
                    '    <comment>php bin/php/ezpgenerateautoloads.php</comment>',
                    '',
                );
            }
        } catch (Exception $e) {
            chdir($currentWorkingDirectory);

            return array(
                'There was an error generating legacy autoloads: ' . $e->getMessage(),
                '',
            );
        }
    }

    /**
     * Asks a question that fills provided option.
     *
     * @param string $optionIdentifier
     * @param string $optionName
     * @param string $defaultValue
     * @param callable $validator
     *
     * @return string
     */
    protected function askForData($optionIdentifier, $optionName, $defaultValue, $validator = null)
    {
        $optionValue = $this->input->getOption($optionIdentifier);
        $optionValue = !empty($optionValue) ? $optionValue :
            $defaultValue;

        $question = $this->getQuestion($optionName, $optionValue, $validator);
        $optionValue = $this->questionHelper->ask(
            $this->input,
            $this->output,
            $question
        );

        $this->input->setOption($optionIdentifier, $optionValue);

        return $optionValue;
    }

    /**
     * Asks a choice question that fills provided option.
     *
     * @param string $optionIdentifier
     * @param string $optionName
     * @param array $choices
     * @param string $defaultValue
     *
     * @return string
     */
    protected function askForChoiceData($optionIdentifier, $optionName, array $choices, $defaultValue)
    {
        $optionValue = $this->input->getOption($optionIdentifier);
        $optionValue = !empty($optionValue) ? $optionValue :
            $defaultValue;

        $question = $this->getChoiceQuestion($optionName, $optionValue, $choices);
        $optionValue = $this->questionHelper->ask(
            $this->input,
            $this->output,
            $question
        );

        $this->input->setOption($optionIdentifier, $optionValue);

        return $optionValue;
    }

    /**
     * Instantiates and returns a choice question.
     *
     * @param string $questionName
     * @param string $defaultValue
     * @param callable $validator
     *
     * @return \Symfony\Component\Console\Question\Question
     */
    protected function getQuestion($questionName, $defaultValue = null, $validator = null)
    {
        $questionName = $defaultValue
            ? '<info>' . $questionName . '</info> [<comment>' . $defaultValue . '</comment>]: '
            : '<info>' . $questionName . '</info>: ';

        $question = new Question($questionName, $defaultValue);
        if ($validator !== null) {
            $question->setValidator($validator);
        }

        return $question;
    }

    /**
     * Instantiates and returns a question.
     *
     * @param string $questionName
     * @param string $defaultValue
     * @param array $choices
     *
     * @return \Symfony\Component\Console\Question\Question
     */
    protected function getChoiceQuestion($questionName, $defaultValue = null, array $choices = array())
    {
        $questionName = $defaultValue
            ? '<info>' . $questionName . '</info> [<comment>' . $defaultValue . '</comment>]: '
            : '<info>' . $questionName . '</info>: ';

        return new ChoiceQuestion($questionName, $choices, $defaultValue);
    }

    /**
     * Instantiates and returns the confirmation question.
     *
     * @param string $questionName
     * @param bool $defaultValue
     *
     * @return \Symfony\Component\Console\Question\ConfirmationQuestion
     */
    protected function getConfirmationQuestion($questionName, $defaultValue = false)
    {
        return new ConfirmationQuestion(
            sprintf(
                '<info>%s</info> [<comment>%s</comment>]? ',
                $questionName,
                $defaultValue ? 'yes' : 'no'
            ),
            $defaultValue
        );
    }

    /**
     * Writes installer summary.
     *
     * @param array $errors
     */
    protected function writeInstallerSummary($errors)
    {
        if (!$errors) {
            $this->writeSection('You can now continue installation as per instructions in the README.md file!');

            return;
        }

        $this->writeSection(
            array(
                'The command was not able to install everything automatically.',
                'You must do the following changes manually.',
            ),
            'error'
        );

        $this->output->writeln($errors);
    }

    /**
     * Writes a section of text to the output.
     *
     * @param string|array $text
     * @param string $style
     */
    protected function writeSection($text, $style = 'bg=blue;fg=white')
    {
        $this->output->writeln(
            array(
                '',
                $this->getHelper('formatter')->formatBlock($text, $style, true),
                '',
            )
        );
    }

    /**
     * Returns the runner.
     *
     * @param array $errors
     *
     * @return callable
     */
    protected function getRunner(&$errors)
    {
        $output = $this->output;
        $runner = function ($err) use ($output, &$errors) {
            if (!empty($err)) {
                $output->writeln('<fg=red>FAILED</>');
                $errors = array_merge($errors, $err);
            } else {
                $output->writeln('<info>OK</info>');
            }
        };

        return $runner;
    }
}
