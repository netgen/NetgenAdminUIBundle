{if and( ezmodule( 'nglayouts' ), fetch( 'user', 'has_access_to', hash( 'module', 'nglayouts', 'function', 'editor' ) ) )}
    {symfony_include(
        '@NetgenAdminUI/layouts/netgen_layouts.html.twig',
        hash( 'location', $node )
    )}
{/if}
