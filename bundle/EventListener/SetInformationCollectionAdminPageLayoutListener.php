<?php

namespace Netgen\Bundle\AdminUIBundle\EventListener;

use eZ\Publish\Core\MVC\ConfigResolverInterface;
use Netgen\Bundle\InformationCollectionBundle\Templating\Twig\AdminGlobalVariable;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\KernelEvents;

class SetInformationCollectionAdminPageLayoutListener implements EventSubscriberInterface
{
    /**
     * @var \Netgen\Bundle\InformationCollectionBundle\Templating\Twig\AdminGlobalVariable
     */
    protected $globalVariable;

    /**
     * @var \eZ\Publish\Core\MVC\ConfigResolverInterface
     */
    protected $configResolver;

    /**
     * @var string
     */
    protected $pageLayoutTemplate;

    /**
     * Constructor.
     *
     * @param \Netgen\Bundle\InformationCollectionBundle\Templating\Twig\AdminGlobalVariable $globalVariable
     * @param \eZ\Publish\Core\MVC\ConfigResolverInterface $configResolver
     * @param string $pageLayoutTemplate
     */
    public function __construct(AdminGlobalVariable $globalVariable, ConfigResolverInterface $configResolver, $pageLayoutTemplate)
    {
        $this->globalVariable = $globalVariable;
        $this->configResolver = $configResolver;
        $this->pageLayoutTemplate = $pageLayoutTemplate;
    }

    /**
     * Returns an array of event names this subscriber wants to listen to.
     *
     * @return array
     */
    public static function getSubscribedEvents()
    {
        return array(KernelEvents::REQUEST => 'onKernelRequest');
    }

    /**
     * Sets the Netgen Tags admin pagelayout for Netgen Admin UI.
     *
     * @param \Symfony\Component\HttpKernel\Event\RequestEvent $event
     */
    public function onKernelRequest(RequestEvent $event)
    {
        if (!$event->isMasterRequest()) {
            return;
        }

        if (!$this->configResolver->getParameter('is_admin_ui_siteaccess', 'netgen_admin_ui')) {
            return;
        }

        $currentRoute = $event->getRequest()->attributes->get('_route');
        if (mb_stripos($currentRoute, 'netgen_information_collection') !== 0) {
            return;
        }

        $this->globalVariable->setPageLayoutTemplate($this->pageLayoutTemplate);
    }
}
