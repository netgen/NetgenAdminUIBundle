<?php

namespace Netgen\Bundle\AdminUIBundle\Layouts\EventListener;

use Netgen\Layouts\Event\CollectViewParametersEvent;
use Netgen\Layouts\Event\LayoutsEvents;
use Netgen\Layouts\View\View\LayoutViewInterface;
use Netgen\Layouts\View\View\RuleViewInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class IsEnterpriseVersionListener implements EventSubscriberInterface
{
    /**
     * @var bool
     */
    private $isEnterpriseVersion;

    public function __construct(bool $isEnterpriseVersion)
    {
        $this->isEnterpriseVersion = $isEnterpriseVersion;
    }

    public static function getSubscribedEvents()
    {
        return array(LayoutsEvents::BUILD_VIEW => 'onBuildView');
    }

    /**
     * Injects if Netgen Layouts is the enterprise version or not.
     */
    public function onBuildView(CollectViewParametersEvent $event)
    {
        $view = $event->getView();
        if (!$view instanceof LayoutViewInterface && !$view instanceof RuleViewInterface) {
            return;
        }

        if ($view->getContext() !== 'ngadminui') {
            return;
        }

        $event->addParameter('is_enterprise', $this->isEnterpriseVersion);
    }
}
