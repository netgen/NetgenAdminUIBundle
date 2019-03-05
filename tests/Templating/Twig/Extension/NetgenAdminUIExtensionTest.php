<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\Templating\Twig\Extension;

use Netgen\Bundle\AdminUIBundle\Templating\Twig\Extension\NetgenAdminUIExtension;
use PHPUnit\Framework\TestCase;

class NetgenAdminUIExtensionTest extends TestCase
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\Templating\Twig\Extension\NetgenAdminUIExtension
     */
    protected $extension;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $pathHelper;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $legacyKernel;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $mockedKernel;

    public function setUp()
    {
        $this->pathHelper = $this->getMockBuilder('Netgen\Bundle\AdminUIBundle\Helper\PathHelper')
            ->disableOriginalConstructor()
            ->getMock();

        $this->mockedKernel = $this->getMockBuilder('stdClass')
            ->setMethods(array('runCallback'))
            ->getMock();

        $callbackMock = function () {
            return $this->mockedKernel;
        };

        $this->extension = new NetgenAdminUIExtension($this->pathHelper, $callbackMock);
    }

    public function testGetName()
    {
        $this->assertEquals('netgen_admin_ui', $this->extension->getName());
    }

    public function testGetFunctions()
    {
        $this->assertNotEmpty($this->extension->getFunctions());

        foreach ($this->extension->getFunctions() as $function) {
            $this->assertInstanceOf('Twig_SimpleFunction', $function);
        }
    }

    public function testGetLocationPath()
    {
        $locationId = 20;
        $path = '/2/15/20';

        $this->pathHelper
            ->expects($this->once())
            ->method('getPath')
            ->with($locationId)
            ->willReturn($path)
        ;

        $this->assertEquals($path, $this->extension->getLocationPath($locationId));
    }

    public function testGetLegacyPreference()
    {
        $name = 'test';

        $callback = function () use ($name) {
            return $name;
        };

        $this->mockedKernel
            ->expects($this->once())
            ->method('runCallback')
            ->willReturnCallback($callback);

        $this->assertEquals($name, $this->extension->getLegacyPreference($name));
    }
}
