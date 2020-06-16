{* Window controls *}
{def $node_url_alias      = $node.url_alias
     $tabs_disabled       = false()
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


<ul class="tabs{if $read_open_tab_by_cookie} tabs-by-cookie{/if} clearfix">

    {* Ordering *}
    <li id="node-tab-groups" class="{if $additional_tabs}middle{else}last{/if}{if $node_tab_index|eq('groups')} selected{/if}">
        <a href={'/user/preferences/set/admin_navigation_class_groups/1'|ezurl} title="{'Show class groups.'|i18n( 'design/admin/class/view' )}">{'Class groups'|i18n( 'design/admin/node/class/view' )}</a>
    </li>

    {* Content (pre)view *}
    <li id="node-tab-templates" class="first{if $node_tab_index|eq('templates')} selected{/if}">
        <a href={'/user/preferences/set/admin_navigation_class_temlates/1'|ezurl} title="{'Show override templates.'|i18n( 'design/admin/class/view' )}">{'Override templates'|i18n( 'design/admin/node/class/view' )}</a>
    </li>

    {* Locations *}
    <li id="node-tab-translations" class="middle{if $node_tab_index|eq('translations')} selected{/if}">
        <a href={'/user/preferences/set/admin_navigation_class_translations/1'|ezurl} title="{'Show available translations.'|i18n( 'design/admin/class/view' )}">{'Translations'|i18n( 'design/admin/class/view' )}</a>

</ul>


{ezscript_require( 'node_tabs.js' )}
{undef}
