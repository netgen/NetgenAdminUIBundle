<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\MenuPlugin;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\LegacyBookmarksPlugin;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use PHPUnit\Framework\TestCase;

class LegacyBookmarksPluginTest extends TestCase
{
    /**
     * @var MenuPluginInterface
     */
    protected $plugin;

    public function setUp()
    {
        $this->plugin = new LegacyBookmarksPlugin();
    }

    public function testAssertInstanceOfMenuPlugin()
    {
        $this->assertInstanceOf('Netgen\\Bundle\\AdminUIBundle\\MenuPlugin\\MenuPluginInterface', $this->plugin);
    }

    public function testGetIdentifier()
    {
        $this->assertEquals('legacy_bookmarks', $this->plugin->getIdentifier());
    }

    public function testGetTemplates()
    {
        $template = array(
            'aside' => '@NetgenAdminUI/menu/plugins/legacy_bookmarks/aside.html.twig',
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
