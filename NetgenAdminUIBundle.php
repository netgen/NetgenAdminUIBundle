<?php

namespace Netgen\Bundle\AdminUIBundle;

use Symfony\Component\HttpKernel\Bundle\Bundle;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Netgen\Bundle\AdminUIBundle\DependencyInjection\CompilerPass\MenuPluginRegistryPass;

class NetgenAdminUIBundle extends Bundle
{
    /**
     * Builds the bundle.
     *
     * It is only ever called once when the cache is empty.
     *
     * @param \Symfony\Component\DependencyInjection\ContainerBuilder $container
     */
    public function build(ContainerBuilder $container)
    {
        $container->addCompilerPass(new MenuPluginRegistryPass());
    }
}
