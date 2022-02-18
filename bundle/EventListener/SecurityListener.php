<?php

namespace Netgen\Bundle\AdminUIBundle\EventListener;

use eZ\Publish\API\Repository\Repository;
use eZ\Publish\Core\MVC\ConfigResolverInterface;
use eZ\Publish\Core\MVC\Legacy\Event\PostBuildKernelEvent;
use eZ\Publish\Core\MVC\Legacy\LegacyEvents;
use ezpWebBasedKernelHandler;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface;

class SecurityListener implements EventSubscriberInterface
{
    /**
     * @var \Symfony\Component\HttpFoundation\RequestStack
     */
    protected $requestStack;

    /**
     * @var \eZ\Publish\API\Repository\Repository
     */
    protected $repository;

    /**
     * @var \eZ\Publish\Core\MVC\ConfigResolverInterface
     */
    protected $configResolver;

    /**
     * @var \Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface
     */
    protected $tokenStorage;

    /**
     * @var \Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface
     */
    protected $authorizationChecker;

    /**
     * Constructor.
     *
     * @param \Symfony\Component\HttpFoundation\RequestStack $requestStack
     * @param \eZ\Publish\API\Repository\Repository $repository
     * @param \eZ\Publish\Core\MVC\ConfigResolverInterface $configResolver
     * @param \Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface $tokenStorage
     * @param \Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface $authorizationChecker
     */
    public function __construct(
        RequestStack $requestStack,
        Repository $repository,
        ConfigResolverInterface $configResolver,
        TokenStorageInterface $tokenStorage,
        AuthorizationCheckerInterface $authorizationChecker
    ) {
        $this->requestStack = $requestStack;
        $this->repository = $repository;
        $this->configResolver = $configResolver;
        $this->tokenStorage = $tokenStorage;
        $this->authorizationChecker = $authorizationChecker;
    }

    /**
     * @return array
     */
    public static function getSubscribedEvents()
    {
        return array(
            LegacyEvents::POST_BUILD_LEGACY_KERNEL => array('onKernelBuilt', 255),
        );
    }

    /**
     * Performs actions related to security once the legacy kernel has been built.
     *
     * @param \eZ\Publish\Core\MVC\Legacy\Event\PostBuildKernelEvent $event
     */
    public function onKernelBuilt(PostBuildKernelEvent $event)
    {
        $currentRequest = $this->requestStack->getCurrentRequest();

        // Ignore if not in web context, if legacy_mode is active or if user is not authenticated
        if (
            $currentRequest === null
            || !$event->getKernelHandler() instanceof ezpWebBasedKernelHandler
            || $this->configResolver->getParameter('legacy_mode') === true
            || !$this->isUserAuthenticated()
        ) {
            return;
        }

        /*
        Siteaccesses running with legacy_mode=false and RequireUserLogin=true have issues with
        login redirects when protected legacy views are accessed via URL before the user is logged in.
        This is because RequireUserLogin specific code in legacy kernel checks for existence of
        'eZUserLoggedInID' DURING the legacy kernel initialization process. Since 'eZUserLoggedInID'
        session variable can only be set AFTER the legacy kernel is built and initialized,
        via runCallback method, the code always fails, causing repeated login screens.

        This is a workaround to set the session variable after the kernel is built, but before
        it's initialized, so the RequireUserLogin code should work fine.
        */

        $currentRequest->getSession()->set(
            'eZUserLoggedInID',
            $this->repository->getPermissionResolver()->getCurrentUserReference()->getUserId()
        );
    }

    /**
     * @return bool
     */
    protected function isUserAuthenticated()
    {
        // IS_AUTHENTICATED_FULLY inherits from IS_AUTHENTICATED_REMEMBERED.
        // User can be either authenticated by providing credentials during current session
        // or by "remember me" if available.
        return
            $this->tokenStorage->getToken() instanceof TokenInterface
            && $this->authorizationChecker->isGranted('IS_AUTHENTICATED_REMEMBERED');
    }
}
