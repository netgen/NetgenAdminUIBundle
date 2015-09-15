{ezpagedata_set( 'hide_side_menu', true() )}

<div class="node-top-switch">
    <form class="dropdown language-switch" method="post" action={'content/action'|ezurl}>
        {def $can_create_languages = $node.object.can_create_languages
                    $languages            = fetch( 'content', 'prioritized_languages' )}
        <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
        <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
        <input name="ContentObjectLanguageCode" value="" type="hidden" />
        <button class="btn btn-default dropdown-toggle" type="button" id="languageDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            <img src="{$node.object.current_language|flag_icon}" width="18" height="12" alt="{$language_code|wash}" style="vertical-align: middle;" /> {$node.object.current_language_object.locale_object.intl_language_name}
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu" aria-labelledby="languageDropdown">
            {def $locale_object = false}
            {foreach $translation_list as $locale_code}
                {set $locale_object = $locale_code|locale()}
                {if eq( $locale_code, $object_languagecode )|not}
                    <li>
                        <a href="" title="{'View translation.'|i18n( 'design/admin/node/view/full' )}">{$locale_object.intl_language_name|shorten( 16 )}</a>
                    </li>
                {/endif}
            {/foreach}
        </ul>

        {* <ul class="dropdown-menu" aria-labelledby="languageDropdown">
            {foreach $node.object.can_edit_languages as $language}
                {if $language.locale|eq($node.object.current_language)|not}
                    <li class="with-edit">
                        <a href={concat( $node.url, '/(language)/', $language.locale )|ezurl} title="{'View translation.'|i18n( 'design/admin/node/view/full' )}">{$language.name|wash}</a>
                        <a href={concat( 'content/edit/', $node.object.id, '/f/', $language.locale )|ezurl} class="edit-icon" title="{'Edit in %language.name.'|i18n( 'design/admin/node/view/full',, hash( '%language.name', $language.locale_object.intl_language_name ) )|wash}"><i class="fa fa-edit"></i></a>
                    </li>
                {/if}
            {/foreach}
            {if gt( $can_create_languages|count, 0 )}
                <li role="separator" class="divider"></li>
                <li><button type="submit" name="EditButton">+ Add new translation</button></li>
            {/if}
        </ul> *}
        {undef $can_create_languages}
    </form>
    <ul class="node-view-switch">
        <li><a href={$node.url_alias|ezurl}><i class="fa fa-file-text-o"></i> Content</a></li>
        <li><a href=""><i class="fa fa-th-large"></i> Layout</a></li>
        <li class="active"><a href="#"><i class="fa fa-globe"></i> Preview</a></li>
    </ul>
</div>

