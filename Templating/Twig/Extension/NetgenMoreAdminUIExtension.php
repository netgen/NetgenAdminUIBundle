<?php

namespace Netgen\Bundle\MoreAdminUIBundle\Templating\Twig\Extension;

use Closure;
use Twig_Extension;
use Twig_SimpleFunction;
use eZPreferences;

class NetgenMoreAdminUIExtension extends Twig_Extension
{
    /**
     * @var \Closure
     */
    protected $legacyKernel;

    /**
     * Constructor
     *
     * @param \Closure $legacyKernel
     */
    public function __construct( Closure $legacyKernel )
    {
        $this->legacyKernel = $legacyKernel;
    }

    /**
     * Returns the name of the extension.
     *
     * @return string The extension name
     */
    public function getName()
    {
        return 'ngmore_admin_ui';
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
                'ezpreference',
                array( $this, 'getLegacyPreference' )
            )
        );
    }

    /**
     * Returns eZ Publish Legacy ezpreference value
     *
     * @param string $name
     *
     * @return mixed
     */
    public function getLegacyPreference( $name )
    {
        $legacyKernel = $this->legacyKernel;
        return $legacyKernel()->runCallback(
            function () use ( $name ) {
                return eZPreferences::value( $name );
            }
        );
    }
}
