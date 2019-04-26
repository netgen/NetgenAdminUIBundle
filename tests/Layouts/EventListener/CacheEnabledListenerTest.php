<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\Layouts\EventListener;

use Netgen\Bundle\AdminUIBundle\Layouts\EventListener\CacheEnabledListener;
use Netgen\Layouts\Event\CollectViewParametersEvent;
use Netgen\Layouts\Event\LayoutsEvents;
use Netgen\Layouts\HttpCache\NullClient;
use Netgen\Layouts\View\View\FormView;
use Netgen\Layouts\View\View\LayoutView;
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
            !class_exists('Netgen\Layouts\Event\CollectViewParametersEvent')
            || !class_exists('Netgen\Layouts\Event\LayoutsEvents')
            || !class_exists('Netgen\Layouts\View\View\FormView')
            || !class_exists('Netgen\Layouts\View\View\LayoutView')
            || !class_exists('Netgen\Layouts\HttpCache\NullClient')
        ) {
            $this->markTestSkipped();
        }

        $httpCacheClient = $this->getMockBuilder('Netgen\Layouts\HttpCache\ClientInterface')
            ->disableOriginalConstructor()
            ->getMock();

        $this->listener = new CacheEnabledListener($httpCacheClient);
    }

    public function testGetSubscribedEvents()
    {
        $this->assertEquals(array(LayoutsEvents::BUILD_VIEW => 'onBuildView'), CacheEnabledListener::getSubscribedEvents());
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
