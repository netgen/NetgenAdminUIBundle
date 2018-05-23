<?php

namespace Netgen\Bundle\AdminUIBundle\Layouts;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Types\Type;
use eZ\Publish\API\Repository\Values\Content\Location;
use Netgen\BlockManager\API\Service\LayoutService;
use Netgen\BlockManager\API\Values\Layout\Layout;
use Netgen\BlockManager\API\Values\Value;
use Netgen\BlockManager\Version;
use PDO;

class RelatedLayoutsLoader
{
    /**
     * @var \Netgen\BlockManager\API\Service\LayoutService
     */
    protected $layoutService;

    /**
     * @var \Doctrine\DBAL\Connection
     */
    protected $databaseConnection;

    public function __construct(
        LayoutService $layoutService,
        Connection $databaseConnection
    ) {
        $this->layoutService = $layoutService;
        $this->databaseConnection = $databaseConnection;
    }

    /**
     * Returns all layouts related to provided location and its content, sorted by name.
     *
     * Related layout is a layout where the location or its content are referenced by
     * a manual item in one of the block collections.
     *
     * @param \eZ\Publish\API\Repository\Values\Content\Location $location
     *
     * @return \Netgen\BlockManager\API\Values\Layout\Layout[]
     */
    public function loadRelatedLayouts(Location $location)
    {
        $query = $this->databaseConnection->createQueryBuilder();

        $valueColumnName = Version::VERSION_ID < 1100 ? 'value_id' : 'value';

        $query->select('DISTINCT b.layout_id')
            ->from('ngbm_collection_item', 'ci')
            ->innerJoin(
                'ci',
                'ngbm_block_collection',
                'bc',
                $query->expr()->andX(
                    $query->expr()->eq('bc.collection_id', 'ci.collection_id'),
                    $query->expr()->eq('bc.collection_status', 'ci.status')
                )
            )
            ->innerJoin(
                'bc',
                'ngbm_block',
                'b',
                $query->expr()->andX(
                    $query->expr()->eq('b.id', 'bc.block_id'),
                    $query->expr()->eq('b.status', 'bc.block_status')
                )
            )
            ->where(
                $query->expr()->andX(
                    $query->expr()->orX(
                        $query->expr()->andX(
                            $query->expr()->eq('ci.value_type', ':content_value_type'),
                            $query->expr()->eq('ci.' . $valueColumnName, ':content_id')
                        ),
                        $query->expr()->andX(
                            $query->expr()->eq('ci.value_type', ':location_value_type'),
                            $query->expr()->eq('ci.' . $valueColumnName, ':location_id')
                        )
                    ),
                    $query->expr()->eq('ci.status', ':status')
                )
            )
            ->setParameter('status', Value::STATUS_PUBLISHED, Type::INTEGER)
            ->setParameter('content_value_type', 'ezcontent', Type::STRING)
            ->setParameter('location_value_type', 'ezlocation', Type::STRING)
            ->setParameter('content_id', $location->contentInfo->id, Type::INTEGER)
            ->setParameter('location_id', $location->id, Type::INTEGER);

        $relatedLayouts = array_map(
            function (array $dataRow) {
                return $this->layoutService->loadLayout($dataRow['layout_id']);
            },
            $query->execute()->fetchAll(PDO::FETCH_ASSOC)
        );

        usort(
            $relatedLayouts,
            function (Layout $layout1, Layout $layout2) {
                if ($layout1->getName() === $layout2->getName()) {
                    return 0;
                }

                return $layout1->getName() > $layout2->getName() ? 1 : -1;
            }
        );

        return $relatedLayouts;
    }
}
