<?php

namespace Netgen\Bundle\AdminUIBundle\DependencyInjection;

use Netgen\BlockManager\Version as BlockManagerVersion;
use Netgen\TagsBundle\Version as TagsBundleVersion;
use RuntimeException;
use Symfony\Component\Config\FileLocator;
use Symfony\Component\Config\Resource\FileResource;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Extension\PrependExtensionInterface;
use Symfony\Component\DependencyInjection\Loader;
use Symfony\Component\HttpKernel\DependencyInjection\Extension;
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

        $activatedBundles = array_keys($container->getParameter('kernel.bundles'));

        if (!in_array('EzCoreExtraBundle', $activatedBundles, true)) {
            throw new RuntimeException('Netgen Admin UI Bundle requires EzCoreExtraBundle (lolautruche/ez-core-extra-bundle) to be activated to work properly.');
        }

        if (class_exists('Netgen\TagsBundle\Version') && TagsBundleVersion::MAJOR_VERSION >= 3) {
            $loader->load('tags/services.yml');
        }

        if ($this->hasLayouts($container)) {
            $loader->load('layouts/controllers.yml');
        }

        $logoType = $container->getParameter('netgen_admin_ui.logo_type');
        if ($logoType === 'default' && class_exists('Netgen\Bundle\MoreBundle\NetgenMoreBundle')) {
            $container->setParameter('netgen_admin_ui.logo_type', 'ngadminui');
        }
    }

    /**
     * Allow an extension to prepend the extension configurations.
     *
     * @param \Symfony\Component\DependencyInjection\ContainerBuilder $container
     */
    public function prepend(ContainerBuilder $container)
    {
        $configs = array(
            'framework/twig.yml' => 'twig',
        );

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
        if (!class_exists('Netgen\BlockManager\Version')) {
            return false;
        }

        if (BlockManagerVersion::VERSION_ID < 800) {
            return false;
        }

        $activatedBundles = $container->getParameter('kernel.bundles');

        return array_key_exists('NetgenBlockManagerBundle', $activatedBundles);
    }
}
