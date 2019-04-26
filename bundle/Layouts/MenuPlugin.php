<?php

namespace Netgen\Bundle\AdminUIBundle\Layouts;

use Netgen\Bundle\AdminUIBundle\MenuPlugin\MenuPluginInterface;
use Netgen\Bundle\LayoutsAdminBundle\EventListener\SetIsAdminRequestListener;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface;

class MenuPlugin implements MenuPluginInterface
{
    /**
     * @var \Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface
     */
    private $authorizationChecker;

    public function __construct(AuthorizationCheckerInterface $authorizationChecker)
    {
        $this->authorizationChecker = $authorizationChecker;
    }

    public function getIdentifier()
    {
        return 'layouts';
    }

    public function getTemplates()
    {
        return array(
            'head' => '@NetgenAdminUI/menu/plugins/layouts/head.html.twig',
            'aside' => '@NetgenAdminUI/menu/plugins/layouts/aside.html.twig',
            'left' => '@NetgenAdminUI/menu/plugins/layouts/left.html.twig',
        );
    }

    public function isActive()
    {
        if ($this->authorizationChecker->isGranted('ROLE_NGLAYOUTS_ADMIN')) {
            return true;
        }

        if ($this->authorizationChecker->isGranted('nglayouts:ui:access')) {
            return true;
        }

        return false;
    }

    public function matches(Request $request)
    {
        return $request->attributes->get(SetIsAdminRequestListener::ADMIN_FLAG_NAME) === true;
    }
}
