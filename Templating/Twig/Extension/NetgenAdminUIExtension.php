<?php

namespace Netgen\Bundle\AdminUIBundle\Templating\Twig\Extension;

use eZ\Publish\API\Repository\Values\ValueObject;
use eZ\Publish\Core\MVC\Symfony\Security\Authorization\Attribute;
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
            // ngadmin_is_granted function is @deprecated
            new Twig_SimpleFunction(
                'ngadmin_is_granted',
                array($this, 'isGranted')
            ),
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
     * Indicates if the current user is allowed to perform an action given by the function on the given
     * objects.
     *
     * @param string $module The module, aka controller identifier to check permissions on
     * @param string $function The function, aka the controller action to check permissions on
     * @param \eZ\Publish\API\Repository\Values\ValueObject $object The object to check if the user has access to
     * @param mixed $targets The location, parent or "assignment" value object, or an array of the same
     *
     * @return bool
     */
    public function isGranted($module, $function, ValueObject $object = null, $targets = null)
    {
        @trigger_error(
            'ngadmin_is_granted Twig function is deprecated and will be removed in Admin UI Bundle 2.0. Use EzCoreExtraBundle and is_granted Twig function instead.',
            E_USER_DEPRECATED
        );

        $attribute = new Attribute($module, $function);
        if ($object instanceof ValueObject) {
            $attribute->limitations['valueObject'] = $object;
            if ($targets !== null) {
                $attribute->limitations['targets'] = $targets;
            }
        }

        return $this->authorizationChecker->isGranted($attribute);
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
