<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

use Symfony\Component\HttpFoundation\Request;

class LegacyCachePlugin implements MenuPluginInterface
{
    /**
     * Returns plugin identifier.
     *
     * @return string
     */
    public function getIdentifier()
    {
        return 'legacy_cache';
    }

    /**
     * Returns the list of templates this plugin supports.
     *
     * @return array
     */
    public function getTemplates()
    {
        return array(
            'aside' => 'NetgenAdminUIBundle:menu/plugins/legacy_cache:aside.html.twig',
        );
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
        return false;
    }
}
