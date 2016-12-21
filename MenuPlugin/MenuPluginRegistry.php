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
        if (method_exists($menuPlugin, 'isActive')) {
            if (!$menuPlugin->isActive()) {
                return;
            }
        }

        if (!method_exists($menuPlugin, 'isActive')) {
            // @todo Add isActive method to MenuPluginInterface
            @trigger_error(
                sprintf(
                    'Menu plugin %s does not implement "isActive" method. This behaviour is deprecated since version 1.1 of Netgen Admin UI bundle and will stop working in version 2.0. Implement the method to remove this notice.',
                    get_class($menuPlugin)
                ),
                E_USER_DEPRECATED
            );
        }

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
