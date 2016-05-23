<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

class MenuPluginRegistry
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    protected $menuPlugins = array();

    /**
     * Adds a menu plugin to registry.
     *
     * @param \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface $menuPlugin
     */
    public function addMenuPlugin(MenuPluginInterface $menuPlugin)
    {
        $this->menuPlugins[$menuPlugin->getIdentifier()] = $menuPlugin;
    }

    /**
     * Returns all menu plugins.
     *
     * @return \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    public function getMenuPlugins()
    {
        return $this->menuPlugins;
    }
}
