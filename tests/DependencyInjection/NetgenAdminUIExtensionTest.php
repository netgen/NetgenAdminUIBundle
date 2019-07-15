<?php

namespace Netgen\Bundle\AdminUIBundle\Tests\DependencyInjection;

use Matthias\SymfonyDependencyInjectionTest\PhpUnit\AbstractExtensionTestCase;
use Netgen\Bundle\AdminUIBundle\DependencyInjection\NetgenAdminUIExtension;

class NetgenAdminUIExtensionTest extends AbstractExtensionTestCase
{
    public function testWithNoEzCoreExtraBundle()
    {
        $this->expectException('RuntimeException');

        $this->container->setParameter('kernel.bundles', array());
        $this->load();
    }

    public function testWithNoInformationCollectionBundle()
    {
        $this->container->setParameter('kernel.bundles', array(
            'EzCoreExtraBundle' => 'EzCoreExtraBundle',
            'NetgenLayoutsBundle' => 'NetgenLayoutsBundle',
        ));

        $this->load();

        $this->assertContainerBuilderHasParameter('netgen_admin_ui.logo_type', 'default');
    }

    public function testWithAdminUILogo()
    {
        $this->container->setParameter('kernel.bundles', array(
            'EzCoreExtraBundle' => 'EzCoreExtraBundle',
            'NetgenLayoutsBundle' => 'NetgenLayoutsBundle',
            'NetgenInformationCollectionBundle' => 'NetgenInformationCollectionBundle',
        ));

        $this->container->setParameter('netgen_admin_ui.logo_type', 'default');

        $this->getMockBuilder('Netgen\Bundle\MoreBundle\NetgenMoreBundle')
            ->disableOriginalConstructor()
            ->getMock();

        $this->load();

        $this->assertContainerBuilderHasParameter('netgen_admin_ui.logo_type', 'ngadminui');
    }

    protected function getContainerExtensions()
    {
        return array(
            new NetgenAdminUIExtension(),
        );
    }
}
