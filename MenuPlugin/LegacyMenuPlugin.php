<?php

namespace Netgen\Bundle\MoreAdminUIBundle\MenuPlugin;

use eZ\Bundle\EzPublishLegacyBundle\Routing\FallbackRouter;
use eZ\Publish\Core\MVC\Symfony\Routing\UrlAliasRouter;
use Symfony\Component\HttpFoundation\Request;

class LegacyMenuPlugin implements MenuPluginInterface
{
    /**
     * Returns plugin identifier
     *
     * @return string
     */
    public function getIdentifier()
    {
        return 'legacy';
    }

    /**
     * Returns the list of templates this plugin supports
     *
     * @return array
     */
    public function getTemplates()
    {
        return array(
            'aside' => 'NetgenMoreAdminUIBundle:menu/plugins/legacy:aside.html.twig',
            'left' => 'NetgenMoreAdminUIBundle:menu/plugins/legacy:left.html.twig'
        );
    }

    /**
     * Returns if this plugin matches the current request
     *
     * @param \Symfony\Component\HttpFoundation\Request $request
     *
     * @return bool
     */
    public function matches( Request $request )
    {
        return in_array(
            $request->attributes->get( '_route' ),
            array( FallbackRouter::ROUTE_NAME, UrlAliasRouter::URL_ALIAS_ROUTE_NAME )
        );
    }
}
