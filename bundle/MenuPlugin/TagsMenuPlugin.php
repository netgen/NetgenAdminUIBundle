<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

use Netgen\TagsBundle\Version as TagsBundleVersion;
use Symfony\Component\HttpFoundation\Request;

class TagsMenuPlugin implements MenuPluginInterface
{
    /**
     * @var array
     */
    protected $enabledBundles;

    /**
     * Constructor.
     *
     * @param array $enabledBundles
     */
    public function __construct(array $enabledBundles)
    {
        $this->enabledBundles = $enabledBundles;
    }

    /**
     * Returns plugin identifier.
     *
     * @return string
     */
    public function getIdentifier()
    {
        return 'tags';
    }

    /**
     * Returns the list of templates this plugin supports.
     *
     * @return array
     */
    public function getTemplates()
    {
        return array(
            'aside' => '@NetgenAdminUI/menu/plugins/tags/aside.html.twig',
            'left' => '@NetgenAdminUI/menu/plugins/tags/left.html.twig',
        );
    }

    /**
     * Returns if the menu is active.
     *
     * @return bool
     */
    public function isActive()
    {
        if (!isset($this->enabledBundles['NetgenTagsBundle'])) {
            return false;
        }

        return class_exists('Netgen\TagsBundle\Version') && TagsBundleVersion::MAJOR_VERSION >= 3;
    }

    /**
     * Returns if this plugin matches the current request.
     *
     * @param \Symfony\Component\HttpFoundation\Request $request
     *
     * @return bool
     */
    public function matches(Request $request)
    {
        return mb_stripos(
            $request->attributes->get('_route'),
            'netgen_tags_admin'
        ) === 0;
    }
}
