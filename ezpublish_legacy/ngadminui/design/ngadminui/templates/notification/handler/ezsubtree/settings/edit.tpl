{let item_type=ezpreference( 'admin_list_limit' )
     number_of_items=min( $item_type, 3)|choose( 10, 10, 25, 50 )
     subscribed_nodes_count=fetch( 'notification', 'subscribed_nodes_count')}
<div class="context-block panel">
    {* DESIGN: Header START *}
    <h2>{'My item notifications (%notification_count)'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit',, hash( '%notification_count', $subscribed_nodes_count ) )}</h2>



    {* DESIGN: Header END *}

    {* DESIGN: Content START *}

    {if $subscribed_nodes_count}
    {* Items per page *}
    <div class="context-toolbar">
        <div class="button-left">
            <p class="btn-group">
                {switch match=$number_of_items}
                {case match=25}
                    <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/1/notification/settings'|ezurl}>10</a>
                    <span class="btn btn-default btn-sm active">25</span>
                    <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/3/notification/settings'|ezurl}>50</a>
                {/case}

                {case match=50}
                    <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/1/notification/settings'|ezurl}>10</a>
                    <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/2/notification/settings'|ezurl}>25</a>
                    <span class="btn btn-default btn-sm active">50</span>
                {/case}

                {case}
                    <span class="btn btn-default btn-sm active">10</span>
                    <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/2/notification/settings'|ezurl}>25</a>
                    <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/3/notification/settings'|ezurl}>50</a>
                {/case}
                {/switch}
            </p>
        </div>
        <div class="float-break"></div>
    </div>

    <table class="list" cellspacing="0">
        <tr>
            <th class="tight"><i class="fa fa-check-square-o" title="{'Invert selection.'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}" onclick="ezjs_toggleCheckboxes( document.notification, 'SelectedRuleIDArray_{$handler.id_string}[]' ); return false;"></i></th>
            <th>{'Name'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}</th>
            <th>{'Type'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}</th>
            <th>{'Section'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}</th>
        </tr>

        {section var=Rules loop=fetch( 'notification', 'subscribed_nodes', hash( 'limit', $number_of_items, 'offset', $view_parameters.offset ) ) sequence=array( bglight, bgdark )}
        <tr class="{$Rules.sequence}">
            <td><input type="checkbox" name="SelectedRuleIDArray_{$handler.id_string}[]" value="{$Rules.item.id}" title="{'Select item for removal.'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}" /></td>
            <td>{$Rules.item.node.class_identifier|class_icon( small, $Rules.item.node.class_name )}&nbsp;<a href={concat( '/content/view/full/', $Rules.item.node.node_id, '/' )|ezurl}>{$Rules.item.node.name|wash}</a></td>
            <td>{$Rules.item.node.class_name|wash}</td>
            <td>{let section_object=fetch( section, object, hash( section_id, $Rules.item.node.object.section_id ) )}{section show=$section_object}{$section_object.name|wash}{section-else}<i>{'Unknown'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}</i>{/section}{/let}</td>
        </tr>
        {/section}
    </table>

    <div class="context-toolbar">
        {include name=navigator
             uri='design:navigator/google.tpl'
             page_uri='/notification/settings'
             item_count=$subscribed_nodes_count
             view_parameters=$view_parameters
             item_limit=$number_of_items}
    </div>

    {else}
    <div class="block">
        <p>{'You have not subscribed to receive notifications about any items.'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}</p>
    </div>
    {/if}

    {* DESIGN: Content END *}

    <div class="controlbar">
    {* DESIGN: Control bar START *}
            {if $subscribed_nodes_count}
            <input class="btn btn-default" type="submit" name="RemoveRule_{$handler.id_string}" value="{'Remove selected'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}" title="{'Remove selected items.'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}" />
            {else}
            <input class="btn btn-default" type="submit" name="RemoveRule_{$handler.id_string}" value="{'Remove selected'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}" disabled="disabled" />
            {/if}

            <input class="btn btn-default" type="submit" name="NewRule_{$handler.id_string}" value="{'Add items'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}" title="{'Add items to your personal notification list.'|i18n( 'design/admin/notification/handler/ezsubtree/settings/edit' )}" />

    {* DESIGN: Control bar END *}
    </div>

</div>
{/let}
