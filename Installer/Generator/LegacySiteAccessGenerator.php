<?php

namespace Netgen\Bundle\AdminUIBundle\Installer\Generator;

use eZ\Publish\API\Repository\Values\Content\Language;
use Symfony\Component\Console\Helper\QuestionHelper;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Question\ConfirmationQuestion;
use Symfony\Component\DependencyInjection\ContainerInterface;

class LegacySiteAccessGenerator extends Generator
{
    /**
     * @var \Symfony\Component\DependencyInjection\ContainerInterface
     */
    protected $container;

    /**
     * @var \Symfony\Component\Console\Helper\QuestionHelper
     */
    protected $questionHelper;

    /**
     * Constructor.
     *
     * @param \Symfony\Component\DependencyInjection\ContainerInterface $container
     * @param \Symfony\Component\Console\Helper\QuestionHelper $questionHelper
     */
    public function __construct(ContainerInterface $container, QuestionHelper $questionHelper)
    {
        $this->container = $container;
        $this->questionHelper = $questionHelper;
    }

    /**
     * Generates the siteaccesses.
     *
     * @param \Symfony\Component\Console\Input\InputInterface $input
     * @param \Symfony\Component\Console\Output\OutputInterface $output
     */
    public function generate(InputInterface $input, OutputInterface $output)
    {
        $fileSystem = $this->container->get('filesystem');
        $legacyRootDir = $this->container->getParameter('ezpublish_legacy.root_dir');

        $siteAccessName = $input->getOption('site-access-name');
        $languageCode = $input->getOption('language-code');
        $siteAccessLocation = $legacyRootDir . '/settings/siteaccess/' . $siteAccessName;
        $skeletonDir = __DIR__ . '/../_templates/legacy_siteaccess';

        if ($fileSystem->exists($siteAccessLocation)) {
            if (
                !$this->questionHelper->ask(
                    $input,
                    $output,
                    new ConfirmationQuestion(
                        '<info><comment>' . $siteAccessName . '</comment> legacy siteaccess already exists. Do you want to overwrite it?</info> [<comment>no</comment>] ',
                        false
                    )
                )
            ) {
                return;
            }
        }

        $fileSystem->remove($siteAccessLocation);

        // Template variables

        $languageService = $this->container->get('ezpublish.api.repository')->getContentLanguageService();

        $relatedSiteAccessList = $this->container->getParameter('ezpublish.siteaccess.list');
        $relatedSiteAccessList[] = $siteAccessName;

        $availableLocales = array_map(
            function (Language $language) {
                return $language->languageCode;
            },
            $languageService->loadLanguages()
        );

        $availableLocales = array_values(array_diff($availableLocales, array($languageCode)));

        // Place siteaccess locale at the top of site language list
        $siteLanguageList = array_merge(array($languageCode), $availableLocales);
        $translationList = implode(';', $availableLocales);

        // Generating admin siteaccess

        $fileSystem->mirror($skeletonDir, $siteAccessLocation);

        $this->setSkeletonDirs($siteAccessLocation);

        $this->renderFile(
            'site.ini.append.php',
            $siteAccessLocation . '/site.ini.append.php',
            array(
                'relatedSiteAccessList' => $relatedSiteAccessList,
                'siteAccessLocale' => $languageCode,
                'siteLanguageList' => $siteLanguageList,
                'translationList' => $translationList,
            )
        );

        $output->writeln(
            array(
                '',
                'Generated <comment>' . $siteAccessName . '</comment> legacy siteaccess!',
                '',
            )
        );
    }
}
