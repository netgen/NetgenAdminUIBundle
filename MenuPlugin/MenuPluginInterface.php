<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

use Symfony\Component\HttpFoundation\Request;

interface MenuPluginInterface
{
    /**
     * Returns plugin identifier.
     *
     * @return string
     */
    public function getIdentifier();

    /**
     * Returns the list of templates this plugin supports.
     *
     * @return array
     */
    public function getTemplates();

    /**
     * Returns if this plugin matches the current request.
     *
     * @param \Symfony\Component\HttpFoundation\Request $request
     *
     * @return bool
     */
    public function matches(Request $request);
}
