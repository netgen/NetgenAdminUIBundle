<?php

declare(strict_types=1);

namespace Netgen\Bundle\AdminUIBundle\Controller;

use eZ\Publish\API\Repository\ContentTypeService;
use eZ\Publish\API\Repository\LocationService;
use Netgen\Layouts\API\Values\Block\Block;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Closure;
use eZContentObject;
use eZContentClass;
use eZNodeAssignment;
use eZContentObjectVersion;
use eZDateTime;
use eZDB;

final class CreateContent extends Controller
{
    /**
     * @var \eZ\Publish\API\Repository\LocationService
     */
    private $locationService;

    /**
     * @var \eZ\Publish\API\Repository\ContentTypeService
     */
    private $contentTypeService;

    /**
     * @var \Closure
     */
    private $legacyKernel;

    public function __construct(
        LocationService $locationService,
        ContentTypeService $contentTypeService,
        Closure $legacyKernel
    ) {
        $this->locationService = $locationService;
        $this->contentTypeService = $contentTypeService;
        $this->legacyKernel = $legacyKernel;
    }

    /**
     * Creates a content and redirects to route that edits the content.
     *
     * @param int|string $parentLocationId
     */
    public function __invoke(Request $request, Block $block, string $contentTypeIdentifier, string $languageCode, $parentLocationId): Response
    {
        $location = $this->locationService->loadLocation((int) $parentLocationId);
        $contentType = $this->contentTypeService->loadContentTypeByIdentifier($contentTypeIdentifier);

        $contentObject = $this->createContent($contentType->identifier, $languageCode, $location->id);

        return $this->redirectToRoute(
            'ez_legacy',
            [
                'module_uri' => sprintf(
                    '/content/edit/%d/%d',
                    $contentObject->attribute('id'),
                    $contentObject->attribute('current_version')
                ),
                '_fragment' => 'ngl-component/' . $block->getId()->toString(),
            ]
        );
    }

    private function createContent(string $contentTypeIdentifier, string $languageCode, int $parentLocationId): eZContentObject
    {
        return ($this->legacyKernel)()->runCallback(
            static function () use ($contentTypeIdentifier, $languageCode, $parentLocationId) {
                $contentClass = eZContentClass::fetchByIdentifier($contentTypeIdentifier);

                $db = eZDB::instance();
                $db->begin();

                $contentObject = $contentClass->instantiate(false , 0, false, $languageCode);
                $contentObject->store();

                $nodeAssignment = eZNodeAssignment::create(
                    [
                        'contentobject_id' => $contentObject->attribute('id'),
                        'contentobject_version' => $contentObject->attribute('current_version'),
                        'parent_node' => $parentLocationId,
                        'is_main' => 1,
                        'sort_field' => $contentClass->attribute('sort_field'),
                        'sort_order' => $contentClass->attribute('sort_order')
                    ]
                );

                $nodeAssignment->store();

                $version = $contentObject->version(1);
                $version->setAttribute('modified', eZDateTime::currentTimeStamp());
                $version->setAttribute('status', eZContentObjectVersion::STATUS_DRAFT);
                $version->store();

                $db->commit();

                return $contentObject;
            }
        );
    }

    public function checkPermissions(): void
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
