<?php

namespace Netgen\Bundle\AdminUIBundle\Controller;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Types\Type;
use eZ\Publish\API\Repository\Values\Content\Content;
use eZ\Publish\API\Repository\Values\Content\Location;
use eZ\Publish\Core\MVC\Symfony\View\ContentView;
use Netgen\BlockManager\API\Service\LayoutService;
use Netgen\BlockManager\API\Values\Layout\Layout;
use Netgen\BlockManager\API\Values\Value;
use Netgen\BlockManager\Layout\Resolver\LayoutResolverInterface;
use PDO;
use Symfony\Component\HttpFoundation\Request;

class LayoutsController extends Controller
{
    /**
     * @var \Netgen\BlockManager\Layout\Resolver\LayoutResolverInterface
     */
    protected $layoutResolver;

    /**
     * @var \Netgen\BlockManager\API\Service\LayoutService
     */
    protected $layoutService;

    /**
     * @var \Doctrine\DBAL\Connection
     */
    protected $databaseConnection;

    public function __construct(
        LayoutResolverInterface $layoutResolver,
        LayoutService $layoutService,
        Connection $databaseConnection
    ) {
        $this->layoutResolver = $layoutResolver;
        $this->layoutService = $layoutService;
        $this->databaseConnection = $databaseConnection;
    }

    /**
     * Renders a template that shows all layouts applied to provided location.
     *
     * @param int|string $locationId
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function showLocationMappings($locationId)
    {
        $repository = $this->getRepository();

        $location = $repository->getLocationService()->loadLocation($locationId);
        $content = $repository->getContentService()->loadContent($location->contentInfo->id);

        $request = $this->createRequest($content, $location);

        $rules = $this->layoutResolver->resolveRules($request, array('ez_content_type'));

        return $this->render(
            '@NetgenAdminUI/layouts/location_mappings.html.twig',
            array(
                'rules' => $rules,
                'content' => $content,
                'location' => $location,
            )
        );
    }

    /**
     * Renders a template that shows all layouts related to provided location.
     *
     * @param int|string $locationId
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function showRelatedLayouts($locationId)
    {
        $repository = $this->getRepository();

        $location = $repository->getLocationService()->loadLocation($locationId);

        $query = $this->databaseConnection->createQueryBuilder();

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

        return $this->render(
            '@NetgenAdminUI/layouts/related_layouts.html.twig',
            array(
                'related_layouts' => $relatedLayouts,
                'location' => $location,
            )
        );
    }

    /**
     * Creates the request used for fetching the mappings applied to provided content and location.
     *
     * @param \eZ\Publish\API\Repository\Values\Content\Content $content
     * @param \eZ\Publish\API\Repository\Values\Content\Location $location
     *
     * @return \Symfony\Component\HttpFoundation\Request
     */
    protected function createRequest(Content $content, Location $location)
    {
        $request = Request::create('');

        $request->attributes->set('content', $content);
        $request->attributes->set('location', $location);

        if (interface_exists('eZ\Publish\Core\MVC\Symfony\View\ContentValueView')) {
            $contentView = new ContentView();
            $contentView->setLocation($location);
            $contentView->setContent($content);

            $request->attributes->set('view', $contentView);
        }

        return $request;
    }

    /**
     * Performs access checks on the controller.
     */
    protected function checkPermissions()
    {
        $this->denyAccessUnlessGranted('ROLE_NGBM_EDITOR');
    }
}
