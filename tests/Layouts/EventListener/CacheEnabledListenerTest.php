<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\Layouts\EventListener;

use Netgen\BlockManager\Event\BlockManagerEvents;
use Netgen\BlockManager\Event\CollectViewParametersEvent;
use Netgen\BlockManager\HttpCache\NullClient;
use Netgen\BlockManager\View\View\FormView;
use Netgen\BlockManager\View\View\LayoutView;
use Netgen\Bundle\AdminUIBundle\Layouts\EventListener\CacheEnabledListener;
use PHPUnit\Framework\TestCase;

class CacheEnabledListenerTest extends TestCase
{
    /**
     * @var \Netgen\Bundle\AdminUIBundle\Layouts\EventListener\CacheEnabledListener
     */
    protected $listener;

    public function setUp()
    {
        if (
            !class_exists('\Netgen\BlockManager\Version')
            || !class_exists('Netgen\BlockManager\Event\CollectViewParametersEvent')
            || !class_exists('Netgen\BlockManager\Event\BlockManagerEvents')
            || !class_exists('Netgen\BlockManager\View\View\FormView')
            || !class_exists('Netgen\BlockManager\View\View\LayoutView')
            || !class_exists('Netgen\BlockManager\HttpCache\NullClient')
        ) {
            $this->markTestSkipped();
        }

        $httpCacheClient = $this->getMockBuilder('Netgen\BlockManager\HttpCache\ClientInterface')
            ->disableOriginalConstructor()
            ->getMock();

        $this->listener = new CacheEnabledListener($httpCacheClient);
    }

    public function testGetSubscribedEvents()
    {
        $this->assertEquals(array(BlockManagerEvents::BUILD_VIEW => 'onBuildView'), CacheEnabledListener::getSubscribedEvents());
    }

    public function testOnBuildViewWithWrongView()
    {
        $view = new FormView();
        $event = new CollectViewParametersEvent($view);

        $this->assertNull($this->listener->onBuildView($event));
    }

    public function testOnBuildViewWithWrongViewContext()
    {
        $view = new LayoutView();
        $view->setContext('unsupported');
        $event = new CollectViewParametersEvent($view);

        $this->assertNull($this->listener->onBuildView($event));
    }

    public function testOnBuildViewEnabled()
    {
        $view = new LayoutView();
        $view->setContext('ngadminui');
        $event = new CollectViewParametersEvent($view);

        $this->assertNull($this->listener->onBuildView($event));

        $parameters = array(
            'http_cache_enabled' => true,
        );

        $this->assertEquals($parameters, $event->getParameters());
    }

    public function testOnBuildViewDisabled()
    {
        $listener = new CacheEnabledListener(new NullClient());

        $view = new LayoutView();
        $view->setContext('ngadminui');
        $event = new CollectViewParametersEvent($view);

        $this->assertNull($listener->onBuildView($event));

        $parameters = array(
            'http_cache_enabled' => false,
        );

        $this->assertEquals($parameters, $event->getParameters());
    }
}
