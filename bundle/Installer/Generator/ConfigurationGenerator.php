<?php

namespace Netgen\Bundle\AdminUIBundle\Installer\Generator;

use eZ\Publish\API\Repository\Values\Content\Language;
use Symfony\Component\Console\Helper\QuestionHelper;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Question\ConfirmationQuestion;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\Yaml\Yaml;

class ConfigurationGenerator extends Generator
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
     * Generates the main configuration.
     *
     * @param \Symfony\Component\Console\Input\InputInterface $input
     * @param \Symfony\Component\Console\Output\OutputInterface $output
     */
    public function generate(InputInterface $input, OutputInterface $output)
    {
        $fileSystem = $this->container->get('filesystem');
        $configResolver = $this->container->get('ezpublish.config.resolver');
        $kernelRootDir = $this->container->getParameter('kernel.root_dir');

        $siteAccessGroup = $input->getOption('site-access-group');

        $varDir = $configResolver->getParameter('var_dir', null, $siteAccessGroup);
        $repository = $configResolver->getParameter('repository', null, $siteAccessGroup);

        $configFile = $kernelRootDir . '/config/ngadminui.yml';

        if ($fileSystem->exists($configFile)) {
            if (
                !$this->questionHelper->ask(
                    $input,
                    $output,
                    new ConfirmationQuestion(
                        '<info><comment>ngadminui.yml</comment> configuration file already exists. Do you want to overwrite it?</info> [<comment>no</comment>] ',
                        false
                    )
                )
            ) {
                return;
            }
        }

        $siteAccessName = $input->getOption('site-access-name');

        $languageService = $this->container->get('ezpublish.api.repository')->getContentLanguageService();
        $languages = $languageService->loadLanguages();

        $settings = array(
            'parameters' => array(
                'netgen_admin_ui.' . $siteAccessName . '.is_admin_ui_siteaccess' => true,
                'eztags.' . $siteAccessName . '.routing.enable_tag_router' => false,
                'ezsettings.' . $siteAccessName . '.treemenu.http_cache' => false,
            ),
            'ezpublish' => array(
                'siteaccess' => array(
                    'list' => array(
                        $siteAccessName,
                    ),
                    'groups' => array(
                        'ngadminui' => array(
                            $siteAccessName,
                        ),
                    ),
                    'match' => array(
                        'Map\URI' => array(
                            $siteAccessName => $siteAccessName,
                        ),
                    ),
                ),
                'system' => array(
                    $siteAccessName => array(
                        'user' => array(
                            'layout' => '@NetgenAdminUI/pagelayout_login.html.twig',
                            'login_template' => '@NetgenAdminUI/user/login.html.twig',
                        ),
                        'languages' => array_map(
                            function (Language $language) {
                                return $language->languageCode;
                            },
                            $languages
                        ),
                        'var_dir' => $varDir,
                        'repository' => $repository,
                    ),
                ),
            ),
            'ez_publish_legacy' => array(
                'system' => array(
                    $siteAccessName => array(
                        'templating' => array(
                            'view_layout' => '@NetgenAdminUI/pagelayout_legacy.html.twig',
                            'module_layout' => '@NetgenAdminUI/pagelayout_module.html.twig',
                        ),
                    ),
                ),
            ),
        );

        file_put_contents($configFile, Yaml::dump($settings, 7));

        $output->writeln(
            array(
                '',
                'Generated <comment>ngadminui.yml</comment> configuration file!',
                '',
            )
        );
    }
}
