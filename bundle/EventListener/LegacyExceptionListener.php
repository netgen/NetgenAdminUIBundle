<?php

namespace Netgen\Bundle\AdminUIBundle\EventListener;

use eZ\Bundle\EzPublishLegacyBundle\Routing\FallbackRouter;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\GetResponseForExceptionEvent;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\HttpKernel\KernelEvents;

class LegacyExceptionListener implements EventSubscriberInterface
{
    /**
     * @var bool
     */
    protected $isAdminSiteAccess;

    /**
     * Constructor.
     *
     * @param bool $isAdminSiteAccess
     */
    public function __construct($isAdminSiteAccess = false)
    {
        $this->isAdminSiteAccess = $isAdminSiteAccess;
    }

    /**
     * Returns an array of event names this subscriber wants to listen to.
     *
     * @return array
     */
    public static function getSubscribedEvents()
    {
        return array(KernelEvents::EXCEPTION => 'onException');
    }

    /**
     * Handles the legacy exceptions.
     *
     * @param \Symfony\Component\HttpKernel\Event\GetResponseForExceptionEvent $event
     */
    public function onException(GetResponseForExceptionEvent $event)
    {
        if (!$this->isAdminSiteAccess) {
            return;
        }

        $routeName = $event->getRequest()->attributes->get('_route');
        if ($routeName !== FallbackRouter::ROUTE_NAME) {
            return;
        }

        $exception = $event->getException();
        if (!$exception instanceof NotFoundHttpException) {
            return;
        }

        // We're supporting admin UI exception as well as Netgen
        // internal exception
        if (method_exists($exception, 'getOriginalResponse')) {
            $event->setResponse($exception->getOriginalResponse());
        }
    }
}
