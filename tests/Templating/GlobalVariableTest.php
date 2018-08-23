<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\Templating;

use Netgen\Bundle\AdminUIBundle\Templating\GlobalVariable;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Request;

class GlobalVariableTest extends TestCase
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\Templating\GlobalVariable
     */
    protected $globalVariable;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $menuPluginRegistry;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $requestStack;

    /**
     * @var string
     */
    protected $logoType;

    public function setUp()
    {
        $this->menuPluginRegistry = $this->getMockBuilder('Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginRegistry')
            ->disableOriginalConstructor()
            ->getMock();

        $this->requestStack = $this->getMockBuilder('Symfony\Component\HttpFoundation\RequestStack')
            ->disableOriginalConstructor()
            ->getMock();

        $this->logoType = 'logo1';

        $this->globalVariable = new GlobalVariable($this->menuPluginRegistry, $this->requestStack, $this->logoType);
    }

    public function testGetMenuPlugins()
    {
        $menuPlugins = array(
            'menu_plugin_1',
            'menu_plugin_2',
            'menu_plugin_3',
        );

        $this->menuPluginRegistry
            ->expects($this->once())
            ->method('getMenuPlugins')
            ->willReturn($menuPlugins)
        ;

        $this->assertEquals($menuPlugins, $this->globalVariable->getMenuPlugins());
    }

    public function testGetLogoType()
    {
        $this->assertEquals($this->logoType, $this->globalVariable->getLogoType());
    }

    public function testGetCurrentMenuPluginNoRequest()
    {
        $this->requestStack
            ->expects($this->once())
            ->method('getCurrentRequest')
            ->willReturn(null)
        ;

        $this->assertFalse($this->globalVariable->getCurrentMenuPlugin());
    }

    public function testGetCurrentMenuPlugin()
    {
        $request = new Request();

        $menuPlugin = $this->getMockBuilder('Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface')
            ->disableOriginalConstructor()
            ->getMock();

        $menuPlugins = array(
            'menu_plugin_1' => $menuPlugin,
            'menu_plugin_2' => $menuPlugin,
            'menu_plugin_3' => $menuPlugin,
        );

        $this->requestStack
            ->expects($this->once())
            ->method('getCurrentRequest')
            ->willReturn($request)
        ;

        $this->menuPluginRegistry
            ->expects($this->once())
            ->method('getMenuPlugins')
            ->willReturn($menuPlugins)
        ;

        $menuPlugin
            ->expects($this->exactly(2))
            ->method('matches')
            ->willReturnOnConsecutiveCalls(false, true)
        ;

        $this->assertEquals('menu_plugin_2', $this->globalVariable->getCurrentMenuPlugin());
    }

    public function testGetCurrentMenuPluginNoMatch()
    {
        $request = new Request();

        $menuPlugin = $this->getMockBuilder('Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface')
            ->disableOriginalConstructor()
            ->getMock();

        $menuPlugins = array(
            'menu_plugin_1' => $menuPlugin,
            'menu_plugin_2' => $menuPlugin,
            'menu_plugin_3' => $menuPlugin,
        );

        $this->requestStack
            ->expects($this->once())
            ->method('getCurrentRequest')
            ->willReturn($request)
        ;

        $this->menuPluginRegistry
            ->expects($this->once())
            ->method('getMenuPlugins')
            ->willReturn($menuPlugins)
        ;

        $menuPlugin
            ->expects($this->exactly(3))
            ->method('matches')
            ->with($request)
            ->willReturnOnConsecutiveCalls(false, false, false)
        ;

        $this->assertFalse($this->globalVariable->getCurrentMenuPlugin());
    }
}
