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

        $activatedBundles = $container->getParameter('kernel.bundles');

        if (!array_key_exists('EzCoreExtraBundle', $activatedBundles)) {
            throw new RuntimeException('Netgen Admin UI Bundle requires EzCoreExtraBundle (lolautruche/ez-core-extra-bundle) to be activated to work properly.');
        }

        if ($this->hasTags($activatedBundles)) {
            $loader->load('tags/services.yml');
        }

        if ($this->hasLayouts($activatedBundles)) {
            $loader->load('layouts/controllers.yml');
        }

        if ($this->hasInformationCollection($activatedBundles)) {
            $loader->load('information_collection/services.yml');
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

        if ($this->hasLayouts($container->getParameter('kernel.bundles'))) {
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
     * @param array $activatedBundles
     *
     * @return bool
     */
    protected function hasLayouts(array $activatedBundles)
    {
        if (!class_exists('Netgen\BlockManager\Version')) {
            return false;
        }

        if (BlockManagerVersion::VERSION_ID < 800) {
            return false;
        }

        return array_key_exists('NetgenBlockManagerBundle', $activatedBundles);
    }

    /**
     * Returns if Netgen Tags v3+ is active or not.
     *
     * @param array $activatedBundles
     *
     * @return bool
     */
    protected function hasTags(array $activatedBundles)
    {
        if (!class_exists('Netgen\TagsBundle\Version')) {
            return false;
        }

        if (TagsBundleVersion::MAJOR_VERSION < 3) {
            return false;
        }

        return array_key_exists('NetgenTagsBundle', $activatedBundles);
    }

    /**
     * Returns if Netgen Information Collection is active or not.
     *
     * @param array $activatedBundles
     *
     * @return bool
     */
    protected function hasInformationCollection(array $activatedBundles)
    {
//        if (!class_exists('Netgen\TagsBundle\Version')) {
//            return false;
//        }
//
//        if (TagsBundleVersion::MAJOR_VERSION < 3) {
//            return false;
//        }

        return array_key_exists('NetgenInformationCollectionBundle', $activatedBundles);
    }
}
