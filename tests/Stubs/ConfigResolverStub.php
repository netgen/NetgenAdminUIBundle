<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\Stubs;

use Ibexa\Contracts\Core\SiteAccess\ConfigResolverInterface;

class ConfigResolverStub implements ConfigResolverInterface
{
    /**
     * @var array
     */
    private $parameters;

    /**
     * @var string
     */
    private $defaultNamespace = 'ibexa.site_access.config';

    public function __construct(array $parameters)
    {
        $this->parameters = $parameters;
    }

    public function getParameter($paramName, $namespace = null, $scope = null)
    {
        return $this->parameters[$namespace ?: $this->defaultNamespace][$paramName];
    }

    public function hasParameter($paramName, $namespace = null, $scope = null)
    {
        return isset($this->parameters[$namespace ?: $this->defaultNamespace][$paramName]);
    }

    public function setDefaultNamespace($defaultNamespace)
    {
        $this->defaultNamespace = $defaultNamespace;
    }

    public function getDefaultNamespace()
    {
        return $this->defaultNamespace;
    }
}
