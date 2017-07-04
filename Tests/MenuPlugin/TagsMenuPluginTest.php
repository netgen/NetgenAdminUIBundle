<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\MenuPlugin;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\TagsMenuPlugin;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Request;

class TagsMenuPluginTest extends TestCase
{
    /**
     * @var MenuPluginInterface
     */
    protected $plugin;

    /**
     * @var MenuPluginInterface
     */
    protected $pluginWithoutTags;

    public function setUp()
    {
        $this->plugin = new TagsMenuPlugin(array(
            'NetgenTagsBundle' => 'Netgen\\Bundle\\TagsBundle',
        ));
        $this->pluginWithoutTags = new TagsMenuPlugin(array());
    }

    public function testAssertInstanceOfMenuPlugin()
    {
        $this->assertInstanceOf('Netgen\\Bundle\\AdminUIBundle\\MenuPlugin\\MenuPluginInterface', $this->plugin);
    }

    public function testGetIdentifier()
    {
        $this->assertEquals('tags', $this->plugin->getIdentifier());
    }

    public function testGetTemplates()
    {
        $template = array(
            'aside' => '@NetgenAdminUI/menu/plugins/tags/aside.html.twig',
            'left' => '@NetgenAdminUI/menu/plugins/tags/left.html.twig',
        );

        $this->assertEquals($template, $this->plugin->getTemplates());
    }

    public function testIsActiveWithoutTagsVersion()
    {
        $this->assertFalse($this->plugin->isActive());
    }

    public function testIsActive()
    {
        require __DIR__ . '/Tags/Version.php';
        $this->assertFalse($this->pluginWithoutTags->isActive());
        $this->assertTrue($this->plugin->isActive());
    }

    public function testMatchesWithTagsRoute()
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
            ->willReturn('netgen_tags_admin');

        $this->assertTrue($this->plugin->matches($request));
    }

    public function testMatchesWithNonTagsRoute()
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
