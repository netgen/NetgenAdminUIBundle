<?php

namespace Netgen\Bundle\AdminUIBundle\Layouts\EventListener;

use Netgen\Layouts\Event\CollectViewParametersEvent;
use Netgen\Layouts\Event\LayoutsEvents;
use Netgen\Layouts\HttpCache\ClientInterface;
use Netgen\Layouts\HttpCache\NullClient;
use Netgen\Layouts\View\View\LayoutViewInterface;
use Netgen\Layouts\View\View\RuleViewInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class CacheEnabledListener implements EventSubscriberInterface
{
    /**
     * @var \Netgen\Layouts\HttpCache\ClientInterface
     */
    private $httpCacheClient;

    /**
     * @var bool
     */
    private $cacheEnabled = true;

    public function __construct(ClientInterface $httpCacheClient)
    {
        $this->httpCacheClient = $httpCacheClient;
        $this->cacheEnabled = !$this->httpCacheClient instanceof NullClient;
    }

    public static function getSubscribedEvents()
    {
        return array(LayoutsEvents::BUILD_VIEW => 'onBuildView');
    }

    /**
     * Injects if the HTTP cache clearing is enabled or not.
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

        $event->addParameter('http_cache_enabled', $this->cacheEnabled);
    }
}
