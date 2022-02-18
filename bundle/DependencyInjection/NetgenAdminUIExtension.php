<?php

namespace Netgen\Bundle\AdminUIBundle\DependencyInjection;

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
        $loader = new Loader\YamlFileLoader(
            $container,
            new FileLocator(__DIR__ . '/../Resources/config')
        );

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
            $loader->load('layouts/forms.yml');
            $loader->load('layouts/controllers.yml');
            $loader->load('layouts/services.yml');
            $this->setIsLayoutsEnterprise($container, $activatedBundles);
        }

        if ($this->hasInformationCollection($activatedBundles)) {
            $loader->load('information_collection/services.yml');
        }

        $logoType = $container->getParameter('netgen_admin_ui.logo_type');
        if ($logoType === 'default') {
            if (class_exists('Netgen\Bundle\SiteBundle\NetgenSiteBundle')) {
                $container->setParameter('netgen_admin_ui.logo_type', 'ngadminui');
            }
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
            $configs['layouts/view.yml'] = 'netgen_layouts';
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
        return array_key_exists('NetgenLayoutsBundle', $activatedBundles);
    }

    /**
     * Sets the flag to the container if Netgen Layouts is the enterprise or open source version.
     *
     * @param \Symfony\Component\DependencyInjection\ContainerBuilder $container
     * @param array $activatedBundles
     */
    protected function setIsLayoutsEnterprise(ContainerBuilder $container, array $activatedBundles)
    {
        $container->setParameter(
            'netgen_admin_ui.layouts.is_enterprise',
            array_key_exists('NetgenLayoutsEnterpriseBundle', $activatedBundles)
        );
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
        return array_key_exists('NetgenInformationCollectionBundle', $activatedBundles);
    }
}
