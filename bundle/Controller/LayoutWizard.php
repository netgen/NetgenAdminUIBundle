<?php

declare(strict_types=1);

namespace Netgen\Bundle\AdminUIBundle\Controller;

use eZ\Publish\API\Repository\Values\Content\Location;
use Netgen\Bundle\AdminUIBundle\Form\Type\LayoutWizardType;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

final class LayoutWizard extends Controller
{
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
            //
        }

        return $this->render(
            '@NetgenAdminUI/layouts/layout_wizard.html.twig',
            [
                'location' => $location,
                'form' => $form->createView(),
            ],
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
