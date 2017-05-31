<?php

namespace Netgen\Bundle\AdminUIBundle\Templating\Twig\Extension;

use Netgen\Bundle\AdminUIBundle\Helper\PathHelper;
use Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface;
use Twig_Extension;
use Twig_SimpleFunction;
use eZPreferences;
use Closure;

class NetgenAdminUIExtension extends Twig_Extension
{
    /**
     * @var \Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface
     */
    protected $authorizationChecker;

    /**
     * @var \Netgen\Bundle\AdminUIBundle\Helper\PathHelper
     */
    protected $pathHelper;

    /**
     * @var \Closure
     */
    protected $legacyKernel;

    /**
     * Constructor.
     *
     * @param \Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface $authorizationChecker
     * @param \Netgen\Bundle\AdminUIBundle\Helper\PathHelper $pathHelper
     * @param \Closure $legacyKernel
     */
    public function __construct(
        AuthorizationCheckerInterface $authorizationChecker,
        PathHelper $pathHelper,
        Closure $legacyKernel
    ) {
        $this->authorizationChecker = $authorizationChecker;
        $this->pathHelper = $pathHelper;
        $this->legacyKernel = $legacyKernel;
    }

    /**
     * Returns the name of the extension.
     *
     * @return string The extension name
     */
    public function getName()
    {
        return 'netgen_admin_ui';
    }

    /**
     * Returns a list of functions to add to the existing list.
     *
     * @return array An array of functions
     */
    public function getFunctions()
    {
        return array(
            new Twig_SimpleFunction(
                'ngadmin_location_path',
                array($this, 'getLocationPath'),
                array('is_safe' => array('html'))
            ),
            new Twig_SimpleFunction(
                'ngadmin_ezpreference',
                array($this, 'getLegacyPreference')
            ),
        );
    }

    /**
     * Returns the path for specified location ID.
     *
     * @param mixed $locationId
     *
     * @return array
     */
    public function getLocationPath($locationId)
    {
        return $this->pathHelper->getPath($locationId);
    }

    /**
     * Returns eZ Publish Legacy ezpreference value.
     *
     * @param string $name
     *
     * @return mixed
     */
    public function getLegacyPreference($name)
    {
        $legacyKernel = $this->legacyKernel;

        return $legacyKernel()->runCallback(
            function () use ($name) {
                return eZPreferences::value($name);
            }
        );
    }
}
