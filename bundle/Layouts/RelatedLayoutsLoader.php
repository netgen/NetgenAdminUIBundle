<?php

namespace Netgen\Bundle\AdminUIBundle\Layouts;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Types\Type;
use eZ\Publish\API\Repository\Values\Content\Location;
use Netgen\Layouts\API\Service\LayoutService;
use Netgen\Layouts\API\Values\Layout\Layout;
use Netgen\Layouts\API\Values\Value;
use PDO;
use Ramsey\Uuid\Uuid;

class RelatedLayoutsLoader
{
    /**
     * @var \Netgen\Layouts\API\Service\LayoutService
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
     * @return \Netgen\Layouts\API\Values\Layout\Layout[]
     */
    public function loadRelatedLayouts(Location $location)
    {
        $query = $this->databaseConnection->createQueryBuilder();

        $query->select('DISTINCT l.uuid')
            ->from('nglayouts_collection_item', 'ci')
            ->innerJoin(
                'ci',
                'nglayouts_block_collection',
                'bc',
                $query->expr()->andX(
                    $query->expr()->eq('bc.collection_id', 'ci.collection_id'),
                    $query->expr()->eq('bc.collection_status', 'ci.status')
                )
            )
            ->innerJoin(
                'bc',
                'nglayouts_block',
                'b',
                $query->expr()->andX(
                    $query->expr()->eq('b.id', 'bc.block_id'),
                    $query->expr()->eq('b.status', 'bc.block_status')
                )
            )
            ->innerJoin(
                'b',
                'nglayouts_layout',
                'l',
                $query->expr()->andX(
                    $query->expr()->eq('l.id', 'b.layout_id'),
                    $query->expr()->eq('l.status', 'b.status')
                )
            )
            ->where(
                $query->expr()->andX(
                    $query->expr()->orX(
                        $query->expr()->andX(
                            $query->expr()->eq('ci.value_type', ':content_value_type'),
                            $query->expr()->eq('ci.value', ':content_id')
                        ),
                        $query->expr()->andX(
                            $query->expr()->eq('ci.value_type', ':location_value_type'),
                            $query->expr()->eq('ci.value', ':location_id')
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
                return $this->layoutService->loadLayout(Uuid::fromString($dataRow['uuid']));
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
