<?php

namespace Netgen\Bundle\MoreAdminUIBundle\MenuPlugin;

class MenuPluginRegistry
{
    /**
     * @var \Netgen\Bundle\MoreAdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    protected $menuPlugins = array();

    /**
     * Adds a menu plugin to registry
     *
     * @param \Netgen\Bundle\MoreAdminUIBundle\MenuPlugin\MenuPluginInterface $menuPlugin
     */
    public function addMenuPlugin( MenuPluginInterface $menuPlugin )
    {
        $this->menuPlugins[$menuPlugin->getIdentifier()] = $menuPlugin;
    }

    /**
     * Returns all menu plugins
     *
     * @return \Netgen\Bundle\MoreAdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    public function getMenuPlugins()
    {
        return $this->menuPlugins;
    }
}
