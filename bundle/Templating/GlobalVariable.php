<?php

namespace Netgen\Bundle\AdminUIBundle\Templating;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;

class GlobalVariable
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry
     */
    protected $menuPluginRegistry;

    /**
     * @var \Symfony\Component\HttpFoundation\RequestStack
     */
    protected $requestStack;

    /**
     * @var string
     */
    protected $logoType;

    /**
     * Constructor.
     *
     * @param \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry $menuPluginRegistry
     * @param \Symfony\Component\HttpFoundation\RequestStack $requestStack
     * @param string $logoType
     */
    public function __construct(
        MenuPluginRegistry $menuPluginRegistry,
        RequestStack $requestStack,
        $logoType
    ) {
        $this->menuPluginRegistry = $menuPluginRegistry;
        $this->requestStack = $requestStack;
        $this->logoType = $logoType;
    }

    /**
     * Returns all menu plugins.
     *
     * @return \Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface[]
     */
    public function getMenuPlugins()
    {
        return $this->menuPluginRegistry->getMenuPlugins();
    }

    /**
     * Returns the logo type.
     *
     * @return string
     */
    public function getLogoType()
    {
        return $this->logoType;
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
