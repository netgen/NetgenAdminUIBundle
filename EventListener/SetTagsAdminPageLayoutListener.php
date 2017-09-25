<?php

namespace Netgen\Bundle\AdminUIBundle\EventListener;

use Netgen\TagsBundle\Templating\Twig\AdminGlobalVariable;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;

class SetTagsAdminPageLayoutListener implements EventSubscriberInterface
{
    /**
     * @var \Netgen\TagsBundle\Templating\Twig\AdminGlobalVariable
     */
    protected $globalVariable;

    /**
     * @var string
     */
    protected $pageLayoutTemplate;

    /**
     * @var bool
     */
    protected $isAdminSiteAccess = false;

    /**
     * Constructor.
     *
     * @param \Netgen\TagsBundle\Templating\Twig\AdminGlobalVariable $globalVariable
     * @param string $pageLayoutTemplate
     */
    public function __construct(AdminGlobalVariable $globalVariable, $pageLayoutTemplate)
    {
        $this->globalVariable = $globalVariable;
        $this->pageLayoutTemplate = $pageLayoutTemplate;
    }

    /**
     * Sets if the current siteaccess will be considered as Netgen Admin UI siteaccess.
     *
     * @param bool $isAdminSiteAccess
     */
    public function setIsAdminSiteAccess($isAdminSiteAccess = false)
    {
        $this->isAdminSiteAccess = (bool)$isAdminSiteAccess;
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
     * @param \Symfony\Component\HttpKernel\Event\GetResponseEvent $event
     */
    public function onKernelRequest(GetResponseEvent $event)
    {
        if (!$event->isMasterRequest()) {
            return;
        }

        if (!$this->isAdminSiteAccess) {
            return;
        }

        $currentRoute = $event->getRequest()->attributes->get('_route');
        if (mb_stripos($currentRoute, 'netgen_tags_admin') !== 0) {
            return;
        }

        $this->globalVariable->setPageLayoutTemplate($this->pageLayoutTemplate);
    }
}
