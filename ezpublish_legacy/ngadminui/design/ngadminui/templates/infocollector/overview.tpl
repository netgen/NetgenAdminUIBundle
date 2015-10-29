<form name="objects" method="post" action={'/infocollector/overview/'|ezurl}>

    {let number_of_items=min( ezpreference( 'admin_infocollector_list_limit' ), 3)|choose( 10, 10, 25, 50 )}


    {* DESIGN: Header START *}
    <div class="box-header">

        <h1 class="context-title">{'Objects that have collected information (%object_count)'|i18n( 'design/admin/infocollector/overview',, hash( '%object_count', $object_count ) )}</h1>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

    {* DESIGN: Header END *}
    </div>

    {* DESIGN: Content START *}
    <div class="box-content panel">

        {section show=$object_array}
        {* Items per page selector. *}
        <div class="context-toolbar">
            <p class="btn-group">
                {switch match=$number_of_items}
                {case match=25}
                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_infocollector_list_limit/1'|ezurl}>10</a>
                <span class="btn btn-default btn-sm active">25</span>
                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_infocollector_list_limit/3'|ezurl}>50</a>
                {/case}

                {case match=50}
                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_infocollector_list_limit/1'|ezurl}>10</a>
                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_infocollector_list_limit/2'|ezurl}>25</a>
                <span class="btn btn-default btn-sm active">50</span>
                {/case}

                {case}
                <span class="btn btn-default btn-sm active">10</span>
                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_infocollector_list_limit/2'|ezurl}>25</a>
                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_infocollector_list_limit/3'|ezurl}>50</a>
                {/case}

                {/switch}
            </p>
        </div>

        {* Object table. *}
        <table class="list" cellspacing="0">
            <tr>
                <th class="tight"><i class="fa fa-check-square-o" title="{'Invert selection.'|i18n( 'design/admin/infocollector/overview' )}" onclick="ezjs_toggleCheckboxes( document.objects, 'ObjectIDArray[]' ); return false;"></i></th>
                <th>{'Name'|i18n( 'design/admin/infocollector/overview' )}</th>
                <th>{'Type'|i18n( 'design/admin/infocollector/overview' )}</th>
                <th>{'First collection'|i18n( 'design/admin/infocollector/overview' )}</th>
                <th>{'Last collection'|i18n( 'design/admin/infocollector/overview' )}</th>
                <th class="tight">{'Collections'|i18n( 'design/admin/infocollector/overview' )}</th>
            </tr>
            {section var=Objects loop=$object_array sequence=array( bglight, bgdark )}
            <tr class="{$Objects.sequence}">
                <td><input type="checkbox" name="ObjectIDArray[]" value="{$Objects.item.contentobject_id}" title="{'Select collections for removal.'|i18n( 'design/admin/infocollector/overview' )}" /></td>
                <td>{$Objects.item.class_identifier|icon( 'small', 'section'|i18n( 'design/admin/infocollector/overview' ) )}&nbsp;<a href={concat( '/content/view/full/', $Objects.item.main_node_id )|ezurl}>{$Objects.item.name|wash}</a></td>
                <td>{$Objects.item.class_name|wash}</td>
                <td>{$Objects.item.first_collection|l10n( shortdatetime )}</td>
                <td>{$Objects.item.last_collection|l10n( shortdatetime )}</td>
                <td class="number" align="right"><a href={concat( '/infocollector/collectionlist/', $Objects.item.contentobject_id )|ezurl}>{$Objects.item.collections}</a></td>
            </tr>
            {/section}
        </table>
        {section-else}
        <div class="block">
            <p>{'There are no objects that have collected any information.'|i18n( 'design/admin/infocollector/overview' )}</p>
        </div>

        {/section}

        {* Navigator. *}
        <div class="context-toolbar">
            {include name=navigator
                 uri='design:navigator/google.tpl'
                 page_uri='/infocollector/overview'
                 item_count=$object_count
                 view_parameters=$view_parameters
                 item_limit=$limit}
        </div>

        {* DESIGN: Content END *}

        {* Buttons. *}
        <div class="controlbar">
            {* DESIGN: Control bar START *}
                {if $object_array}
                <input class="btn btn-default" type="submit" name="RemoveObjectCollectionButton" value="{'Remove selected'|i18n( 'design/admin/infocollector/overview' )}" title="{'Remove all information that was collected by the selected objects.'|i18n( 'design/admin/infocollector/overview' )}" />
                {else}
                <input class="btn btn-default" type="submit" name="RemoveObjectCollectionButton" value="{'Remove selected'|i18n( 'design/admin/infocollector/overview' )}" disabled="disabled" />
                {/if}
            {* DESIGN: Control bar END *}
        </div>

    </div>

    {/let}

</form>
