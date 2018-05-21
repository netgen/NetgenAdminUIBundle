{if and( ezmodule( 'nglayouts' ), fetch( 'user', 'has_access_to', hash( 'module', 'nglayouts', 'function', 'editor' ) ) )}
    {symfony_render(
        symfony_path(
            'ngadmin_layouts_related_layouts',
            hash( 'locationId', $node.node_id )
        )
    )}
{/if}
