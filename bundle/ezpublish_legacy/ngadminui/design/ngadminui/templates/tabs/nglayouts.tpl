{if or(and( ezmodule( 'nglayouts' ), fetch( 'user', 'has_access_to', hash( 'module', 'nglayouts', 'function', 'editor' ) ) ), symfony_is_granted( 'nglayouts:ui:access' ))}
    <div class="mapped-layouts-box" data-url="{symfony_path( 'ngadmin_layouts_location_layouts', hash( 'locationId', $node.node_id ) )}">
        <div class="layouts-box-content"></div>
        <div class="layout-loading"><i class="loading-ng-icon"></i></div>
    </div>
{/if}
