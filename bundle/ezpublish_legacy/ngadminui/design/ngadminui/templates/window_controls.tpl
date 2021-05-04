{* Window controls *}
{def $node_url_alias      = $node.url_alias
     $tabs_disabled       = false()
     $default_tabs        = ezini( 'ViewSettings', 'DefaultTabs', 'ngadminui.ini' )
     $default_tab         = ezini( 'ViewSettings', 'DefaultTab', 'ngadminui.ini' )
     $node_tab_index      = cond( is_set( $default_tabs[$node.object.class_identifier] ), $default_tabs[$node.object.class_identifier], true(), $default_tab )
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

{if eq( $navigation_part_name, 'ezusernavigationpart' )}
{def $assigned_policies   = fetch( 'user', 'user_role', hash( 'user_id', $node.contentobject_id ) )
     $assigned_roles      = fetch( 'user', 'member_of', hash( 'id', $node.contentobject_id ) )}
{/if}

{foreach ezini( 'WindowControlsSettings', 'AdditionalTabs', 'admininterface.ini' ) as $tab}
    {def $tab_navigation_parts = ezini( concat( 'AdditionalTab_', $tab ), 'NavigationPartName', 'admininterface.ini' )|explode( ';' )}
    {if $tab_navigation_parts|contains( $navigation_part_name )}
        {set $additional_tabs = $additional_tabs|append( $tab )}
    {/if}
    {undef $tab_navigation_parts}
{/foreach}

{set $valid_tabs = $valid_tabs|append( $additional_tabs )
     $additional_tabs_count = $additional_tabs|count()}

{if is_set( $view_parameters.tab )}
    {* Signal to node_tab.js that tab is forced by url *}
    {set $node_tab_index = $view_parameters.tab}
{/if}

<div class="window-controls-tabs">
    <ul class="tabs clearfix">

        {* Content (pre)view *}
        <li id="node-tab-view" class="first{if $node_tab_index|eq('view')} selected{/if}">
            <a href={concat( $node_url_alias, '/(tab)/view' )|ezurl} title="{'Show simplified view of content.'|i18n( 'design/admin/node/view/full' )}">{'Overview'|i18n( 'design/admin/node/view/full' )}</a>
        </li>

        {* Ordering *}
        <li id="node-tab-subitems" class="{if $additional_tabs}middle{else}last{/if}{if $node_tab_index|eq('subitems')} selected{/if}">
            <a href={concat( $node_url_alias, '/(tab)/ordering' )|ezurl} title="{'Show subitems.'|i18n( 'design/admin/node/view/full' )}">{'Sub items'|i18n('design/admin/node/view/full')} {if $node.children_count|gt(0)}<span class="badge">{$node.children_count}</span>{/if}</a>
        </li>

        {* Translations *}
        {if fetch( 'content', 'translation_list' )|count|gt( 1 )}
            {if $available_languages|count|gt( 1 ) }
                <li id="node-tab-translations" class="middle{if $node_tab_index|eq('translations')} selected{/if}">
                    <a href={concat( $node_url_alias, '/(tab)/translations' )|ezurl} title="{'Show available translations.'|i18n( 'design/admin/node/view/full' )}">{'Translations'|i18n( 'design/admin/node/view/full',,hash('%count', $translations_count ) )} {if $translations_count|gt(0)}<span class="badge">{$translations_count|wash}</span>{/if}</a>
                </li>
            {/if}
        {/if}

        {* Locations *}
        <li id="node-tab-locations" class="middle{if $node_tab_index|eq('locations')} selected{/if}">
            <a href={concat( $node_url_alias, '/(tab)/locations' )|ezurl} title="{'Show location overview.'|i18n( 'design/admin/node/view/full' )}">{'Locations'|i18n( 'design/admin/node/view/full',, hash( '%count', $node.object.assigned_nodes|count ) )} {if $node.object.assigned_nodes|count|gt(0)}<span class="badge">{$node.object.assigned_nodes|count}</span>{/if}</a>
        </li>

        {* Relations *}
        <li id="node-tab-relations" class="middle{if $node_tab_index|eq('relations')} selected{/if}">
            <a href={concat( $node_url_alias, '/(tab)/relations' )|ezurl} title="{'Show object relation overview.'|i18n( 'design/admin/node/view/full' )}">{'Relations'|i18n( 'design/admin/node/view/full',, hash( '%count', sum( $related_objects_count, $reverse_related_objects_count ) ) )} {if $reverse_related_objects_count|gt(0)}<span class="badge">{sum( $related_objects_count, $reverse_related_objects_count)}</span>{/if}</a>
        </li>

        {include uri='design:window_controls_extratabs.tpl'}

    </ul>
</div>
<div class="clearfix">
    <div class="tabs-content">
        {include uri='design:windows.tpl'}
    </div>
</div>

{ezscript_require( 'node_tabs.js' )}
{undef}
