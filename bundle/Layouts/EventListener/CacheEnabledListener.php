<?php

namespace Netgen\Bundle\AdminUIBundle\Layouts\EventListener;

use Netgen\BlockManager\Event\BlockManagerEvents;
use Netgen\BlockManager\Event\CollectViewParametersEvent;
use Netgen\BlockManager\HttpCache\ClientInterface;
use Netgen\BlockManager\HttpCache\NullClient;
use Netgen\BlockManager\View\View\LayoutViewInterface;
use Netgen\BlockManager\View\View\RuleViewInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class CacheEnabledListener implements EventSubscriberInterface
{
    /**
     * @var \Netgen\BlockManager\HttpCache\ClientInterface
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
        return array(BlockManagerEvents::BUILD_VIEW => 'onBuildView');
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
