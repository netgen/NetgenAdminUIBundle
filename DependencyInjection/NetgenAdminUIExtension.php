<?php

namespace Netgen\Bundle\AdminUIBundle\DependencyInjection;

use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\Config\FileLocator;
use Symfony\Component\HttpKernel\DependencyInjection\Extension;
use Symfony\Component\DependencyInjection\Loader;
use Netgen\TagsBundle\Version as TagsBundleVersion;

class NetgenAdminUIExtension extends Extension
{
    /**
     * {@inheritdoc}
     */
    public function load(array $configs, ContainerBuilder $container)
    {
        $configuration = new Configuration();
        $config = $this->processConfiguration($configuration, $configs);

        $loader = new Loader\YamlFileLoader($container, new FileLocator(__DIR__ . '/../Resources/config'));
        $loader->load('parameters.yml');
        $loader->load('menu_plugins.yml');
        $loader->load('templating.yml');
        $loader->load('services.yml');

        if (class_exists('Netgen\TagsBundle\Version') && TagsBundleVersion::MAJOR_VERSION >= 3) {
            $loader->load('tags/services.yml');
        }
    }
}
