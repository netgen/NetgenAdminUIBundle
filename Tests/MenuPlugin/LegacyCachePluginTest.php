<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\MenuPlugin;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\LegacyCachePlugin;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Request;

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
        $this->assertInstanceOf(MenuPluginInterface::class, $this->plugin);
    }

    public function testGetIdentifier()
    {
        $this->assertEquals('legacy_cache', $this->plugin->getIdentifier());
    }

    public function testGetTemplates()
    {
        $template = array(
            'aside' => 'NetgenAdminUIBundle:menu/plugins/legacy_cache:aside.html.twig',
        );

        $this->assertEquals($template, $this->plugin->getTemplates());
    }

    public function testIsActive()
    {
        $this->assertTrue($this->plugin->isActive());
    }

    public function testMatches()
    {
        $request = $this->getMockBuilder(Request::class)
            ->disableOriginalConstructor()
            ->setMethods(array())
            ->getMock();

        $this->assertFalse($this->plugin->matches($request));
    }
}
