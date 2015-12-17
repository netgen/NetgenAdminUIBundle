<?php

namespace Netgen\Bundle\MoreAdminUIBundle;

use Symfony\Component\HttpKernel\Bundle\Bundle;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Netgen\Bundle\MoreAdminUIBundle\DependencyInjection\CompilerPass\MenuPluginRegistryPass;

class NetgenMoreAdminUIBundle extends Bundle
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
        parent::build($container);

        $container->addCompilerPass(new MenuPluginRegistryPass());
    }
}
