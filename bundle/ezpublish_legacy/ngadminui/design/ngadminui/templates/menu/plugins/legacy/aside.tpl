{def $liclass='unselected '}
{def $icon='unselected '}
{foreach topmenu($ui_context, true() ) as $index => $menu_item}

    {if $menu_item.navigationpart_identifier|eq('eztagsnavigationpart')}
        {if $hide_navigation_parts|contains($menu_item.navigationpart_identifier)}
            {continue}
        {/if}
    {/if}

    {switch match=$menu_item.url}

        {case match='content/dashboard'}
            {set $icon='fa fa-tachometer'}
        {/case}
        {case match=''}
            {set $icon='fa fa-sitemap'}
        {/case}
        {case match='media'}
          {set $icon='fa fa-picture-o'}
        {/case}
        {case match='users'}
            {set $icon='fa fa-user'}
        {/case}
        {case match='setup/cache'}
            {set $icon='fa fa-cog'}
        {/case}
        {case match='ezfind/elevate'}
            {set $icon='fa fa-database'}
        {/case}
        {case match='tags/dashboard'}
            {set $icon='fa fa-tags'}
        {/case}
        {case}
            {set $icon='fa fa-cubes'}
        {/case}

    {/switch}

    {set $liclass=''}
    {if eq( $module_result.navigation_part, $menu_item.navigationpart_identifier ) }
        {set $liclass='active '}
    {/if}

    <li class="{$liclass}{$menu_item.position} {$menu_item.navigationpart_identifier}">
        {if and( $menu_item.enabled, or( is_unset( $menu_item.access ), $menu_item.access ) )}
            <a href={$menu_item.url|ezurl} title="{$menu_item.tooltip}">
        {else}
            <a href="#">
        {/if}
            <i class="{$icon}"></i>
            <span class="tt{if $index|lt(3)} font-bold{/if}">{$menu_item.name|wash}</span>
        </a>
    </li>

{/foreach}
{undef $liclass $icon}
