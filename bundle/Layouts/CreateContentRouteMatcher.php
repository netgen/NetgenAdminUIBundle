<?php

declare(strict_types=1);

namespace Netgen\Bundle\AdminUIBundle\Layouts;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\CacheWarmer\WarmableInterface;
use Symfony\Component\Routing\Matcher\RequestMatcherInterface;
use Symfony\Component\Routing\RequestContext;
use Symfony\Component\Routing\RouteCollection;
use Symfony\Component\Routing\RouterInterface;

final class CreateContentRouteMatcher implements RouterInterface, RequestMatcherInterface, WarmableInterface
{
    /**
     * @var \Symfony\Component\Routing\RouterInterface&\Symfony\Component\Routing\Matcher\RequestMatcherInterface
     */
    private $router;

    /**
     * @var string[]
     */
    private array $siteAccesses;

    /**
     * @param string[] $siteAccesses
     */
    public function __construct(RouterInterface $router, array $siteAccesses)
    {
        $this->router = $router;
        $this->siteAccesses = $siteAccesses;
    }

    public function match($pathinfo): array
    {
        return $this->router->match($pathinfo);
    }

    public function setContext(RequestContext $context): void
    {
        $this->router->setContext($context);
    }

    public function getContext(): RequestContext
    {
        return $this->router->getContext();
    }

    public function matchRequest(Request $request): array
    {
        $innerMatch = $this->router->matchRequest($request);

        $siteAccessName = $request->attributes->get('siteaccess')->name;
        if (!in_array($siteAccessName, $this->siteAccesses, true)) {
            return $innerMatch;
        }

        if ($innerMatch['_route'] !== 'nglayouts_ezadmin_create_content') {
            return $innerMatch;
        }

        $innerMatch['_controller'] = 'netgen_admin_ui.controller.create_content';

        return $innerMatch;
    }

    public function getRouteCollection(): RouteCollection
    {
        return $this->router->getRouteCollection();
    }

    public function generate($name, $parameters = [], $referenceType = self::ABSOLUTE_PATH): string
    {
        return $this->router->generate($name, $parameters, $referenceType);
    }

    public function warmUp($cacheDir): void
    {
    }
}
