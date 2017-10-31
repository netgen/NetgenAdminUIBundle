<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

use eZ\Bundle\EzPublishLegacyBundle\Routing\FallbackRouter;
use eZ\Publish\Core\MVC\Symfony\Routing\UrlAliasRouter;
use Symfony\Component\HttpFoundation\Request;

class LegacyMenuPlugin implements MenuPluginInterface
{
    /**
     * Returns plugin identifier.
     *
     * @return string
     */
    public function getIdentifier()
    {
        return 'legacy';
    }

    /**
     * Returns the list of templates this plugin supports.
     *
     * @return array
     */
    public function getTemplates()
    {
        return array(
            'aside' => '@NetgenAdminUI/menu/plugins/legacy/aside.html.twig',
            'left' => '@NetgenAdminUI/menu/plugins/legacy/left.html.twig',
            'top' => '@NetgenAdminUI/menu/plugins/legacy/top.html.twig',
        );
    }

    /**
     * Returns if the menu is active.
     *
     * @return bool
     */
    public function isActive()
    {
        return true;
    }

    /**
     * Returns if this plugin matches the current request.
     *
     * @param \Symfony\Component\HttpFoundation\Request $request
     *
     * @return bool
     */
    public function matches(Request $request)
    {
        return in_array(
            $request->attributes->get('_route'),
            array(FallbackRouter::ROUTE_NAME, UrlAliasRouter::URL_ALIAS_ROUTE_NAME),
            true
        );
    }
}
