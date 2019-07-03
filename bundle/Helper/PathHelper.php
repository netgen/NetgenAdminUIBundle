<?php

namespace Netgen\Bundle\AdminUIBundle\Helper;

use eZ\Publish\API\Repository\Exceptions\UnauthorizedException;
use eZ\Publish\API\Repository\LocationService;
use eZ\Publish\Core\Helper\TranslationHelper;
use eZ\Publish\Core\MVC\ConfigResolverInterface;
use Symfony\Component\Routing\RouterInterface;

class PathHelper
{
    /**
     * @var \eZ\Publish\API\Repository\LocationService
     */
    protected $locationService;

    /**
     * @var \eZ\Publish\Core\Helper\TranslationHelper
     */
    protected $translationHelper;

    /**
     * @var \eZ\Publish\Core\MVC\ConfigResolverInterface
     */
    protected $configResolver;

    /**
     * @var \Symfony\Component\Routing\RouterInterface
     */
    protected $router;

    /**
     * Constructor.
     *
     * @param \eZ\Publish\API\Repository\LocationService $locationService
     * @param \eZ\Publish\Core\Helper\TranslationHelper $translationHelper
     * @param \eZ\Publish\Core\MVC\ConfigResolverInterface $configResolver
     * @param \Symfony\Component\Routing\RouterInterface $router
     */
    public function __construct(
        LocationService $locationService,
        TranslationHelper $translationHelper,
        ConfigResolverInterface $configResolver,
        RouterInterface $router
    ) {
        $this->locationService = $locationService;
        $this->translationHelper = $translationHelper;
        $this->configResolver = $configResolver;
        $this->router = $router;
    }

    /**
     * Returns the path array for location ID.
     *
     * @param mixed $locationId
     *
     * @return array
     */
    public function getPath($locationId)
    {
        $pathArray = array();

        $startingLocation = $this->locationService->loadLocation($locationId);
        $path = $startingLocation->path;

        // Shift of location "1" from path as it is not
        // a fully valid location and not readable by most users
        array_shift($path);

        $rootLocationFound = false;
        $rootLocationId = (int) $this->configResolver->getParameter('content.tree_root.location_id');

        foreach ($path as $index => $pathItem) {
            if ((int) $pathItem === $rootLocationId) {
                $rootLocationFound = true;
            }

            if (!$rootLocationFound) {
                continue;
            }

            try {
                $location = $this->locationService->loadLocation($pathItem);
            } catch (UnauthorizedException $e) {
                return array();
            }

            $pathArray[] = array(
                'text' => $this->translationHelper->getTranslatedContentNameByContentInfo(
                    $location->contentInfo
                ),
                'url' => $location->id !== $startingLocation->id ?
                    $this->router->generate($location) :
                    false,
                'locationId' => $location->id,
                'contentId' => $location->contentId,
            );
        }

        return $pathArray;
    }
}
