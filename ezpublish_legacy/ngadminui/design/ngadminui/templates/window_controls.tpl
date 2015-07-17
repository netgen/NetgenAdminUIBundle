{* Window controls *}
{def $node_url_alias      = $node.url_alias
     $tabs_disabled       = false()
     $admin_navigation_content_pref = ezpreference( 'admin_navigation_content' )
     $default_tab         = 'view'
     $node_tab_index      = first_set( $view_parameters.tab, $default_tab )
     $read_open_tab_by_cookie = true()
     $available_languages = fetch( 'content', 'prioritized_languages' )
     $translations        = $node.object.languages
     $translations_count  = $translations|count
     $states              = $node.object.allowed_assign_state_list
     $states_count        = $states|count
     $related_objects_count = fetch( 'content', 'related_objects_count', hash( 'object_id', $node.object.id , 'all_relations', true() ) )
     $reverse_related_objects_count = fetch( 'content', 'reverse_related_objects_count', hash( 'object_id', $node.object.id , 'all_relations', true() ) )
     $additional_tabs = array()
     $additional_tabs_count = 0
     $valid_tabs = array( $default_tab, 'details', 'translations', 'locations', 'relations', 'states' )
     $navigation_part_name = fetch( 'section', 'object', hash( 'section_id', $node.object.section_id ) ).navigation_part_identifier
}

{if $admin_navigation_content_pref|is_string}{set $tabs_disabled = $admin_navigation_content_pref|not}{/if}

{if eq( $navigation_part_name, 'ezusernavigationpart' )}
{def $assigned_policies   = fetch( 'user', 'user_role', hash( 'user_id', $node.contentobject_id ) )
     $assigned_roles      = fetch( 'user', 'member_of', hash( 'id', $node.contentobject_id ) )}
{/if}

{foreach ezini( 'WindowControlsSettings', 'AdditionalTabs', 'admininterface.ini' ) as $tab}
    {def $tab_navigation_part = ezini( concat( 'AdditionalTab_', $tab ), 'NavigationPartName', 'admininterface.ini' )}
    {if eq( $tab_navigation_part, $navigation_part_name )}
        {set $additional_tabs = $additional_tabs|append( $tab )}
    {/if}
    {undef $tab_navigation_part}
{/foreach}

{set $valid_tabs = $valid_tabs|append( $additional_tabs )
     $additional_tabs_count = $additional_tabs|count()}


<ul class="tabs{if $read_open_tab_by_cookie} tabs-by-cookie{/if} clearfix">

    {* Ordering *}
    <li id="node-tab-ordering" class="{if $additional_tabs}middle{else}last{/if}{if $node_tab_index|eq('ordering')} selected{/if}">
        <a href={concat( $node_url_alias, '/(tab)/ordering' )|ezurl} title="{'Show published ordering overview.'|i18n( 'design/admin/node/view/full' )}">Sub items</a>
    </li>

    {* Content (pre)view *}
    <li id="node-tab-view" class="first{if $node_tab_index|eq('view')} selected{/if}">
        <a href={concat( $node_url_alias, '/(tab)/view' )|ezurl} title="{'Show simplified view of content.'|i18n( 'design/admin/node/view/full' )}">Content</a>
    </li>

    {* Translations *}
    {if fetch( 'content', 'translation_list' )|count|gt( 1 )}
        {if $available_languages|count|gt( 1 ) }
            <li id="node-tab-translations" class="middle{if $node_tab_index|eq('translations')} selected{/if}">
                <a href={concat( $node_url_alias, '/(tab)/translations' )|ezurl} title="{'Show available translations.'|i18n( 'design/admin/node/view/full' )}">{'Translations (%count)'|i18n( 'design/admin/node/view/full',,hash('%count', $translations_count ) )}</a>
            </li>
        {/if}
    {/if}

    {* Locations *}
    <li id="node-tab-locations" class="middle{if $node_tab_index|eq('locations')} selected{/if}">
        <a href={concat( $node_url_alias, '/(tab)/locations' )|ezurl} title="{'Show location overview.'|i18n( 'design/admin/node/view/full' )}">{'Locations (%count)'|i18n( 'design/admin/node/view/full',, hash( '%count', $node.object.assigned_nodes|count ) )}</a>
    </li>

    {* Relations *}
    <li id="node-tab-relations" class="middle{if $node_tab_index|eq('relations')} selected{/if}">
        <a href={concat( $node_url_alias, '/(tab)/relations' )|ezurl} title="{'Show object relation overview.'|i18n( 'design/admin/node/view/full' )}">{'Relations (%count)'|i18n( 'design/admin/node/view/full',, hash( '%count', sum( $related_objects_count, $reverse_related_objects_count ) ) )}</a>
    </li>

    {include uri='design:window_controls_extratabs.tpl'}

</ul>

<div class="clearfix">
    <div class="tabs-content">
        {include uri='design:windows.tpl'}
    </div>
</div>

{ezscript_require( 'node_tabs.js' )}
{undef}
