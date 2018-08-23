<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\DependencyInjection\CompilerPass;

use Matthias\SymfonyDependencyInjectionTest\PhpUnit\AbstractCompilerPassTestCase;
use Netgen\Bundle\AdminUIBundle\DependencyInjection\CompilerPass\MenuPluginRegistryPass;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Definition;
use Symfony\Component\DependencyInjection\Reference;

class MenuPluginRegistryPassTest extends AbstractCompilerPassTestCase
{
    public function testWithoutMenuPluginRegistry()
    {
        $this->assertNull($this->compile());
    }

    public function testCompile()
    {
        $definition = new Definition();
        $definition->addTag('netgen_admin_ui.menu_plugin', array('priority' => 2));

        $this->setDefinition('netgen_admin_ui.menu_plugin.registry', $definition);

        $this->compile();

        $arguments = array(
            new Reference('netgen_admin_ui.menu_plugin.registry'),
        );

        $this->assertContainerBuilderHasServiceDefinitionWithMethodCall('netgen_admin_ui.menu_plugin.registry', 'addMenuPlugin', $arguments);
    }

    protected function registerCompilerPass(ContainerBuilder $container)
    {
        $container->addCompilerPass(new MenuPluginRegistryPass());
    }
}
