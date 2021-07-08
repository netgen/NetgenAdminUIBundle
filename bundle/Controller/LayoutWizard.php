<?php

declare(strict_types=1);

namespace Netgen\Bundle\AdminUIBundle\Controller;

use eZ\Publish\API\Repository\Values\Content\Location;
use Netgen\Bundle\AdminUIBundle\Form\Type\LayoutWizardType;
use Netgen\Layouts\API\Service\LayoutService;
use Netgen\Layouts\API\Values\Layout\Layout;
use Netgen\Layouts\Layout\Registry\LayoutTypeRegistry;
use Symfony\Component\Form\FormInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;
use function hash;
use function random_bytes;
use function sprintf;

final class LayoutWizard extends Controller
{
    /**
     * @var \Netgen\Layouts\API\Service\LayoutService
     */
    private $layoutService;

    /**
     * @var \Netgen\Layouts\Layout\Registry\LayoutTypeRegistry
     */
    private $layoutTypeRegistry;

    public function __construct(LayoutService $layoutService, LayoutTypeRegistry $layoutTypeRegistry)
    {
        $this->layoutService = $layoutService;
        $this->layoutTypeRegistry = $layoutTypeRegistry;
    }

    /**
     * Renders a 1:1 wizard used to create layout+mapping combination on-the-fly.
     */
    public function __invoke(Location $location, Request $request): Response
    {
        $form = $this->createForm(
            LayoutWizardType::class,
            null,
            [
                'action' => $this->generateUrl(
                    'ngadmin_layouts_layout_wizard',
                    [
                        'locationId' => $location->id,
                    ]
                ),
            ],
        );

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $layout = $form->get('action')->getData() === LayoutWizardType::ACTION_TYPE_NEW_LAYOUT ?
                $this->createNewLayout($form, $request->getLocale()) :
                $this->copyLayout($form, $form->get('layout')->getData());

            $wizardData = [
                'layout' => $layout->getId()->toString(),
                'activate_rule' => $form->get('activate_rule')->getData(),
            ];

            if ($form->has('rule_group')) {
                $wizardData['rule_group'] = $form->get('rule_group')->getData();
            }

            $wizardId = hash('sha256', random_bytes(32));
            $request->getSession()->set(sprintf('_layouts_ezplatform_wizard/%s', $wizardId), $wizardData);

            $returnUrl = $this->generateUrl(
                'ngadmin_layouts_layout_wizard_callback',
                [
                    'locationId' => $location->id,
                    'wizardId' => $wizardId,
                ],
                UrlGeneratorInterface::ABSOLUTE_URL,
            );

            $layoutUrl = $this->generateUrl(
                'nglayouts_app',
                [
                    '_fragment' => 'layout/' . $layout->getId()->toString(),
                ],
                UrlGeneratorInterface::ABSOLUTE_URL,
            );

            return new JsonResponse(
                [
                    'return_url' => $returnUrl,
                    'layout_url' => $layoutUrl,
                ]
            );
        }

        return $this->render(
            '@NetgenAdminUI/layouts/layout_wizard.html.twig',
            [
                'location' => $location,
                'form' => $form->createView(),
            ],
            new Response(
                null,
                $form->isSubmitted() ?
                    Response::HTTP_UNPROCESSABLE_ENTITY :
                    Response::HTTP_OK
            ),
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

    private function createNewLayout(FormInterface $form, string $locale): Layout
    {
        $createStruct = $this->layoutService->newLayoutCreateStruct(
            $this->layoutTypeRegistry->getLayoutType($form->get('layout_type')->getData()->getIdentifier()),
            $form->get('layout_name')->getData(),
            $locale,
        );

        $createStruct->description = $form->get('layout_description')->getData() ?? '';

        return $this->layoutService->createLayout($createStruct);
    }

    private function copyLayout(FormInterface $form, Layout $layout): Layout
    {
        $copyStruct = $this->layoutService->newLayoutCopyStruct();
        $copyStruct->name = $form->get('layout_name')->getData();
        $copyStruct->description = $form->get('layout_description')->getData() ?? '';

        // We need the copy of a draft
        $layoutDraft = $this->layoutService->createDraft($layout, true);
        $copiedLayout = $this->layoutService->copyLayout($layoutDraft, $copyStruct);
        $this->layoutService->discardDraft($layoutDraft);

        return $copiedLayout;
    }
}
