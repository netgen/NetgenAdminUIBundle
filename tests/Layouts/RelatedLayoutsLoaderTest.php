<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\Layouts;

use eZ\Publish\API\Repository\Values\Content\ContentInfo;
use eZ\Publish\Core\Repository\Values\Content\Location;
use Netgen\Bundle\AdminUIBundle\Layouts\RelatedLayoutsLoader;
use Netgen\Layouts\Core\Values\Layout\Layout;
use PHPUnit\Framework\TestCase;

class RelatedLayoutsLoaderTest extends TestCase
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\Layouts\RelatedLayoutsLoader
     */
    protected $loader;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $layoutService;

    /**
     * @var \PHPUnit_Framework_MockObject_MockObject
     */
    protected $databaseConnection;

    public function setUp()
    {
        if (
            !interface_exists('\Netgen\Layouts\API\Service\LayoutService')
            || !interface_exists('\Netgen\Layouts\API\Values\Layout\Layout')
            || !interface_exists('\Netgen\Layouts\API\Values\Value')
            ) {
            $this->markTestSkipped();
        }

        $this->layoutService = $this->getMockBuilder('Netgen\Layouts\API\Service\LayoutService')
            ->disableOriginalConstructor()
            ->getMock();

        $this->databaseConnection = $this->getMockBuilder('Doctrine\DBAL\Connection')
            ->disableOriginalConstructor()
            ->getMock();

        $this->loader = new RelatedLayoutsLoader($this->layoutService, $this->databaseConnection);
    }

    public function testLoadRelatedLayouts()
    {
        $contentInfo = new ContentInfo();

        $location = new Location(
            array(
                'contentInfo' => $contentInfo,
            )
        );

        $queryBuilder = $this->getMockBuilder('Doctrine\DBAL\Query\QueryBuilder')
            ->disableOriginalConstructor()
            ->getMock();

        $expressionBuilder = $this->getMockBuilder('Doctrine\DBAL\Query\Expression\ExpressionBuilder')
            ->disableOriginalConstructor()
            ->getMock();

        $statement = $this->getMockBuilder('Doctrine\DBAL\Driver\Statement')
            ->disableOriginalConstructor()
            ->getMock();

        $this->databaseConnection
            ->expects($this->once())
            ->method('createQueryBuilder')
            ->willReturn($queryBuilder);

        $queryBuilder
            ->expects($this->once())
            ->method('select')
            ->willReturn($queryBuilder);

        $queryBuilder
            ->expects($this->once())
            ->method('from')
            ->willReturn($queryBuilder);

        $queryBuilder
            ->expects($this->exactly(2))
            ->method('innerJoin')
            ->willReturn($queryBuilder);

        $queryBuilder
            ->expects($this->exactly(15))
            ->method('expr')
            ->willReturn($expressionBuilder);

        $queryBuilder
            ->expects($this->once())
            ->method('where')
            ->willReturn($queryBuilder);

        $queryBuilder
            ->expects($this->exactly(5))
            ->method('setParameter')
            ->willReturn($queryBuilder);

        $expressionBuilder
            ->expects($this->exactly(5))
            ->method('andX');

        $expressionBuilder
            ->expects($this->once())
            ->method('orX');

        $expressionBuilder
            ->expects($this->exactly(9))
            ->method('eq');

        $queryBuilder
            ->expects($this->once())
            ->method('execute')
            ->willReturn($statement);

        $layoutRows = array(
            array(
                'layout_id' => 5,
            ),
            array(
                'layout_id' => 6,
            ),
            array(
                'layout_id' => 7,
            ),
        );

        $layout1 = new Layout(array('name' => 'Frontpage'));
        $layout2 = new Layout(array('name' => 'Article'));
        $layout3 = new Layout(array('name' => 'Article'));

        $statement
            ->expects($this->once())
            ->method('fetchAll')
            ->willReturn($layoutRows);

        $this->layoutService
            ->expects($this->exactly(3))
            ->method('loadLayout')
            ->withConsecutive(
                array(5),
                array(6),
                array(7)
            )
            ->willReturnOnConsecutiveCalls($layout1, $layout2, $layout3);

        $result = array($layout2, $layout3, $layout1);

        $this->assertEquals($result, $this->loader->loadRelatedLayouts($location));
    }
}
