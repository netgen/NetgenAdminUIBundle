<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use Symfony\Component\HttpFoundation\Request;
use Netgen\Bundle\InformationCollectionBundle\Version as InformationCollectionVersion;

class InformationCollectionMenuPlugin implements MenuPluginInterface
{
    /**
     * @var array
     */
    protected $enabledBundles;

    public function __construct(array $enabledBundles)
    {
        $this->enabledBundles = $enabledBundles;
    }

    public function getIdentifier()
    {
        return 'information_collection';
    }

    public function getTemplates()
    {
        return array(
            'aside' => '@NetgenAdminUI/menu/plugins/information_collection/aside.html.twig',
            'left' => '@NetgenAdminUI/menu/plugins/information_collection/left.html.twig',
        );
    }

    public function isActive()
    {
        if (!isset($this->enabledBundles['NetgenInformationCollectionBundle'])) {
            return false;
        }

        return class_exists('Netgen\Bundle\InformationCollectionBundle\Version')
            && InformationCollectionVersion::MAJOR_VERSION >= 1
            && InformationCollectionVersion::MINOR_VERSION >= 5;
    }

    public function matches(Request $request)
    {
        return mb_stripos(
            $request->attributes->get('_route'),
            'netgen_information_collection'
        ) === 0;
    }
}