<form method="post" action={concat( 'content/versionview/', $object.id, '/', $version.version, '/', $language, '/', $from_language )|ezurl}>

    <div class="rightmenu">
        <div id="rightmenu-design">

            {include uri="design:content/parts/object_information.tpl" object=$object manage_version_button=true()}

            <div class="versioninfo block">

                {* DESIGN: Header START *}<div class="box-header">

                    <h3>{'Version information'|i18n( 'design/admin/content/view/versionview' )}</h3>

                {* DESIGN: Header END *}</div>

                <div class="box-content">

                    {* Created *}
                    <p>
                    <label>{'Created'|i18n( 'design/admin/content/view/versionview' )}:</label>
                    {$version.created|l10n( shortdatetime )}<br />
                    {$version.creator.name|wash}
                    </p>

                    {* Last modified *}
                    <p>
                    <label>{'Last modified'|i18n( 'design/admin/content/view/versionview' )}:</label>
                    {$version.modified|l10n( shortdatetime )}<br />
                    {$version.creator.name|wash}
                    </p>

                    {* Status *}
                    <p>
                    <label>{'Status'|i18n( 'design/admin/content/view/versionview' )}:</label>
                    {$version.status|choose( 'Draft'|i18n( 'design/admin/content/view/versionview' ), 'Published / current'|i18n( 'design/admin/content/view/versionview' ), 'Pending'|i18n( 'design/admin/content/view/versionview' ), 'Archived'|i18n( 'design/admin/content/view/versionview' ), 'Rejected'|i18n( 'design/admin/content/view/versionview' ) )}
                    </p>

                    {* Version *}
                    <p>
                    <label>{'Version'|i18n( 'design/admin/content/view/versionview' )}:</label>
                    {$version.version}
                    </p>

                </div>
            </div>


            {* View control *}
            <div class="view-control block">
                <div class="box-header">
                    <h3>{'View control'|i18n( 'design/admin/content/view/versionview' )}</h3>
                </div>
                {* DESIGN: Content START *}
                <div class="box-content">

                    {* Translation *}
                    {if fetch( content, translation_list )|count|gt( 1 )}
                        <h6>{'Translation'|i18n( 'design/admin/content/view/versionview' )}:</h6>
                        <div class="block">
                        {if $translation_list|count|gt( 1 )}
                            {def $locale_object = false}
                            {foreach $translation_list as $locale_code}
                                {set $locale_object = $locale_code|locale()}
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="SelectedLanguage" value="{$locale_code}" {if eq( $locale_code, $object_languagecode )}checked="checked"{/if} />
                                        {if $locale_object.is_valid}
                                            <img src="{$locale_code|flag_icon}" width="18" height="12" alt="{$locale_code}" style="vertical-align: middle;" /> {$locale_object.intl_language_name|shorten( 16 )}
                                        {else}
                                            {'%1 (No locale information available)'|i18n( 'design/admin/content/view/versionview',, array( $locale_code ) )}
                                        {/if}
                                    </label>
                                </div>
                            {/foreach}
                        {else}
                            <div class="radio">
                                <label>                        
                                    <input type="radio" name="SelectedLanguage" value="{$version.language_list[0].language_code}" checked="checked" disabled="disabled" />
                                    {if $version.language_list[0].locale.is_valid}
                                        <img src="{$version.language_list[0].language_code|flag_icon}" width="18" height="12" alt="{$version.language_list[0].language_code}" style="vertical-align: middle;" /> {$version.language_list[0].locale.intl_language_name|shorten( 16 )}
                                    {else}
                                        {'%1 (No locale information available)'|i18n( 'design/admin/content/view/versionview',, array( $version.language_list[0].language_code ) )}
                                    {/if}
                                </label>
                            </div>
                        {/if}
                        </div>
                    {/if}

                    {* Location *}
                    {section show=$version.node_assignments|count|gt( 0 )}
                    <h6>{'Location'|i18n( 'design/admin/content/view/versionview' )}:</h6>
                    <div class="block">
                        {section show=$version.node_assignments|count|gt( 1 )}
                        {section var=Locations loop=$version.node_assignments}
                            <div class="radio">
                                <label>
                                    <input type="radio" name="SelectedPlacement" value="{$Locations.item.id}" {if eq( $Locations.item.id, $placement )}checked="checked"{/if} />&nbsp;{$Locations.item.parent_node_obj.name|wash}
                                </label>
                            </div>
                        {/section}
                        {section-else}
                            <div class="radio">
                                <label>
                                    <input type="radio" name="SelectedPlacement" value="{$version.node_assignments[0].id}" checked="checked" disabled="disabled" />&nbsp;{$version.node_assignments[0].parent_node_obj.name|wash}
                                </label>
                            </div>
                        {/section}
                    </div>
                    {/section}

                    {* Design *}
                    <h6>{'Siteaccess'|i18n( 'design/admin/content/view/versionview' )}:</h6>
                    <div class="block">
                        {if $site_access_locale_map|count|gt( 1 )}
                            {foreach $site_access_locale_map as $related_site_access => $related_site_access_locale}
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="SelectedSiteAccess" value="{$related_site_access}" {if eq( $related_site_access, $siteaccess )}checked="checked"{/if} />&nbsp;{$related_site_access|wash}
                                    </label>
                                </div>
                            {/foreach}
                        {else}
                            <div class="radio">
                                <label>
                                    <input type="radio" name="SelectedSiteAccess" value="{$site_designs[0]}" checked="checked" disabled="disabled" />&nbsp;{$site_designs[0]|wash}
                                </label>
                            </div>
                        {/if}
                        <input class="btn btn-default btn-sm" type="submit" name="ChangeSettingsButton" value="{'Update view'|i18n( 'design/admin/content/view/versionview' )}" title="{'View the version that is currently being displayed using the selected language, location and design.'|i18n( 'design/admin/content/view/versionview' )}" />
                    </div>


                    {* DESIGN: Content END *}
                </div>
            </div>
        </div>

    </div>

