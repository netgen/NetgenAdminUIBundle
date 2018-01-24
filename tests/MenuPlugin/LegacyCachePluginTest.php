<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\MenuPlugin;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\LegacyCachePlugin;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use PHPUnit\Framework\TestCase;

class LegacyCachePluginTest extends TestCase
{
    /**
     * @var MenuPluginInterface
     */
    protected $plugin;

    public function setUp()
    {
        $this->plugin = new LegacyCachePlugin();
    }

    public function testAssertInstanceOfMenuPlugin()
    {
        $this->assertInstanceOf('Netgen\\Bundle\\AdminUIBundle\\MenuPlugin\\MenuPluginInterface', $this->plugin);
    }

    public function testGetIdentifier()
    {
        $this->assertEquals('legacy_cache', $this->plugin->getIdentifier());
    }

    public function testGetTemplates()
    {
        $template = array(
            'aside' => '@NetgenAdminUI/menu/plugins/legacy_cache/aside.html.twig',
        );

        $this->assertEquals($template, $this->plugin->getTemplates());
    }

    public function testIsActive()
    {
        $this->assertTrue($this->plugin->isActive());
    }

    public function testMatches()
    {
        $request = $this->getMockBuilder('Symfony\\Component\\HttpFoundation\\Request')
            ->disableOriginalConstructor()
            ->setMethods(array())
            ->getMock();

        $this->assertFalse($this->plugin->matches($request));
    }
}
