<!-- Maincontent START -->

{switch match=$edit_warning}
    {case match=1}
        <div class="message-warning">
            <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Version is not a draft'|i18n( 'design/admin/content/history' )}</h2>
            <ul>
                <li>{'Version %1 is not available for editing anymore. Only drafts can be edited.'|i18n( 'design/admin/content/history',, array( $edit_version ) )}</li>
                <li>{'To edit this version, first create a copy of it.'|i18n( 'design/admin/content/history' )}</li>
            </ul>
        </div>
    {/case}
    {case match=2}
        <div class="message-warning">
            <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Version is not yours'|i18n( 'design/admin/content/history' )}</h2>
            <ul>
                <li>{'Version %1 was not created by you. You can only edit your own drafts.'|i18n( 'design/admin/content/history',, array( $edit_version ) )}</li>
                <li>{'To edit this version, first create a copy of it.'|i18n( 'design/admin/content/history' )}</li>
            </ul>
        </div>
    {/case}
    {case match=3}
        <div class="message-warning">
            <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Unable to create new version'|i18n( 'design/admin/content/history' )}</h2>
            <ul>
                <li>{'Version history limit has been exceeded and no archived version can be removed by the system.'|i18n( 'design/admin/content/history' )}</li>
                <li>{'You can change your version history settings in content.ini, remove draft versions or edit existing drafts.'|i18n( 'design/admin/content/history' )}</li>
            </ul>
        </div>
    {/case}
    {case}
    {/case}
{/switch}


{def $page_limit   = 30
     $list_count   = fetch( 'content', 'version_count', hash( 'contentobject', $object ))}
