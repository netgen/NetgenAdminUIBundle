<?php

namespace Netgen\Bundle\AdminUIBundle\DependencyInjection;

use Symfony\Component\Config\Resource\FileResource;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\Config\FileLocator;
use Symfony\Component\DependencyInjection\Extension\PrependExtensionInterface;
use Symfony\Component\HttpKernel\DependencyInjection\Extension;
use Symfony\Component\DependencyInjection\Loader;
use Netgen\TagsBundle\Version as TagsBundleVersion;
use Symfony\Component\Yaml\Yaml;

class NetgenAdminUIExtension extends Extension implements PrependExtensionInterface
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
        $loader->load('controllers.yml');
        $loader->load('services.yml');

        if (class_exists(TagsBundleVersion::class) && TagsBundleVersion::MAJOR_VERSION >= 3) {
            $loader->load('tags/services.yml');
        }

        if ($this->hasLayouts($container)) {
            $loader->load('layouts/controllers.yml');
        }
    }

    /**
     * Allow an extension to prepend the extension configurations.
     *
     * @param \Symfony\Component\DependencyInjection\ContainerBuilder $container
     */
    public function prepend(ContainerBuilder $container)
    {
        $configs = array();

        if ($this->hasLayouts($container)) {
            $configs['layouts/view.yml'] = 'netgen_block_manager';
        }

        foreach ($configs as $fileName => $extensionName) {
            $configFile = __DIR__ . '/../Resources/config/' . $fileName;
            $config = Yaml::parse(file_get_contents($configFile));
            $container->prependExtensionConfig($extensionName, $config);
            $container->addResource(new FileResource($configFile));
        }
    }

    /**
     * Returns if Netgen Layouts is active or not.
     *
     * @param \Symfony\Component\DependencyInjection\ContainerBuilder $container
     *
     * @return bool
     */
    protected function hasLayouts(ContainerBuilder $container)
    {
        $activatedBundles = $container->getParameter('kernel.bundles');

        return array_key_exists('NetgenBlockManagerBundle', $activatedBundles);
    }
}
