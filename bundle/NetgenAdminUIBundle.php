<?php

namespace Netgen\Bundle\AdminUIBundle;

use Netgen\Bundle\AdminUIBundle\DependencyInjection\CompilerPass\MenuPluginRegistryPass;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\HttpKernel\Bundle\Bundle;

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
