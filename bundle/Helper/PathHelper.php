<?php

namespace Netgen\Bundle\AdminUIBundle\Helper;

use Ibexa\Contracts\Core\Repository\Exceptions\UnauthorizedException;
use Ibexa\Contracts\Core\Repository\LocationService;
use Ibexa\Core\Helper\TranslationHelper;
use Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface;
use Symfony\Component\Routing\RouterInterface;

class PathHelper
{
    /**
     * @var \Ibexa\Contracts\Core\Repository\LocationService
     */
    protected $locationService;

    /**
     * @var \Ibexa\Core\Helper\TranslationHelper
     */
    protected $translationHelper;

    /**
     * @var \Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface
     */
    protected $configResolver;

    /**
     * @var \Symfony\Component\Routing\RouterInterface
     */
    protected $router;

    /**
     * Constructor.
     *
     * @param \Ibexa\Contracts\Core\Repository\LocationService $locationService
     * @param \Ibexa\Core\Helper\TranslationHelper $translationHelper
     * @param \Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface $configResolver
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
