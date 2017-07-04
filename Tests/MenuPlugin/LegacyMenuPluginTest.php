<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\MenuPlugin;

use eZ\Publish\Core\MVC\Symfony\Routing\UrlAliasRouter;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\LegacyMenuPlugin;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Request;

class LegacyMenuPluginTest extends TestCase
{
    /**
     * @var MenuPluginInterface
     */
    protected $plugin;

    public function setUp()
    {
        require_once __DIR__ . '/Legacy/FallbackRouter.php';
        $this->plugin = new LegacyMenuPlugin();
    }

    public function testAssertInstanceOfMenuPlugin()
    {
        $this->assertInstanceOf('Netgen\\Bundle\\AdminUIBundle\\MenuPlugin\\MenuPluginInterface', $this->plugin);
    }

    public function testGetIdentifier()
    {
        $this->assertEquals('legacy', $this->plugin->getIdentifier());
    }

    public function testGetTemplates()
    {
        $template = array(
            'aside' => '@NetgenAdminUI/menu/plugins/legacy/aside.html.twig',
            'left' => '@NetgenAdminUI/menu/plugins/legacy/left.html.twig',
            'top' => '@NetgenAdminUI/menu/plugins/legacy/top.html.twig',
        );

        $this->assertEquals($template, $this->plugin->getTemplates());
    }

    public function testIsActive()
    {
        $this->assertTrue($this->plugin->isActive());
    }

    public function testMatchesWithEzRoute()
    {
        $request = new Request();

        $attributes = $this->getMockBuilder('Symfony\\Component\\HttpFoundation\\ParameterBag')
            ->disableOriginalConstructor()
            ->setMethods(array('get'))
            ->getMock();

        $request->attributes = $attributes;

        $attributes->expects($this->once())
            ->method('get')
            ->with('_route')
            ->willReturn('ez_legacy');

        $this->assertTrue($this->plugin->matches($request));
    }

    public function testMatchesWithUrlAliasRoute()
    {
        $request = new Request();

        $attributes = $this->getMockBuilder('Symfony\\Component\\HttpFoundation\\ParameterBag')
            ->disableOriginalConstructor()
            ->setMethods(array('get'))
            ->getMock();

        $request->attributes = $attributes;

        $attributes->expects($this->once())
            ->method('get')
            ->with('_route')
            ->willReturn(UrlAliasRouter::URL_ALIAS_ROUTE_NAME);

        $this->assertTrue($this->plugin->matches($request));
    }

    public function testMatchesWithFakeRoute()
    {
        $request = new Request();

        $attributes = $this->getMockBuilder('Symfony\\Component\\HttpFoundation\\ParameterBag')
            ->disableOriginalConstructor()
            ->setMethods(array('get'))
            ->getMock();

        $request->attributes = $attributes;

        $attributes->expects($this->once())
            ->method('get')
            ->with('_route')
            ->willReturn('something');

        $this->assertFalse($this->plugin->matches($request));
    }
}
