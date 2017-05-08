<?php

namespace Netgen\Bundle\AdminUIBundle\Templating;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;

class GlobalHelper
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    protected $menuPlugins;

    /**
     * @var \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry
     */
    protected $menuPluginRegistry;

    /**
     * @var \Symfony\Component\HttpFoundation\RequestStack
     */
    protected $requestStack;

    /**
     * Constructor.
     *
     * @param \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry $menuPluginRegistry
     * @param \Symfony\Component\HttpFoundation\RequestStack $requestStack
     */
    public function __construct(MenuPluginRegistry $menuPluginRegistry, RequestStack $requestStack)
    {
        $this->menuPluginRegistry = $menuPluginRegistry;
        $this->requestStack = $requestStack;
    }

    /**
     * Returns all menu plugins.
     *
     * @return \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    public function getMenuPlugins()
    {
        if ($this->menuPlugins !== null) {
            return $this->menuPlugins;
        }

        $this->menuPlugins = array();

        foreach ($this->menuPluginRegistry->getMenuPlugins() as $identifier => $menuPlugin) {
            if (method_exists($menuPlugin, 'isActive') && !$menuPlugin->isActive()) {
                continue;
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

            $this->menuPlugins[$identifier] = $menuPlugin;
        }

        return $this->menuPlugins;
    }

    /**
     * Returns the identifier of the current menu plugin.
     *
     * @return string
     */
    public function getCurrentMenuPlugin()
    {
        $currentRequest = $this->requestStack->getCurrentRequest();
        if (!$currentRequest instanceof Request) {
            return false;
        }

        foreach ($this->menuPluginRegistry->getMenuPlugins() as $identifier => $menuPlugin) {
            if ($menuPlugin->matches($currentRequest)) {
                return $identifier;
            }
        }

        return false;
    }
}
