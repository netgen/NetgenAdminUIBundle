<?php

namespace Netgen\Bundle\AdminUIBundle\Exception;

use eZ\Bundle\EzPublishLegacyBundle\LegacyResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException as BaseNotFoundHttpException;

class NotFoundHttpException extends BaseNotFoundHttpException
{
    /**
     * @var \eZ\Bundle\EzPublishLegacyBundle\LegacyResponse
     */
    protected $originalResponse;

    /**
     * Sets the response.
     *
     * @param \eZ\Bundle\EzPublishLegacyBundle\LegacyResponse $originalResponse
     */
    public function setOriginalResponse(LegacyResponse $originalResponse)
    {
        $this->originalResponse = $originalResponse;
    }

    /**
     * Returns the response.
     *
     * @return \eZ\Bundle\EzPublishLegacyBundle\LegacyResponse
     */
    public function getOriginalResponse()
    {
        return $this->originalResponse;
    }
}
