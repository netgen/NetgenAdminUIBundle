<?php

namespace Netgen\Bundle\AdminUIBundle\MenuPlugin;

use Netgen\TagsBundle\Templating\Twig\Extension\AdminExtension;
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
            'aside' => 'NetgenAdminUIBundle:menu/plugins/tags:aside.html.twig',
            'left' => 'NetgenAdminUIBundle:menu/plugins/tags:left.html.twig',
        );
    }

    /**
     * Returns if the menu is active.
     *
     * @return bool
     */
    public function isActive()
    {
        return isset($this->enabledBundles['NetgenTagsBundle']) && class_exists(AdminExtension::class);
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
