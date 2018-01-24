<?php

namespace Netgen\Bundle\AdminUIBundle\EventListener;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Controller\ControllerResolverInterface;
use Symfony\Component\HttpKernel\Event\FilterControllerEvent;
use Symfony\Component\HttpKernel\HttpKernelInterface;
use Symfony\Component\HttpKernel\KernelEvents;

class ControllerListener implements EventSubscriberInterface
{
    /**
     * @var \Symfony\Component\HttpKernel\Controller\ControllerResolverInterface
     */
    protected $controllerResolver;

    /**
     * @var bool
     */
    protected $isAdminSiteAccess;

    /**
     * @var array
     */
    protected $legacyRoutes;

    /**
     * Constructor.
     *
     * @param \Symfony\Component\HttpKernel\Controller\ControllerResolverInterface $controllerResolver
     * @param bool $isAdminSiteAccess
     * @param array $legacyRoutes
     */
    public function __construct(
        ControllerResolverInterface $controllerResolver,
        $isAdminSiteAccess = false,
        $legacyRoutes = array()
    ) {
        $this->controllerResolver = $controllerResolver;
        $this->isAdminSiteAccess = $isAdminSiteAccess;
        $this->legacyRoutes = $legacyRoutes;
    }

    /**
     * Returns an array of event names this subscriber wants to listen to.
     *
     * @return array The event names to listen to
     */
    public static function getSubscribedEvents()
    {
        return array(
            KernelEvents::CONTROLLER => array('onKernelController', 255),
        );
    }

    /**
     * Redirects configured routes to eZ legacy.
     *
     * @param \Symfony\Component\HttpKernel\Event\FilterControllerEvent $event
     */
    public function onKernelController(FilterControllerEvent $event)
    {
        if ($event->getRequestType() !== HttpKernelInterface::MASTER_REQUEST) {
            return;
        }

        if (!$this->isAdminSiteAccess) {
            return;
        }

        $currentRoute = $event->getRequest()->attributes->get('_route');

        foreach ($this->legacyRoutes as $legacyRoute) {
            if (stripos($currentRoute, $legacyRoute) === 0) {
                $event->getRequest()->attributes->set('_controller', 'ezpublish_legacy.controller:indexAction');
                $event->setController($this->controllerResolver->getController($event->getRequest()));

                return;
            }
        }
    }
}
