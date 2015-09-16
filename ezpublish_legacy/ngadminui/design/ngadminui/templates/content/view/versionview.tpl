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


<!-- Maincontent START -->

<div class="box-header">

    {* <h1 class="context-title"><a href={concat( '/class/view/', $object.contentclass_id )|ezurl} onclick="ezpopmenu_showTopLevel( event, 'ClassMenu', ez_createAArray( new Array( '%classID%', {$object.contentclass_id},'%objectID%',{$object.id}, '%nodeID%', {if $node.node_id}{$node.node_id}{else}null{/if}, '%currentURL%','{$node.url|wash( javascript )}')), '{$object.content_class.name|wash(javascript)}', ['class-createnodefeed', 'class-removenodefeed' {if $node.node_id|is_null()}, 'class-history', 'url-alias'{/if}] ); return false;">{$object.content_class.identifier|class_icon( normal, $node.class_name )}</a>&nbsp;{$object.name|wash}&nbsp;[{$object.content_class.name|wash}]</h1> *}

    <div class="btn-toolbar" role="toolbar" id="preview-control">
        <div class="btn-group iframe-control" role="group">
            <button type="button" class="btn btn-default" data-width="320" data-height="480">320px</button>
            <button type="button" class="btn btn-default" data-width="480" data-height="320">480px</button>
            <button type="button" class="btn btn-default" data-width="768" data-height="1024">768px</button>
            <button type="button" class="btn btn-default" data-width="1024" data-height="768">1024px</button>
            <button type="button" class="btn btn-default active" data-width="1200" data-height="768">1200px</button>
        </div>
        <div class="btn-group" role="group">
            <form class="dropdown pull-left form-siteaccess" method="post" action={concat( 'content/versionview/', $object.id, '/', $version.version, '/', $language, '/', $from_language )|ezurl}>
                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSiteaccess" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                    {'Siteaccess'|i18n( 'design/admin/content/view/versionview' )} <span class="caret"></span>
                </button>
                <div class="dropdown-menu dropdown-radio" aria-labelledby="dropdownSiteaccess">
                    {if $site_access_locale_map|count|gt( 1 )}
                        {foreach $site_access_locale_map as $related_site_access => $related_site_access_locale}
                            <div class="radio">
                                <input type="radio" name="SelectedSiteAccess" id="{$related_site_access}" value="{$related_site_access}" {if eq( $related_site_access, $siteaccess )}checked="checked"{/if} />
                                <label for="{$related_site_access}">{$related_site_access|wash}</label>
                            </div>
                        {/foreach}
                    {else}
                        <div class="radio">
                            <input type="radio" name="SelectedSiteAccess" id="{$site_designs[0]}" value="{$site_designs[0]}" checked="checked" disabled="disabled" />
                            <label for="{$site_designs[0]}">{$site_designs[0]|wash}</label>
                        </div>
                    {/if}
                </div>
            </form>
        </div>
    </div>

    <div class="header-mainline"></div>

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