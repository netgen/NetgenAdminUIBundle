<?php

namespace Netgen\Bundle\AdminUIBundle\Controller;

use eZ\Publish\API\Repository\Values\Content\Content;
use eZ\Publish\API\Repository\Values\Content\Location;
use eZ\Publish\Core\MVC\Symfony\View\ContentView;
use Netgen\Bundle\AdminUIBundle\Layouts\RelatedLayoutsLoader;
use Netgen\Layouts\API\Values\LayoutResolver\Rule;
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

        $rules = $this->layoutResolver->resolveRules($request, array('ez_content_type'));
        $rulesOneOnOne = array();

        foreach ($rules as $rule) {
            $rulesOneOnOne[$rule->getId()->toString()] = $this->isRuleOneOnOne($location, $rule);
        }

        return $this->render(
            '@NetgenAdminUI/layouts/location_layouts.html.twig',
            array(
                'rules' => $rules,
                'rules_one_on_one' => $rulesOneOnOne,
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

    /**
     * Returns if the provided rule has a 1:1 mapping to provided location.
     *
     * @param \eZ\Publish\API\Repository\Values\Content\Location $location
     * @param \Netgen\Layouts\API\Values\LayoutResolver\Rule $rule
     *
     * @return bool
     */
    protected function isRuleOneOnOne(Location $location, Rule $rule)
    {
        if ($rule->getTargets()->count() !== 1) {
            return false;
        }

        /** @var \Netgen\Layouts\API\Values\LayoutResolver\Target $target */
        $target = $rule->getTargets()[0];

        if ($target->getTargetType()::getType() === 'ez_location') {
            if ((int) $target->getValue() === (int) $location->id) {
                return true;
            }
        }

        if ($target->getTargetType()::getType() === 'ez_content') {
            if ((int) $target->getValue() === (int) $location->contentId) {
                return true;
            }
        }

        return false;
    }
}
