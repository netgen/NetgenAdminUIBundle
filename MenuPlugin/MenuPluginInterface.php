<?php

namespace Netgen\Bundle\MoreAdminUIBundle\MenuPlugin;

use Symfony\Component\HttpFoundation\Request;

interface MenuPluginInterface
{
    /**
     * Returns plugin identifier
     *
     * @return string
     */
    public function getIdentifier();

    /**
     * Returns aside menu template name
     *
     * @return string
     */
    public function getAsideTemplate();

    /**
     * Returns left menu template name
     *
     * @return string
     */
    public function getLeftTemplate();

    /**
     * Returns if this plugin matches the current request
     *
     * @param \Symfony\Component\HttpFoundation\Request $request
     *
     * @return bool
     */
    public function matches( Request $request );
}
