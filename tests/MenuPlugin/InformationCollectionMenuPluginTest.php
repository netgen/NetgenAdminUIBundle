<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\MenuPlugin;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\InformationCollectionMenuPlugin;
use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use PHPUnit\Framework\TestCase;

class InformationCollectionMenuPluginTest extends TestCase
{
    /**
     * @var MenuPluginInterface
     */
    protected $plugin;

    public function setUp()
    {
        $activatedBundles = array(
            'NetgenInformationCollectionBundle' => 'NetgenInformationCollectionBundle',
            'NetgenRemoteMediaBundle' => 'NetgenRemoteMediaBundle',
            'NetgenTagsBundle' => 'NetgenTagsBundle',
        );

        $this->plugin = new InformationCollectionMenuPlugin($activatedBundles, true);
    }

    public function testGetIdentifier()
    {
        $this->assertEquals('information_collection', $this->plugin->getIdentifier());
    }

    public function testGetTemplates()
    {
        $result = array(
            'aside' => '@NetgenAdminUI/menu/plugins/information_collection/aside.html.twig',
            'left' => '@NetgenAdminUI/menu/plugins/information_collection/left.html.twig',
        );

        $this->assertEquals($result, $this->plugin->getTemplates());
    }

    public function testIsActive()
    {
        $this->assertTrue($this->plugin->isActive());
    }

    public function testIsActiveNoBundle()
    {
        $activatedBundles = array(
            'NetgenRemoteMediaBundle' => 'NetgenRemoteMediaBundle',
            'NetgenTagsBundle' => 'NetgenTagsBundle',
        );

        $plugin = new InformationCollectionMenuPlugin($activatedBundles, true);

        $this->assertFalse($plugin->isActive());
    }

    public function testMatches()
    {
        $request = $this->getMockBuilder('Symfony\Component\HttpFoundation\Request')
            ->disableOriginalConstructor()
            ->getMock();

        $parameterBag = $this->getMockBuilder('Symfony\Component\HttpFoundation\ParameterBag')
            ->disableOriginalConstructor()
            ->getMock();

        $request->attributes = $parameterBag;

        $parameterBag
            ->expects($this->once())
            ->method('get')
            ->with('_route')
            ->willReturn('netgen_information_collection');

        $this->assertTrue($this->plugin->matches($request));
    }
}
