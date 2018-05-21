{if and( ezmodule( 'nglayouts' ), fetch( 'user', 'has_access_to', hash( 'module', 'nglayouts', 'function', 'editor' ) ) )}
    <li id="node-tab-nglayouts" class="{if $last}last{else}middle{/if}{if $node_tab_index|eq('nglayouts')} selected{/if}">
        {if $tabs_disabled}
            <span class="disabled">{'Related layouts'|i18n( 'extension/nglayouts/node/view' )}</span>
        {else}
            <a href={concat( $node_url_alias, '/(tab)/nglayouts' )|ezurl} title="{'Show layouts related to this object/node.'|i18n( 'extension/nglayouts/node/view' )}">{'Related layouts'|i18n( 'extension/nglayouts/node/view' )}</a>
        {/if}
    </li>
{/if}
