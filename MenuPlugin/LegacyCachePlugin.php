<?php

namespace Netgen\Bundle\MoreAdminUIBundle\MenuPlugin;

use Symfony\Component\HttpFoundation\Request;

class LegacyCachePlugin implements MenuPluginInterface
{
    /**
     * Returns plugin identifier
     *
     * @return string
     */
    public function getIdentifier()
    {
        return 'legacy_cache';
    }

    /**
     * Returns aside menu template name
     *
     * @return string
     */
    public function getAsideTemplate()
    {
        return 'NetgenMoreAdminUIBundle:menu/plugins/legacy_cache:aside.html.twig';
    }

    /**
     * Returns left menu template name
     *
     * @return string
     */
    public function getLeftTemplate()
    {
        return null;
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
        return false;
    }
}
