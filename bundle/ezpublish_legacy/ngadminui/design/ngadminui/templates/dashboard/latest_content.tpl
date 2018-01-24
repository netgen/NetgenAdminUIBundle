{cache-block keys=array( $user.contentobject_id )}

{def $latest_content = fetch( 'content', 'tree', hash( 'parent_node_id',   ezini( 'NodeSettings', 'RootNode', 'content.ini' ),
                                                       'limit',            $block.number_of_items,
                                                       'main_node_only',   true(),
                                                       'sort_by',          array( 'modified', false() ),
                                                       'attribute_filter', array( array( 'owner', '=', $user.contentobject_id ) ) ) )}

<h2>{'My latest content'|i18n( 'design/admin/dashboard/latest_content' )}</h2>

{if $latest_content}

<table class="list" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <th>{'Name'|i18n( 'design/admin/dashboard/latest_content' )}</th>
        <th>{'Type'|i18n( 'design/admin/dashboard/latest_content' )}</th>
        <th>{'Modified'|i18n( 'design/admin/dashboard/latest_content' )}</th>
        <th class="tight"></th>
    </tr>
    {foreach $latest_content as $latest_node sequence array( 'bglight', 'bgdark' ) as $style}
        <tr class="{$style}">
            <td>
                <a href="{$latest_node.url_alias|ezurl('no')}" title="{$latest_node.name|wash()}">{$latest_node.name|shorten('30')|wash()}</a>
            </td>
            <td>
                {$latest_node.class_name|wash()}
            </td>
            <td>
                {$latest_node.object.modified|l10n('shortdate')}
            </td>
            <td>
            {if $latest_node.can_edit}
                <a href="{concat( 'content/edit/', $latest_node.contentobject_id, '/f/', $latest_node.object.default_language )|ezurl('no')}">
                    <i class="fa fa-pencil-square-o" title="{'Edit <%child_name>.'|i18n( 'design/admin/dashboard/latest_content',, hash( '%child_name', $latest_node.name) )|wash}"></i>
                </a>
            {else}
                <img src="{'edit-disabled.gif'|ezimage('no')}" alt="{'Edit'|i18n( 'design/admin/dashboard/latest_content' )}" title="{'You do not have permission to edit <%child_name>.'|i18n( 'design/admin/dashboard/latest_content',, hash( '%child_name', $child_name ) )|wash}" />
            {/if}
            </td>
        </tr>
    {/foreach}
</table>

{else}

<p>{'Your latest content list is empty.'|i18n( 'design/admin/dashboard/latest_content' )}</p>

{/if}

{undef $latest_content}

{/cache-block}
