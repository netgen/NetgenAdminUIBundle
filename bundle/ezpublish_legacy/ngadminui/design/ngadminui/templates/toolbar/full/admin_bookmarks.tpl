{def $bookmark_list = fetch( 'content', 'bookmarks', hash( 'limit', 20 ) )
     $bookmark_node = 0}
{if $bookmark_list}
<ul>
    {foreach $bookmark_list as $bookmark}
        {set $bookmark_node = $bookmark.node}
        {if ne( $ui_context, 'edit' )}
             <li>
             {if ne( $ui_context, 'browse')}
                 <a href="#" class="bookmark-edit" onclick="ezpopmenu_showTopLevel( event, 'BookmarkMenu', ez_createAArray( new Array( '%nodeID%', '{$bookmark.node_id}', '%objectID%', '{$bookmark.contentobject_id}', '%bookmarkID%', '{$bookmark.id}', '%languages%', {$bookmark_node.object.language_js_array|wash} ) ) , '{$bookmark.name|shorten(18)|wash(javascript)}'); return false;">{$bookmark_node.class_identifier|class_icon( small, '[%classname] Click on the icon to display a context-sensitive menu.'|i18n( 'design/admin/pagelayout',, hash( '%classname', $bookmark_node.class_name  ) ) )}</a><a href={$bookmark_node.url_alias|ezurl}>{$bookmark_node.name|wash}</a></li>
             {else}
                 {if $bookmark_node.is_container}
                     <span class="bookmark-edit">{$bookmark_node.class_identifier|class_icon( small, $bookmark_node.class_name )}</span><a href={concat( '/content/browse/', $bookmark_node.node_id)|ezurl}>{$bookmark_node.name|wash}</a></li>
                 {else}
                     <span class="bookmark-edit">{$bookmark_node.class_identifier|class_icon( small, $bookmark_node.class_name )}</span>{$bookmark_node.name|wash}</li>
                 {/if}
             {/if}
         {else}
             <li><span class="bookmark-edit">{$bookmark_node.class_identifier|class_icon( small, $bookmark_node.class_name )}</span><span class="disabled">{$bookmark_node.name|wash}</span></li>
         {/if}
    {/foreach}
</ul>
{/if}
{undef $bookmark_list $bookmark_node}

{* Show "Add to bookmarks" button if we're viewing an actual node. *}
{if and( is_set( $module_result.content_info.node_id ), $ui_context|ne( 'edit' ), $ui_context|ne( 'browse' ) )}
    <form method="post" action={'content/action'|ezurl}>
        <input type="hidden" name="ContentNodeID" value="{$module_result.content_info.node_id}" />
        <input class="btn btn-primary" type="submit" name="ActionAddToBookmarks" value="{'Add to bookmarks'|i18n( 'design/admin/pagelayout' )}" title="{'Add the current item to your bookmarks.'|i18n( 'design/admin/pagelayout' )}" />
    </form>
{else}
    <form method="post" action={'content/action'|ezurl}>
        <input class="btn btn-default" type="submit" value="{'Add to bookmarks'|i18n( 'design/admin/pagelayout' )}" disabled="disabled" />
    </form>
{/if}
