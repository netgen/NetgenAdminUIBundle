<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

use Symfony\Component\HttpFoundation\Request;

class InformationCollectionMenuPlugin implements MenuPluginInterface
{
    /**
     * @var array
     */
    protected $enabledBundles;

    /**
     * @var bool
     */
    protected $hasInformationCollectionService;

    public function __construct(array $enabledBundles, $hasInformationCollectionService)
    {
        $this->enabledBundles = $enabledBundles;
        $this->hasInformationCollectionService = $hasInformationCollectionService;
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

        return $this->hasInformationCollectionService;
    }

    public function matches(Request $request)
    {
        return mb_stripos(
            $request->attributes->get('_route'),
            'netgen_information_collection'
        ) === 0;
    }
}
