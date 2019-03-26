{if or(and( ezmodule( 'nglayouts' ), fetch( 'user', 'has_access_to', hash( 'module', 'nglayouts', 'function', 'editor' ) ) ), symfony_is_granted( 'nglayouts:ui:access' ))}
    <li id="node-tab-nglayouts" class="{if $last}last{else}middle{/if}{if $node_tab_index|eq('nglayouts')} selected{/if}">
        {if $tabs_disabled}
            <span class="disabled">Netgen Layouts</span>
        {else}
            <a href={concat( $node_url_alias, '/(tab)/nglayouts' )|ezurl} title="{'Show layouts applied or related to this object/node.'|i18n( 'extension/nglayouts/node/view' )}">Netgen Layouts</a>
        {/if}
    </li>
{/if}
