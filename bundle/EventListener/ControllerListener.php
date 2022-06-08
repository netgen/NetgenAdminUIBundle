<?php

namespace Netgen\Bundle\AdminUIBundle\EventListener;

use Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Controller\ControllerResolverInterface;
use Symfony\Component\HttpKernel\Event\ControllerEvent;
use Symfony\Component\HttpKernel\HttpKernelInterface;
use Symfony\Component\HttpKernel\KernelEvents;

class ControllerListener implements EventSubscriberInterface
{
    /**
     * @var \Symfony\Component\HttpKernel\Controller\ControllerResolverInterface
     */
    protected $controllerResolver;

    /**
     * @var \Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface
     */
    protected $configResolver;

    /**
     * Constructor.
     *
     * @param \Symfony\Component\HttpKernel\Controller\ControllerResolverInterface $controllerResolver
     * @param \Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface $configResolver
     */
    public function __construct(ControllerResolverInterface $controllerResolver, ConfigResolverInterface $configResolver)
    {
        $this->controllerResolver = $controllerResolver;
        $this->configResolver = $configResolver;
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
     * @param \Symfony\Component\HttpKernel\Event\ControllerEvent $event
     */
    public function onKernelController(ControllerEvent $event)
    {
        if ($event->getRequestType() !== HttpKernelInterface::MASTER_REQUEST) {
            return;
        }

        if (!$this->configResolver->getParameter('is_admin_ui_siteaccess', 'netgen_admin_ui')) {
            return;
        }

        $currentRoute = $event->getRequest()->attributes->get('_route');

        foreach ($this->configResolver->getParameter('legacy_routes', 'netgen_admin_ui') as $legacyRoute) {
            if (stripos($currentRoute, $legacyRoute) === 0) {
                $event->getRequest()->attributes->set('_controller', 'ezpublish_legacy.controller:indexAction');
                $event->setController($this->controllerResolver->getController($event->getRequest()));

                return;
            }
        }
    }
}
