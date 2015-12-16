{let item_type = ezpreference( 'admin_list_limit' )
     number_of_items = min( $item_type, 3)|choose( 10, 10, 25, 50 )
     trash_sort_field = first_set(  $view_parameters.sort_field, 'name' )
     trash_sort_order = first_set(  $view_parameters.sort_order, '1' )
     list_count = fetch( 'content', 'trash_count', hash( 'objectname_filter', $view_parameters.namefilter ) ) }

<form name="trashform" action={'content/trash/'|ezurl} method="post" >

    <div class="context-block content-trash">

        {* DESIGN: Header START *}
        <div class="box-header">

            <h1 class="context-title">{'Trash (%list_count)'|i18n( 'design/admin/content/trash',, hash( '%list_count', $list_count ) )}</h1>

            {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}</div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            {if $list_count}
            {* Items per page selector. *}
            <div class="context-toolbar">
                <div class="button-left">
                    <p class="btn-group">
                    {switch match=$number_of_items}
                    {case match=25}
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/1'|ezurl}>10</a>
                        <span class="btn btn-default btn-sm active">25</span>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/3'|ezurl}>50</a>

                        {/case}

                        {case match=50}
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/1'|ezurl}>10</a>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/2'|ezurl}>25</a>
                        <span class="btn btn-default btn-sm active">50</span>
                        {/case}

                        {case}
                        <span class="btn btn-default btn-sm active">10</span>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/2'|ezurl}>25</a>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/3'|ezurl}>50</a>
                        {/case}

                        {/switch}
                    </p>
                </div>
                <div class="float-break"></div>
            </div>

            <table class="list" cellspacing="0">
                <tr>
                    <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.trashform, 'DeleteIDArray[]' ); return false;" title="{'Invert selection.'|i18n( 'design/admin/content/trash' )}"></i></th>
                    <th>{'Name'|i18n( 'design/admin/content/trash')}</th>
                    <th>{'Type'|i18n( 'design/admin/content/trash')}</th>
                    <th>{'Section'|i18n( 'design/admin/content/trash')}</th>
                    <th>{'Original Placement'|i18n( 'design/admin/content/trash')}</th>
                    <th class="tight">&nbsp;</th>
                </tr>

                {section var=tObjects loop=fetch( 'content', 'trash_object_list', hash( 'limit',  $number_of_items,
                                                                                        'offset', $view_parameters.offset,
                                                                                        'sort_by', array( $trash_sort_field, $trash_sort_order ),
                                                                                        'objectname_filter', $view_parameters.namefilter ) ) sequence=array( bglight, bgdark )}
                {let cur_c_object=$tObjects.item.object
                     original_parent = $tObjects.item.original_parent}

                <tr class="{$tObjects.sequence}">
                    <td>
                    <input type="checkbox" name="DeleteIDArray[]" value="{$cur_c_object.id}" title="{'Use these checkboxes to mark items for removal. Click the "Remove selected" button to remove the selected items.'|i18n( 'design/admin/content/trash' )|wash()}" />
                    </td>
                    <td>
                    {$tObjects.item.class_identifier|class_icon( small, $tObjects.item.class_name|wash )}&nbsp;<a href={concat( '/content/versionview/', $cur_c_object.id, '/', $cur_c_object.current_version, '/' )|ezurl}>{$tObjects.item.name|wash}</a>
                    </td>
                    <td>
                    {$tObjects.item.class_name|wash}
                    </td>
                    <td>
                    {let section_object=fetch( section, object, hash( section_id, $cur_c_object.section_id ) )}{section show=$section_object}{$section_object.name|wash}{section-else}<i>{'Unknown'|i18n( 'design/admin/content/trash' )}</i>{/section}{/let}
                    </td>
                    <td>
                    {if $original_parent}<a href={concat( '/', $original_parent.path_identification_string )|ezurl}>{/if}/{$tObjects.item.original_parent_path_id_string|wash}{if $original_parent}</a>{/if}
                    </td>
                    <td>
                    <a href={concat( '/content/restore/', $cur_c_object.id, '/' )|ezurl}><i class="fa fa-pencil-square-o"></i></a>
                    </td>
                </tr>

                {/let}
                {/section}
            </table>

            {else}

            <div class="block">
                <p>{'There are no items in the trash'|i18n( 'design/admin/content/trash' )}.</p>
            </div>

            {/if}

            <div class="context-toolbar">
                {include name=navigator
                     uri='design:navigator/alphabetical.tpl'
                     page_uri='/content/trash'
                     item_count=$list_count
                     view_parameters=$view_parameters
                     item_limit=$number_of_items
                     show_google_navigator=true()}
            </div>


            {* DESIGN: Content END *}

            <div class="controlbar">
                {* DESIGN: Control bar START *}
                <div class="button-left">
                    {if $list_count}
                        <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/trash' )}"  title="{'Permanently remove the selected items.'|i18n( 'design/admin/content/trash' )}" />
                        <input class="btn btn-default" type="submit" name="EmptyButton"  value="{'Empty trash'|i18n( 'design/admin/content/trash' )}" title="{'Permanently remove all items from the trash.'|i18n( 'design/admin/content/trash' )}" />
                    {else}
                        <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/trash' )}" disabled="disabled" />
                        <input class="btn btn-default" type="submit" name="EmptyButton"  value="{'Empty trash'|i18n( 'design/admin/content/trash' )}" disabled="disabled" />
                    {/if}
                </div>
                {* Sorting *}
                <div class="button-right form-inline" id="trash-list-sort-control" style="display:none;">
                    <div class="form-group">
                        <label>{'Sorting'|i18n( 'design/admin/node/view/full' )}:</label>

                        {def $sort_fields = hash( 'class_identifier', 'Class identifier'|i18n( 'design/admin/node/view/full' ),
                                               'class_name', 'Class name'|i18n( 'design/admin/node/view/full' ),
                                               'modified', 'Modified'|i18n( 'design/admin/node/view/full' ),
                                               'name', 'Name'|i18n( 'design/admin/node/view/full' ),
                                               'published', 'Published'|i18n( 'design/admin/node/view/full' ),
                                               'section', 'Section'|i18n( 'design/admin/node/view/full' ) )
                            $sort_title = 'Use these controls to set the sorting method for the sub items of the current location.'|i18n( 'design/admin/node/view/full' )}

                        <select class="form-control" id="trash_sort_field" title="{$sort_title}">
                        {foreach $sort_fields as $key => $item}
                            <option value="{$key}" {if eq( $key, $trash_sort_field )}selected="selected"{/if}>{$item}</option>
                        {/foreach}
                        </select>
                    </div>
                    <div class="form-group">
                        <select class="form-control" id="trash_sort_order" title="{$sort_title}">
                            <option value="0"{if eq($trash_sort_order, '0')} selected="selected"{/if}>{'Descending'|i18n( 'design/admin/node/view/full' )}</option>
                            <option value="1"{if eq($trash_sort_order, '1')} selected="selected"{/if}>{'Ascending'|i18n( 'design/admin/node/view/full' )}</option>
                        </select>

                        <input class="btn btn-default" type="submit" onclick="return trashSortingSelection({'content/trash'|ezurl('single')})" name="SetSorting" value="{'Set'|i18n( 'design/admin/node/view/full' )}" title="{$sort_title}" />
                    </div>
                </div>

            </div>
            {literal}
            <script type="text/javascript">
            document.getElementById('trash-list-sort-control').style.display = '';

            function trashSortingSelection( trashUrl )
            {
                trashUrl += '/(sort_field)/' + document.getElementById('trash_sort_field').value;
                trashUrl += '/(sort_order)/' + document.getElementById('trash_sort_order').value;
                document.location = trashUrl;
                return false;
            }
            </script>
            {/literal}
            <div class="float-break"></div>
            {* DESIGN: Control bar END *}
        </div>
    </div>
</form>
{undef $sort_fields $sort_title}
{/let}

