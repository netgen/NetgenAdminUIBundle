<?php

use \Netgen\TagsBundle\Version as TagsBundleVersion;

class NgAdminUiTagsBundleOperator
{
    /**
     * Returns the list of template operators this class supports
     *
     * @return array
     */
    function operatorList()
    {
        return array( 'has_tags_bundle' );
    }

    /**
     * Indicates if the template operators have named parameters
     *
     * @return bool
     */
    function namedParameterPerOperator()
    {
        return false;
    }

    /**
     * Executes the template operator
     *
     * @param eZTemplate $tpl
     * @param string $operatorName
     * @param mixed $operatorParameters
     * @param string $rootNamespace
     * @param string $currentNamespace
     * @param mixed $operatorValue
     * @param array $namedParameters
     * @param mixed $placement
     */
    public static function modify( $tpl, $operatorName, $operatorParameters, $rootNamespace, $currentNamespace, &$operatorValue, $namedParameters, $placement )
    {
        if ( $operatorName === 'has_tags_bundle' ) {
            $operatorValue = class_exists('Netgen\TagsBundle\Version') && TagsBundleVersion::VERSION_ID >= 30000;
        }
    }
}
