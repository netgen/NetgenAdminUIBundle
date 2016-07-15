<?php

namespace Netgen\Bundle\AdminUIBundle\Helper;

use eZ\Publish\API\Repository\LocationService;
use eZ\Publish\Core\Helper\TranslationHelper;
use Symfony\Component\Routing\RouterInterface;
use eZ\Publish\API\Repository\Exceptions\UnauthorizedException;

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
     * @var \Symfony\Component\Routing\RouterInterface
     */
    protected $router;

    /**
     * @var int|string
     */
    protected $rootLocationId;

    /**
     * Constructor.
     *
     * @param \eZ\Publish\API\Repository\LocationService $locationService
     * @param \eZ\Publish\Core\Helper\TranslationHelper $translationHelper
     * @param \Symfony\Component\Routing\RouterInterface $router
     */
    public function __construct(
        LocationService $locationService,
        TranslationHelper $translationHelper,
        RouterInterface $router
    ) {
        $this->locationService = $locationService;
        $this->translationHelper = $translationHelper;
        $this->router = $router;
    }

    /**
     * Sets the root location ID.
     *
     * @param int|string $rootLocationId
     */
    public function setRootLocationId($rootLocationId)
    {
        $this->rootLocationId = $rootLocationId;
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

        $path = $this->locationService->loadLocation($locationId)->path;

        // Shift of location "1" from path as it is not
        // a fully valid location and not readable by most users
        array_shift($path);

        $rootLocationFound = false;
        foreach ($path as $index => $pathItem) {
            if ($pathItem == $this->rootLocationId) {
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
                'url' => $location->id != $locationId ?
                    $this->router->generate($location) :
                    false,
                'locationId' => $location->id,
                'contentId' => $location->contentId,
            );
        }

        return $pathArray;
    }
}
