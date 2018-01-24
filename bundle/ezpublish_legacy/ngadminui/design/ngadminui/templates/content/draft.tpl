{let item_type=ezpreference( 'admin_list_limit' )
     number_of_items=min( $item_type, 3)|choose( 10, 10, 25, 50 )
     list_count=fetch('content','draft_count')}

<form name="draftaction" action={concat( 'content/draft/' )|ezurl} method="post">

    <div class="context-block content-draft">

        {* DESIGN: Header START *}
        <div class="box-header">

            <h1 class="context-title">{'My drafts (%draft_count)'|i18n(  'design/admin/content/draft',, hash( '%draft_count', $list_count ) )}</h1>

            {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}
        </div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            {if $list_count}

            {* Items per page and view mode selector. *}
            <div class="context-toolbar">
                <div class="button-left">
                    <p class="btn-group">
                    {switch match=$number_of_items}
                        {case match=25}
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/1/content/draft'|ezurl}>10</a>
                        <span class="btn btn-default btn-sm active">25</span>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/3/content/draft'|ezurl}>50</a>
                        {/case}

                        {case match=50}
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/1/content/draft'|ezurl}>10</a>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/2/content/draft'|ezurl}>25</a>
                        <span class="btn btn-default btn-sm active">50</span>
                        {/case}

                        {case}
                        <span class="btn btn-default btn-sm active">10</span>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/2/content/draft'|ezurl}>25</a>
                        <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_list_limit/3/content/draft'|ezurl}>50</a>
                        {/case}
                    {/switch}
                    </p>
                </div>
                <div class="break"></div>
            </div>

            <table class="list" cellspacing="0">
                <tr>
                    <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.draftaction, 'DeleteIDArray[]' ); return false;" title="{'Invert selection.'|i18n( 'design/admin/content/draft' )}"></i></th>
                    <th>{'Name'|i18n( 'design/admin/content/draft' )}</th>
                    <th>{'Type'|i18n( 'design/admin/content/draft' )}</th>
                    <th>{'Section'|i18n( 'design/admin/content/draft' )}</th>
                    <th>{'Language'|i18n( 'design/admin/content/draft' )}</th>
                    <th>{'Modified'|i18n( 'design/admin/content/draft' )}</th>
                    <th class="tight">&nbsp;</th>
                </tr>

                {section var=Drafts loop=fetch( content, draft_version_list, hash( limit, $number_of_items, offset, $view_parameters.offset ) ) sequence=array( bglight, bgdark )}
                <tr class="{$Drafts.sequence}">
                    <td><input type="checkbox" name="DeleteIDArray[]" value="{$Drafts.item.id}" title="{'Select draft for removal.'|i18n( 'design/admin/content/draft' )}" /></td>
                    <td>{$Drafts.item.contentobject.content_class.identifier|class_icon( small, $Drafts.item.contentobject.content_class.name|wash )}&nbsp;<a href={concat( '/content/versionview/', $Drafts.item.contentobject.id, '/', $Drafts.item.version, '/', $Drafts.item.initial_language.locale, '/' )|ezurl}>{$Drafts.item.version_name|wash}</a></td>
                    <td>{$Drafts.item.contentobject.content_class.name|wash}</td>
                    <td>{let section_object=fetch( section, object, hash( section_id, $Drafts.item.contentobject.section_id ) )}{section show=$section_object}{$section_object.name|wash}{section-else}<i>{'Unknown'|i18n( 'design/admin/content/draft' )}</i>{/section}{/let}</td>
                    <td><img src="{$Drafts.item.initial_language.locale|flag_icon}" width="18" height="12" alt="{$Drafts.item.initial_language.locale|wash}" style="vertical-align: middle;" />&nbsp;{$Drafts.item.initial_language.name|wash}</td>
                    <td>{$Drafts.item.modified|l10n( shortdatetime )}</td>
                    <td><a href={concat( '/content/edit/', $Drafts.item.contentobject.id, '/', $Drafts.item.version, '/' )|ezurl} title="{'Edit < %draft_name >.'|i18n( 'design/admin/content/draft',, hash( '%draft_name', $Drafts.item.name ) )|wash}" ><i class="fa fa-pencil"></i></a></a></td>
                </tr>
                {/section}
            </table>
            {else}
            <div class="block">
                <p>{'There are no drafts that belong to you.'|i18n( 'design/admin/content/draft' )}</p>
            </div>
            {/if}

            <div class="context-toolbar">
                {include name=navigator
                     uri='design:navigator/google.tpl'
                     page_uri='/content/draft'
                     item_count=$list_count
                     view_parameters=$view_parameters
                     item_limit=$number_of_items}
            </div>

            {* DESIGN: Content END *}

            <div class="controlbar">
                {* DESIGN: Control bar START *}
                {if $list_count}
                    <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/draft')}" title="{'Remove selected drafts.'|i18n( 'design/admin/content/draft' )}" />
                    <input class="btn btn-default" type="submit" name="EmptyButton"  value="{'Remove all'|i18n( 'design/admin/content/draft')}" onclick="return confirmDiscard( '{'Are you sure you want to remove all drafts?'|i18n( 'design/admin/content/draft' )|wash(javascript)}' );" title="{'Remove all drafts that belong to you.'|i18n( 'design/admin/content/draft' )}" />
                {else}
                    <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/draft')}" disabled="disabled" />
                    <input class="btn btn-default" type="submit" name="EmptyButton"  value="{'Remove all'|i18n( 'design/admin/content/draft')}" disabled="disabled" />
                {/if}
            </div>
            {* DESIGN: Control bar END *}
        </div>

    </div>

</form>

{/let}
{literal}
<script type="text/javascript">
    function confirmDiscard( question )
    {
        // Ask user if he really wants to do it.
        return confirm( question );
    }
</script>
{/literal}

