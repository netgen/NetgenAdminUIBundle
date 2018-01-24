{def $bookmark_list = fetch( 'content', 'bookmarks', hash() )
     $bookmark_node = 0}
<form name="bookmarkaction" action={concat( 'content/bookmark/' )|ezurl} method="post" >

    <div class="context-block content-bookmark">
        {* DESIGN: Header START *}
        <div class="box-header">
            <h1 class="context-title">{'My bookmarks (%bookmark_count)'|i18n( 'design/admin/content/bookmark',, hash( '%bookmark_count', $bookmark_list|count ) )}</h1>

            {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}
        </div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            {if $bookmark_list}
            <table class="list" cellspacing="0">
                <tr>
                    <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.bookmarkaction, 'DeleteIDArray[]' ); return false;" title="{'Invert selection.'|i18n( 'design/admin/content/bookmark' )}"></i></th>
                    <th>{'Name'|i18n( 'design/admin/content/bookmark' )}</th>
                    <th>{'Type'|i18n( 'design/admin/content/bookmark' )}</th>
                    <th>{'Section'|i18n( 'design/admin/content/bookmark' )}</th>
                    <th class="tight">&nbsp;</th>
                </tr>

                {section var=Bookmarks loop=$bookmark_list sequence=array( bglight, bgdark )}
                <tr class="{$Bookmarks.sequence}">
                    {set $bookmark_node = $Bookmarks.item.node}
                    <td><input type="checkbox" name="DeleteIDArray[]" value="{$Bookmarks.item.id}" title="{'Select bookmark for removal.'|i18n( 'design/admin/content/bookmark' )}" /></td>
                    <td>{$bookmark_node.class_identifier|class_icon( small, $bookmark_node.class_name )}&nbsp;<a href={concat( '/content/view/full/', $Bookmarks.item.node_id, '/' )|ezurl}>{$bookmark_node.name|wash}</a></td>
                    <td>{$bookmark_node.class_name|wash}</td>
                    <td>{let section_object=fetch( section, object, hash( section_id, $bookmark_node.object.section_id ) )}{section show=$section_object}{$section_object.name|wash}{section-else}<i>{'Unknown'|i18n( 'design/admin/content/bookmark' )}</i>{/section}{/let}</td>
                    <td>
                    {if $bookmark_node.object.can_edit}
                        <a href={concat( 'content/edit/', $bookmark_node.contentobject_id )|ezurl}><i class="fa fa-pencil-square-o" title="{'Edit < %bookmark_name >.'|i18n( 'design/admin/content/bookmark',, hash( '%bookmark_name', $bookmark_node.name ) )|wash}"></i></a>
                    {else}
                        <img src={'edit-disabled.gif'|ezimage} alt="{'Edit'|i18n( 'design/admin/content/bookmark' )}" title="{'You do not have permission to edit the contents of < %bookmark_name >.'|i18n( 'design/admin/content/bookmark',, hash( '%bookmark_name', $bookmark_node.name ) )|wash}" />
                    {/if}
                    </td>
                </tr>
                {/section}
            </table>

            {else}
                <div class="block">
                    <p>{'There are no bookmarks in the list.'|i18n( 'design/admin/content/bookmark' )}</p>
                </div>
            {/if}


            {* DESIGN: Content END *}

            <div class="controlbar">
                {* DESIGN: Control bar START *}
                {if $bookmark_list}
                    <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/bookmark' )}" title="{'Remove selected bookmarks.'|i18n( 'design/admin/content/bookmark' )}" />
                {else}
                    <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/bookmark' )}" disabled="disabled" />
                {/if}

                    <input class="btn btn-default" type="submit" name="AddButton" value="{'Add items'|i18n( 'design/admin/content/bookmark' )}" title="{'Add items to your personal bookmark list.'|i18n( 'design/admin/content/bookmark' )}" />
                {* DESIGN: Control bar END *}</div>
            </div>
        </div>

    </div>

</form>

{undef}