</form>



<div id="maincontent">

    <!-- Maincontent START -->

    <div class="box-header">

        <h1 class="context-title"><a href={concat( '/class/view/', $object.contentclass_id )|ezurl} onclick="ezpopmenu_showTopLevel( event, 'ClassMenu', ez_createAArray( new Array( '%classID%', {$object.contentclass_id},'%objectID%',{$object.id}, '%nodeID%', {if $node.node_id}{$node.node_id}{else}null{/if}, '%currentURL%','{$node.url|wash( javascript )}')), '{$object.content_class.name|wash(javascript)}', ['class-createnodefeed', 'class-removenodefeed' {if $node.node_id|is_null()}, 'class-history', 'url-alias'{/if}] ); return false;">{$object.content_class.identifier|class_icon( normal, $node.class_name )}</a>&nbsp;{$object.name|wash}&nbsp;[{$object.content_class.name|wash}]</h1>


        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}
    </div>

    {* DESIGN: Content START *}
    <div class="preview-page">

        {* Translation mismatch notice *}
        {if $object_languagecode|eq( $site_access_locale_map[$siteaccess] )|not}
        <div class="alert alert-info" role="alert">
            <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Translation mismatch'|i18n( 'design/admin/content/view/versionview' )}</h2>
            <p>{'Your selected translation does not match the language of your selected siteaccess. This may lead to unexpected results in the preview, however it may also be what you intended.'|i18n( 'design/admin/content/view/versionview' )}</p>
        </div>
        {/if}

        {* Content preview in content window. *}
        <div class="mainobject-window">

            <iframe src={concat("content/versionview/",$object.id,"/",$view_version.version,"/",$language, "/site_access/", $siteaccess )|ezurl} id="preview-frame">
                Your browser does not support iframes. Please see this <a href={concat("content/versionview/",$object.id,"/",$view_version.version,"/",$language, "/site_access/", $siteaccess)|ezurl}>link</a> instead.
            </iframe>

        </div>


        {* DESIGN: Content END *}

        {* Buttonbar for content window. *}
        {* <div class="controlbar">
            <form method="post" action={concat( 'content/versionview/', $object.id, '/', $version.version, '/', $language, '/', $from_language )|ezurl}>
                {if or( and( eq( $version.status, 0 ), $is_creator, $object.can_edit ),
                                  and( eq( $object.status, 2 ), $object.can_edit ) )}
                    <input class="btn btn-primary" type="submit" name="EditButton" value="{'Back to edit'|i18n( 'design/admin/content/view/versionview' )}" title="{'Edit the draft that is being displayed.'|i18n( 'design/admin/content/view/versionview' )}" />
                    <input class="btn btn-default" type="submit" name="PreviewPublishButton" value="{'Publish'|i18n( 'design/admin/content/view/versionview' )}" title="{'Publish the draft that is being displayed.'|i18n( 'design/admin/content/view/versionview' )}" />
                {else}
                    {if is_set( $redirect_uri )}
                        <input class="text" type="hidden" name="RedirectURI" value="{$redirect_uri}" />
                    {/if}
                    <input class="btn btn-primary" type="submit" name="BackButton" value="{'Back'|i18n( 'design/admin/content/view/versionview' )}" />
                {/if}

            </form>
        </div> *}

    </div>
    
</div>