<div class="path-edit-container"></div>
<form name="versionsform" action={concat( '/content/history/', $object.id, '/' )|ezurl} method="post">

    <div class="panel content-history">

        {* DESIGN: Header START *}
        <h1>{'Versions for < %object_name > (%version_count)'|i18n( 'design/admin/content/history',, hash( '%object_name', $object.name, '%version_count', $list_count ) )|wash}</h1>
        {* DESIGN: Mainline *}<div class="header-mainline"></div>
        {* DESIGN: Header END *}
        {* DESIGN: Content START *}

        {if $list_count}
        <table class="list" cellspacing="0">
            <tr>
                <th class="tight"><i class="fa fa-pencil-square-o" onclick="ezjs_toggleCheckboxes( document.versionsform, 'DeleteIDArray[]' ); return false;"></i></th>
                <th>{'Version'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Status'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Modified translation'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Creator'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Created'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Modified'|i18n( 'design/admin/content/history' )}</th>
                <th class="tight">&nbsp;</th>
                <th class="tight">&nbsp;</th>
            </tr>

            {def $version_list = fetch( 'content', 'version_list',  hash( 'contentobject', $object, 'limit', $page_limit, 'offset', $view_parameters.offset ))}
            {foreach $version_list as $version sequence array( 'bglight', 'bgdark' ) as $seq}

            {def $initial_language = $version.initial_language
                 $can_edit_lang = 0}
            <tr class="{$seq}">

                {* Remove. *}
                <td>
                    {if and( $version.can_remove, array( 0, 3, 4, 5 )|contains( $version.status ) )}
                        <input type="checkbox" name="DeleteIDArray[]" value="{$version.id}" title="{'Select version #%version_number for removal.'|i18n( 'design/admin/content/history',, hash( '%version_number', $version.version ) )}" />
                    {else}
                        <input type="checkbox" name="_Disabled" value="" disabled="disabled" title="{'Version #%version_number cannot be removed because it is either the published version of the object or because you do not have permission to remove it.'|i18n( 'design/admin/content/history',, hash( '%version_number', $version.version ) )}" />
                    {/if}
                </td>

                {* Version/view. *}
                <td><a href={concat( '/content/versionview/', $object.id, '/', $version.version, '/', $initial_language.locale )|ezurl} title="{'View the contents of version #%version_number. Translation: %translation.'|i18n( 'design/admin/content/history',, hash( '%version_number', $version.version, '%translation', $initial_language.name ) )}">{$version.version}</a></td>

                {* Status. *}
                <td>{$version.status|choose( 'Draft'|i18n( 'design/admin/content/history' ), 'Published'|i18n( 'design/admin/content/history' ), 'Pending'|i18n( 'design/admin/content/history' ), 'Archived'|i18n( 'design/admin/content/history' ), 'Rejected'|i18n( 'design/admin/content/history' ), 'Untouched draft'|i18n( 'design/admin/content/history' ), 'Repeat'|i18n( 'design/standard/content/history' ), 'Queued'|i18n( 'design/standard/content/history' ) )}</td>

                {* Modified translation. *}
                <td>
                    <img src="{$initial_language.locale|flag_icon}" width="18" height="12" alt="{$initial_language.locale}" />&nbsp;<a href={concat('/content/versionview/', $object.id, '/', $version.version, '/', $initial_language.locale, '/' )|ezurl} title="{'View the contents of version #%version_number. Translation: %translation.'|i18n( 'design/admin/content/history',, hash( '%translation', $initial_language.name, '%version_number', $version.version ) )}" >{$initial_language.name|wash}</a>
                </td>

                {* Creator. *}
                <td>{$version.creator.name|wash}</td>

                {* Created. *}
                <td>{$version.created|l10n( shortdatetime )}</td>

                {* Modified. *}
                <td>{$version.modified|l10n( shortdatetime )}</td>

                {* Copy button. *}
                <td align="right" class="right">
                {foreach $object.can_edit_languages as $edit_language}
                    {if eq( $edit_language.id, $initial_language.id )}
                    {set $can_edit_lang = 1}
                    {/if}
                {/foreach}

                    {if and( $can_edit, $can_edit_lang )}
                      {if eq( $version.status, 5 )}
                        <input type="image" src={'copy-disabled.gif'|ezimage} name="_Disabled" value="" disabled="disabled" title="{'There is no need to make copies of untouched drafts.'|i18n( 'design/admin/content/history' )}" />
                      {else}
                        <input type="hidden" name="CopyVersionLanguage[{$version.version}]" value="{$initial_language.locale}" />
                        <input type="image" src={'copy.gif'|ezimage} name="HistoryCopyVersionButton[{$version.version}]" value="" title="{'Create a copy of version #%version_number.'|i18n( 'design/admin/content/history',, hash( '%version_number', $version.version ) )}" />
                      {/if}
                    {else}
                        <input type="image" src={'copy-disabled.gif'|ezimage} name="_Disabled" value="" disabled="disabled" title="{'You cannot make copies of versions because you do not have permission to edit the object.'|i18n( 'design/admin/content/history' )}" />
                    {/if}
                </td>

                {* Edit button. *}
                <td>
                    {if and( array(0, 5)|contains($version.status), $version.creator_id|eq( $user_id ), $can_edit ) }
                        <input type="image" src={'edit.gif'|ezimage} name="HistoryEditButton[{$version.version}]" value="" title="{'Edit the contents of version #%version_number.'|i18n( 'design/admin/content/history',, hash( '%version_number', $version.version ) )}" />
                    {else}
                        <input type="image" src={'edit-disabled.gif'|ezimage} name="HistoryEditButton[{$version.version}]" value="" disabled="disabled" title="{'You cannot edit the contents of version #%version_number either because it is not a draft or because you do not have permission to edit the object.'|i18n( 'design/admin/content/history',, hash( '%version_number', $version.version ) )}" />
                    {/if}
                </td>

            </tr>
            {undef $initial_language $can_edit_lang}
            {/foreach}
            {undef $version_list}
        </table>
        {else}
            <div class="block">
                <p>{'This object does not have any versions.'|i18n( 'design/admin/content/history' )}</p>
            </div>
        {/if}

        <div class="context-toolbar">
            {include name=navigator
                 uri='design:navigator/google.tpl'
                 page_uri=concat( '/content/history/', $object.id, '///' )
                 item_count=$list_count
                 view_parameters=$view_parameters
                 item_limit=$page_limit}
        </div>

        {* DESIGN: Content END *}

        <div class="controlbar">
        {* DESIGN: Control bar START *}
            <div class="clearfix form-group">
                <div class="button-left">
                    <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/history' )}" title="{'Remove the selected versions from the object.'|i18n( 'design/admin/content/history' )}" />
                    <input type="hidden" name="DoNotEditAfterCopy" value="" />
                </div>
                {if $object.can_diff}
                    {def $languages=$object.languages}
                    <div class="button-right">
                        <form action={concat( $module.functions.history.uri, '/', $object.id, '/' )|ezurl} method="post">
                                <select name="Language" class="form-control inline">
                                    {foreach $languages as $lang}
                                        <option value="{$lang.locale}">{$lang.name|wash}</option>
                                    {/foreach}
                                </select>
                                <select name="FromVersion" class="form-control inline">
                                    {foreach $object.versions as $ver}
                                        <option {if eq( $ver.version, $selectOldVersion)}selected="selected"{/if} value="{$ver.version}">{$ver.version|wash}</option>
                                    {/foreach}
                                </select>
                                <select name="ToVersion" class="form-control inline">
                                    {foreach $object.versions as $ver}
                                        <option {if eq( $ver.version, $selectNewVersion)}selected="selected"{/if} value="{$ver.version}">{$ver.version|wash}</option>
                                    {/foreach}
                                </select>
                            <input type="hidden" name="ObjectID" value="{$object.id}" />
                            <input class="btn btn-primary" type="submit" name="DiffButton" value="{'Show differences'|i18n( 'design/admin/content/history' )}" />
                        </form>
                    </div>
                {/if}
            </div>
            <form name="versionsback" action={concat( '/content/history/', $object.id, '/' )|ezurl} method="post">
                {if is_set( $redirect_uri )}
                <input class="form-control" type="hidden" name="RedirectURI" value="{$redirect_uri}" />
                {/if}
                <input class="btn btn-primary" type="submit" name="BackButton" value="&larr; {'Back'|i18n( 'design/admin/content/history' )}" />
            </form>
        </div>



        {* DESIGN: Control bar END *}


    </div>

    {if and( is_set( $object ), is_set( $diff ), is_set( $oldVersion ), is_set( $newVersion ) )|not}
    {* Published context block start *}
    {* Published window. *}
    <div class="panel">
        {* DESIGN: Header START *}
            <h2>{'Published version'|i18n( 'design/admin/content/history' )}</h2>
        {* DESIGN: Header END *}

        {* DESIGN: Content START *}


        <table class="list" cellspacing="0">
            <tr>
                <th>{'Version'|i18n( 'design/admin/content/history' )}</th>
                <th>{"Translations"|i18n("design/admin/content/history")}</th>
                <th>{'Creator'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Created'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Modified'|i18n( 'design/admin/content/history' )}</th>
                <th class="tight">{'Copy translation'|i18n( 'design/admin/content/history' )}</th>
                <th class="tight">&nbsp;</th>
            </tr>

            {def $published_item=$object.current
                 $initial_language = $published_item.initial_language}
            <tr>

                {* Version/view. *}
                <td><a href={concat( '/content/versionview/', $object.id, '/', $published_item.version, '/', $initial_language.locale )|ezurl} title="{'View the contents of version #%version_number. Translation: %translation.'|i18n( 'design/admin/content/history',, hash( '%version_number', $published_item.version, '%translation', $initial_language.name ) )}">{$published_item.version}</a></td>

                {* Translations *}
                <td>
                    {foreach $published_item.language_list as $lang}
                        {delimiter}<br />{/delimiter}
                        <img src="{$lang.language_code|flag_icon}" width="18" height="12" alt="{$lang.language_code|wash}" />&nbsp;
                        <a href={concat("/content/versionview/",$object.id,"/",$published_item.version,"/",$lang.language_code,"/")|ezurl}>{$lang.locale.intl_language_name|wash}</a>
                    {/foreach}
                </td>

                {* Creator. *}
                <td>{$published_item.creator.name|wash}</td>

                {* Created. *}
                <td>{$published_item.created|l10n( shortdatetime )}</td>

                {* Modified. *}
                <td>{$published_item.modified|l10n( shortdatetime )}</td>

                {* Copy translation list. *}
                <td align="right" class="right">
                    <select class="form-control inline" name="CopyVersionLanguage[{$published_item.version}]">
                        {foreach $published_item.language_list as $lang_list}
                            <option value="{$lang_list.language_code}"{if $lang_list.language_code|eq($published_item.initial_language.locale)} selected="selected"{/if}>{$lang_list.locale.intl_language_name|wash}</option>
                        {/foreach}
                    </select>
                </td>

                {* Copy button *}
                <td>
                    {def $can_edit_lang = 0}
                    {foreach $object.can_edit_languages as $edit_language}
                        {if eq( $edit_language.id, $initial_language.id )}
                        {set $can_edit_lang = 1}
                        {/if}
                    {/foreach}

                    {if and( $can_edit, $can_edit_lang )}
                        <input type="image" src={'copy.gif'|ezimage} name="HistoryCopyVersionButton[{$published_item.version}]" value="" title="{'Create a copy of version #%version_number.'|i18n( 'design/admin/content/history',, hash( '%version_number', $published_item.version ) )}" />
                    {else}
                        <input type="image" src={'copy-disabled.gif'|ezimage} name="_Disabled" value="" disabled="disabled" title="{'You cannot make copies of versions because you do not have permission to edit the object.'|i18n( 'design/admin/content/history' )}" />
                    {/if}
                    {undef $can_edit_lang}
                </td>

            </tr>
            {undef $initial_language}
        </table>

        {* DESIGN: Content END *}
    </div>
    {* Published context block end *}

    {* New drafts context block *}
    {* Drafts window. *}
    <div class="panel">
        {* DESIGN: Header START *}
            <h2>{'New drafts (%newerDraftCount)'|i18n( 'design/admin/content/history',, hash( '%newerDraftCount', $newerDraftVersionListCount ) )}</h2>
        {* DESIGN: Header END *}
        {* DESIGN: Content START *}

        {if $newerDraftVersionList|count|ge(1)}
        <table class="list" cellspacing="0">
            <tr>
                <th>{'Version'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Modified translation'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Creator'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Created'|i18n( 'design/admin/content/history' )}</th>
                <th>{'Modified'|i18n( 'design/admin/content/history' )}</th>
                <th class="tight">&nbsp;</th>
                <th class="tight">&nbsp;</th>
            </tr>

            {foreach $newerDraftVersionList as $draft_version
                sequence array( bglight, bgdark ) as $seq}
            {def $initial_language = $draft_version.initial_language}
            <tr class="{$seq}">

                {* Version/view. *}
                <td><a href={concat( '/content/versionview/', $object.id, '/', $draft_version.version, '/', $initial_language.locale )|ezurl} title="{'View the contents of version #%version_number. Translation: %translation.'|i18n( 'design/admin/content/history',, hash( '%version_number', $draft_version.version, '%translation', $initial_language.name ) )}">{$draft_version.version}</a></td>

                {* Modified translation. *}
                <td>
                    <img src="{$initial_language.locale|flag_icon}" width="18" height="12" alt="{$initial_language.locale}" />&nbsp;<a href={concat('/content/versionview/', $object.id, '/', $draft_version.version, '/', $initial_language.locale, '/' )|ezurl} title="{'View the contents of version #%version_number. Translation: %translation.'|i18n( 'design/admin/content/history',, hash( '%translation', $initial_language.name, '%version_number', $draft_version.version ) )}" >{$initial_language.name|wash}</a>
                </td>

                {* Creator. *}
                <td>{$draft_version.creator.name|wash}</td>

                {* Created. *}
                <td>{$draft_version.created|l10n( shortdatetime )}</td>

                {* Modified. *}
                <td>{$draft_version.modified|l10n( shortdatetime )}</td>

                {* Copy button. *}
                <td align="right" class="right">
                {def $can_edit_lang = 0}
                {foreach $object.can_edit_languages as $edit_language}
                    {if eq( $edit_language.id, $initial_language.id )}
                    {set $can_edit_lang = 1}
                    {/if}
                {/foreach}

                    {if and( $can_edit, $can_edit_lang )}
                        <input type="hidden" name="CopyVersionLanguage[{$draft_version.version}]" value="{$initial_language.locale}" />
                        <input type="image" src={'copy.gif'|ezimage} name="HistoryCopyVersionButton[{$draft_version.version}]" value="" title="{'Create a copy of version #%version_number.'|i18n( 'design/admin/content/history',, hash( '%version_number', $draft_version.version ) )}" />
                    {else}
                        <input type="image" src={'copy-disabled.gif'|ezimage} name="_Disabled" value="" disabled="disabled" title="{'You cannot make copies of versions because you do not have permission to edit the object.'|i18n( 'design/admin/content/history' )}" />
                    {/if}
                {undef $can_edit_lang}
                </td>

                {* Edit button. *}
                <td>
                    {if and( array(0, 5)|contains($draft_version.status), $draft_version.creator_id|eq( $user_id ), $can_edit ) }
                        <input type="image" src={'edit.gif'|ezimage} name="HistoryEditButton[{$draft_version.version}]" value="" title="{'Edit the contents of version #%version_number.'|i18n( 'design/admin/content/history',, hash( '%version_number', $draft_version.version ) )}" />
                    {else}
                        <input type="image" src={'edit-disabled.gif'|ezimage} name="HistoryEditButton[{$draft_version.version}]" disabled="disabled" value="" title="{'You cannot edit the contents of version #%version_number either because it is not a draft or because you do not have permission to edit the object.'|i18n( 'design/admin/content/history',, hash( '%version_number', $draft_version.version ) )}" />
                    {/if}
                </td>

            </tr>
            {undef $initial_language}
            {/foreach}
        </table>
        {else}
        <div class="block">
            <p>{'This object does not have any drafts.'|i18n( 'design/admin/content/history' )}</p>
        </div>
        {/if}

        {* DESIGN: Content END *}
    </div>

</form>

{elseif and( is_set( $object ), is_set( $diff ), is_set( $oldVersion ), is_set( $newVersion ) )}
{literal}
<script type="text/javascript">
    function show( element, method )
    {
        document.getElementById( element ).className = method;
    }
</script>
{/literal}
{* DESIGN: Header START *}
    <h2>{'Differences between versions %oldVersion and %newVersion'|i18n( 'design/admin/content/history',, hash( '%oldVersion', $oldVersion, '%newVersion', $newVersion ) )}</h2>

{* DESIGN: Header END *}
{* DESIGN: Content START *}

<div id="diffview">

    <div class="context-toolbar">
        <div class="btn-group">
            <a class="btn btn-default btn-sm" href="JavaScript:void(0);" onclick="show('diffview', 'previous'); return false;">{'Old version'|i18n( 'design/admin/content/history' )}</a>
            <a class="btn btn-default btn-sm" href="JavaScript:void(0);" onclick="show('diffview', 'inlinechanges'); return false;">{'Inline changes'|i18n( 'design/admin/content/history' )}</a>
            <a class="btn btn-default btn-sm" href="JavaScript:void(0);" onclick="show('diffview', 'blockchanges'); return false;">{'Block changes'|i18n( 'design/admin/content/history' )}</a>
            <a class="btn btn-default btn-sm" href="JavaScript:void(0);" onclick="show('diffview', 'latest'); return false;">{'New version'|i18n( 'design/admin/content/history' )}</a>
        </div>
    </div>

    <div class="panel preview-content preview-content-diff">
        {foreach $object.data_map as $attr}
            <div class="block">
                <label>{$attr.contentclass_attribute.name}:</label>
                <div class="attribute-view-diff">
                    {attribute_diff_gui view=diff attribute=$attr old=$oldVersion new=$newVersion diff=$diff[$attr.contentclassattribute_id]}
                </div>
            </div>
        {/foreach}
    </div>

</div>

{* DESIGN: Content END *}


<div class="block">
    <form action={concat( '/content/history/', $object.id, '/' )|ezurl} method="post">
        <input class="btn btn-default" type="submit" value="&larr; {'Back to history'|i18n( 'design/admin/content/history' )}" />
    </form>
</div>
{/if}

<!-- Maincontent END -->
