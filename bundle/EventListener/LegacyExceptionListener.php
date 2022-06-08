<?php

namespace Netgen\Bundle\AdminUIBundle\EventListener;

use eZ\Bundle\EzPublishLegacyBundle\Routing\FallbackRouter;
use Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\HttpKernel\KernelEvents;

class LegacyExceptionListener implements EventSubscriberInterface
{
    /**
     * @var \Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface
     */
    protected $configResolver;

    public function __construct(ConfigResolverInterface $configResolver)
    {
        $this->configResolver = $configResolver;
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
     * @param \Symfony\Component\HttpKernel\Event\ExceptionEvent $event
     */
    public function onException(ExceptionEvent $event)
    {
        if (!$this->configResolver->getParameter('is_admin_ui_siteaccess', 'netgen_admin_ui')) {
            return;
        }

        $routeName = $event->getRequest()->attributes->get('_route');
        if ($routeName !== FallbackRouter::ROUTE_NAME) {
            return;
        }

        $exception = $event->getThrowable();
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
