<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\MenuPlugin;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\LegacyCachePlugin;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\LegacyMenuPlugin;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry;
use PHPUnit\Framework\TestCase;

class MenuPluginRegistryTest extends TestCase
{
    public function testRegistry()
    {
        $registry = new MenuPluginRegistry();
        $cache = new LegacyCachePlugin();
        $registry->addMenuPlugin($cache);
        $menu = new LegacyMenuPlugin();
        $registry->addMenuPlugin($menu);

        $this->assertEquals(
            array(
                $cache->getIdentifier() => $cache,
                $menu->getIdentifier() => $menu,
            ),
            $registry->getMenuPlugins()
        );
    }
}
