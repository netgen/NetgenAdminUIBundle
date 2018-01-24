<?php

namespace Netgen\Bundle\AdminUIBundle\Controller;

use eZ\Publish\API\Repository\Values\Content\Content;
use eZ\Publish\API\Repository\Values\Content\Location;
use eZ\Publish\Core\MVC\Symfony\View\ContentView;
use Netgen\BlockManager\Layout\Resolver\LayoutResolverInterface;
use Netgen\Bundle\AdminUIBundle\Exception\InvalidArgumentException;
use Symfony\Component\HttpFoundation\Request;

class LayoutsController extends Controller
{
    /**
     * @var \Netgen\BlockManager\Layout\Resolver\LayoutResolverInterface
     */
    protected $layoutResolver;

    /**
     * Constructor.
     *
     * @param \Netgen\BlockManager\Layout\Resolver\LayoutResolverInterface $layoutResolver
     */
    public function __construct(LayoutResolverInterface $layoutResolver)
    {
        $this->layoutResolver = $layoutResolver;
    }

    /**
     * Renders a template that shows all layouts applied to provided location.
     *
     * @param int|string $contentId
     * @param int|string $locationId
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function showLocationMappings($contentId, $locationId)
    {
        $repository = $this->getRepository();

        $content = $repository->getContentService()->loadContent($contentId);
        $location = $repository->getLocationService()->loadLocation($locationId);

        if ($content->id !== $location->contentInfo->id) {
            throw new InvalidArgumentException('Location does not belong to provided content.');
        }

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
