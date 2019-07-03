<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\Helper;

use eZ\Publish\API\Repository\Values\Content\ContentInfo;
use eZ\Publish\Core\Base\Exceptions\UnauthorizedException;
use eZ\Publish\Core\Repository\Values\Content\Location;
use Netgen\Bundle\AdminUIBundle\Helper\PathHelper;
use Netgen\Bundle\AdminUIBundle\Tests\Stubs\ConfigResolverStub;
use PHPUnit\Framework\TestCase;

class PathHelperTest extends TestCase
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\Helper\PathHelper
     */
    protected $helper;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $locationService;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $translationHelper;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $router;

    /**
     * @var \eZ\Publish\Core\Repository\Values\Content\Location
     */
    protected $rootLocation;

    public function setUp()
    {
        $this->locationService = $this->getMockBuilder('eZ\Publish\API\Repository\LocationService')
            ->disableOriginalConstructor()
            ->getMock();
        $this->translationHelper = $this->getMockBuilder('eZ\Publish\Core\Helper\TranslationHelper')
            ->disableOriginalConstructor()
            ->getMock();
        $this->router = $this->getMockBuilder('Symfony\Component\Routing\RouterInterface')
            ->disableOriginalConstructor()
            ->getMock();

        $this->rootLocation = new Location(array(
            'id' => 2,
            'path' => array(1, 2),
            'contentInfo' => new ContentInfo(array(
                'name' => 'Test Root Name',
                'id' => 8,
            )),
        ));

        $this->helper = new PathHelper(
            $this->locationService,
            $this->translationHelper,
            new ConfigResolverStub(
                array(
                    'ezsettings' => array(
                        'content.tree_root.location_id' => $this->rootLocation->id,
                    ),
                )
            ),
            $this->router
        );
    }

    public function testGetPath()
    {
        $location = new Location(array(
            'id' => 5,
            'path' => array(1, 2, 5),
            'contentInfo' => new ContentInfo(array(
                'name' => 'Test Content Name',
                'id' => 10,
            )),
        ));

        $this->locationService
            ->expects($this->exactly(3))
            ->method('loadLocation')
            ->withConsecutive(
                array($location->id),
                array($this->rootLocation->id),
                array($location->id)
            )
            ->willReturnOnConsecutiveCalls(
                $location,
                $this->rootLocation,
                $location
            )
        ;

        $this->translationHelper
            ->expects($this->exactly(2))
            ->method('getTranslatedContentNameByContentInfo')
            ->withConsecutive(array($this->rootLocation->getContentInfo()), array($location->getContentInfo()))
            ->willReturnOnConsecutiveCalls($this->rootLocation->getContentInfo()->name, $location->getContentInfo()->name)
        ;

        $this->router
            ->expects($this->once())
            ->method('generate')
            ->with($this->rootLocation)
            ->willReturn('/root_location_url')
        ;

        $expectedResponse = array(
            array(
                'text' => $this->rootLocation->getContentInfo()->name,
                'url' => '/root_location_url',
                'locationId' => $this->rootLocation->id,
                'contentId' => $this->rootLocation->getContentInfo()->id,
            ),
            array(
                'text' => $location->getContentInfo()->name,
                'url' => false,
                'locationId' => $location->id,
                'contentId' => $location->getContentInfo()->id,
            ),
        );

        $this->assertEquals($expectedResponse, $this->helper->getPath($location->id));
    }

    public function testGetPathUnauthorized()
    {
        $location = new Location(array(
            'id' => 5,
            'path' => array(1, 7, 2, 5),
        ));

        $this->locationService
            ->expects($this->exactly(2))
            ->method('loadLocation')
            ->withConsecutive(
                array($location->id),
                array($this->rootLocation->id)
            )
            ->willReturnCallback(
                function ($parameter) use ($location) {
                    if ($parameter === $location->id) {
                        return $location;
                    }
                    throw new UnauthorizedException('test_module', 'test_function');
                }
            )
        ;

        $this->assertEquals(array(), $this->helper->getPath($location->id));
    }
}
