{if and( is_set( $module_result.ui_context ), $module_result.ui_context|eq( 'navigation' ), fetch( user, has_access_to, hash( module, tags, function, read ) ) )}
    <div id="content-tree">
        <h4 class="leftmenu-hl">{'Tags structure'|i18n( 'extension/eztags/tags/treemenu' )}</h4>

        <div id="contentstructure">
            {include uri='design:tagsstructuremenu/tags_structure_menu_dynamic.tpl' menu_persistence=true()}
        </div>
    </div>
{/if}
