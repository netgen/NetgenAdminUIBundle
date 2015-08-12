{if fetch( user, has_access_to, hash( module, ngmore, function, show_layouts ) )}
    <li id="node-tab-layout" class="{if $last}last{else}middle{/if}{if $node_tab_index|eq('layout')} selected{/if}">
        {if $tabs_disabled}
            <span class="disabled">{'Sidebar'|i18n( 'design/ngmore/node/view' )}</span>
        {else}
            <a href={concat( $node_url_alias, '/(tab)/layout' )|ezurl} title="{'Show sidebar details.'|i18n( 'design/ngmore/node/view' )}">{'Sidebar'|i18n( 'design/ngmore/node/view' )}</a>
        {/if}
    </li>
{/if}
