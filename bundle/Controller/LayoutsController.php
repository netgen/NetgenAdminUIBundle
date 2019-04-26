<?php

namespace Netgen\Bundle\AdminUIBundle\Controller;

use eZ\Publish\API\Repository\Values\Content\Content;
use eZ\Publish\API\Repository\Values\Content\Location;
use eZ\Publish\Core\MVC\Symfony\View\ContentView;
use Netgen\Bundle\AdminUIBundle\Layouts\RelatedLayoutsLoader;
use Netgen\Layouts\Layout\Resolver\LayoutResolverInterface;
use Symfony\Component\HttpFoundation\Request;

class LayoutsController extends Controller
{
    /**
     * @var \Netgen\Layouts\Layout\Resolver\LayoutResolverInterface
     */
    protected $layoutResolver;

    /**
     * @var \Netgen\Bundle\AdminUIBundle\Layouts\RelatedLayoutsLoader
     */
    protected $relatedLayoutsLoader;

    public function __construct(
        LayoutResolverInterface $layoutResolver,
        RelatedLayoutsLoader $relatedLayoutsLoader
    ) {
        $this->layoutResolver = $layoutResolver;
        $this->relatedLayoutsLoader = $relatedLayoutsLoader;
    }

    /**
     * Renders a template that shows all layouts applied to provided location.
     *
     * @param int|string $locationId
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function showLocationLayouts($locationId)
    {
        $repository = $this->getRepository();

        $location = $repository->getLocationService()->loadLocation($locationId);
        $content = $repository->getContentService()->loadContent($location->contentInfo->id);

        $request = $this->createRequest($content, $location);

        return $this->render(
            '@NetgenAdminUI/layouts/location_layouts.html.twig',
            array(
                'rules' => $this->layoutResolver->resolveRules($request, array('ez_content_type')),
                'related_layouts' => $this->relatedLayoutsLoader->loadRelatedLayouts($location),
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
        if ($this->isGranted('ROLE_NGLAYOUTS_EDITOR')) {
            return;
        }

        if ($this->isGranted('nglayouts:ui:access')) {
            return;
        }

        $exception = $this->createAccessDeniedException();
        $exception->setAttributes('nglayouts:ui:access');

        throw $exception;
    }
}
