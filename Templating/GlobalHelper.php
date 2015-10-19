<?php

namespace Netgen\Bundle\MoreAdminUIBundle\Templating;

use Netgen\Bundle\MoreAdminUIBundle\MenuPlugin\MenuPluginRegistry;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;

class GlobalHelper
{
    /**
     * @var \Netgen\Bundle\MoreAdminUIBundle\MenuPlugin\MenuPluginRegistry
     */
    protected $menuPluginRegistry;

    /**
     * @var \Symfony\Component\HttpFoundation\RequestStack
     */
    protected $requestStack;

    /**
     * Constructor
     *
     * @param \Netgen\Bundle\MoreAdminUIBundle\MenuPlugin\MenuPluginRegistry $menuPluginRegistry
     * @param \Symfony\Component\HttpFoundation\RequestStack $requestStack
     */
    public function __construct( MenuPluginRegistry $menuPluginRegistry, RequestStack $requestStack )
    {
        $this->menuPluginRegistry = $menuPluginRegistry;
        $this->requestStack = $requestStack;
    }

    /**
     * Returns all menu plugins
     *
     * @return \Netgen\Bundle\MoreAdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    public function getMenuPlugins()
    {
        return $this->menuPluginRegistry->getMenuPlugins();
    }

    /**
     * Returns the identifier of the current menu plugin
     *
     * @return string
     */
    public function getCurrentMenuPlugin()
    {
        $currentRequest = $this->requestStack->getCurrentRequest();
        if ( !$currentRequest instanceof Request )
        {
            return false;
        }

        foreach ( $this->menuPluginRegistry->getMenuPlugins() as $identifier => $menuPlugin )
        {
            if ( $menuPlugin->matches( $currentRequest ) )
            {
                return $identifier;
            }
        }

        return false;
    }
}
