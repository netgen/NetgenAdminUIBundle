<?php

namespace Netgen\Bundle\AdminUIBundle\DependencyInjection\CompilerPass;

use Symfony\Component\DependencyInjection\Compiler\CompilerPassInterface;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Reference;

class MenuPluginRegistryPass implements CompilerPassInterface
{
    /**
     * Registers all menu plugins in the plugin registry.
     *
     * @param \Symfony\Component\DependencyInjection\ContainerBuilder $container
     */
    public function process(ContainerBuilder $container)
    {
        if (!$container->has('netgen_admin_ui.menu_plugin.registry')) {
            return;
        }

        $menuPluginRegistry = $container->findDefinition('netgen_admin_ui.menu_plugin.registry');
        $menuPlugins = $container->findTaggedServiceIds('netgen_admin_ui.menu_plugin');

        $flattenedMenuPlugins = array();
        foreach ($menuPlugins as $identifier => $menuPlugin) {
            $flattenedMenuPlugins[$identifier] = isset($menuPlugin[0]['priority']) ? $menuPlugin[0]['priority'] : 0;
        }

        arsort($flattenedMenuPlugins);

        foreach (array_keys($flattenedMenuPlugins) as $menuPlugin) {
            $definition = $container->findDefinition($menuPlugin);

            $menuPluginClass = $definition->getClass();
            if (stripos($menuPluginClass, '%') === 0) {
                $menuPluginClass = $container->getParameter(trim($menuPluginClass, '%'));
            }

            if (!method_exists($menuPluginClass, 'isActive')) {
                // @todo Add isActive method to MenuPluginInterface
                @trigger_error(
                    sprintf(
                        'Menu plugin %s does not implement "isActive" method. This behaviour is deprecated since version 1.1 of Netgen Admin UI bundle and will stop working in version 2.0. Implement the method to remove this notice.',
                        $menuPluginClass
                    ),
                    E_USER_DEPRECATED
                );
            }

            $menuPluginRegistry->addMethodCall(
                'addMenuPlugin',
                array(new Reference($menuPlugin))
            );
        }
    }
}
