<?php

namespace Netgen\Bundle\AdminUIBundle\Layouts\EventListener;

use eZ\Publish\Core\MVC\ConfigResolverInterface;
use Netgen\Bundle\LayoutsAdminBundle\Event\AdminMatchEvent;
use Netgen\Bundle\LayoutsAdminBundle\Event\LayoutsAdminEvents;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class SetAdminPageLayoutListener implements EventSubscriberInterface
{
    /**
     * @var \eZ\Publish\Core\MVC\ConfigResolverInterface
     */
    private $configResolver;

    /**
     * @var string
     */
    private $pageLayoutTemplate;

    /**
     * @param $pageLayoutTemplate string
     */
    public function __construct(ConfigResolverInterface $configResolver, $pageLayoutTemplate)
    {
        $this->configResolver = $configResolver;
        $this->pageLayoutTemplate = $pageLayoutTemplate;
    }

    public static function getSubscribedEvents()
    {
        return array(LayoutsAdminEvents::ADMIN_MATCH => 'onAdminMatch');
    }

    /**
     * Sets the pagelayout template for admin interface.
     */
    public function onAdminMatch(AdminMatchEvent $event)
    {
        if (!$this->configResolver->getParameter('is_admin_ui_siteaccess', 'netgen_admin_ui')) {
            return;
        }

        $event->setPageLayoutTemplate($this->pageLayoutTemplate);
    }
}
