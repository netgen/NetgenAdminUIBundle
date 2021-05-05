{set-block variable=$top_menu}
    <div class="node-top-switch">
        <ul class="node-view-switch">
            <li class="active">
                <a href=""><i class="fa fa-file-text-o"></i> {'Content'|i18n( 'design/admin/node/view/full' )}</a>
                {if fetch( content, translation_list )|count|gt(1)}
                    <form class="dropdown language-switch" method="post" action={'content/action'|ezurl}>
                        {def
                            $can_create_languages = $node.object.can_create_languages
                            $languages = fetch( 'content', 'prioritized_languages' )
                        }

                        <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
                        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                        <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
                        <input name="ContentObjectLanguageCode" value="" type="hidden" />

                        <button class="btn btn-default dropdown-toggle" type="button" id="languageDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                            <img src="{$node.object.current_language|flag_icon}" width="18" height="12" alt="{$node.object.current_language|wash}" style="vertical-align: middle;" /> <span class="tt">{$node.object.current_language_object.locale_object.intl_language_name}</span>
                            <span class="caret"></span>
                        </button>

                        {if or( $node.object.languages|count|gt( 1 ), $can_create_languages|count|gt( 0 ) )}
                            <ul class="dropdown-menu" aria-labelledby="languageDropdown">
                                {foreach $node.object.languages as $language}
                                    {if $language.locale|eq($node.object.current_language)|not}
                                        <li {if $node.object.can_edit_languages|contains($language)} class="with-edit" {/if}>
                                            <a href={concat( $node.url, '/(language)/', $language.locale )|ezurl} title="{'View translation.'|i18n( 'design/admin/node/view/full' )}">
                                                <img src="{$language.locale|flag_icon}" width="18" height="12" alt="{$language.locale|wash}" style="vertical-align: middle;" /> {$language.name|wash}
                                            </a>

                                            {if $node.object.can_edit_languages|contains($language)}
                                                <a href={concat( 'content/edit/', $node.object.id, '/f/', $language.locale )|ezurl} class="edit-icon" title="{'Edit in %language.name.'|i18n( 'design/admin/node/view/full',, hash( '%language.name', $language.locale_object.intl_language_name ) )|wash}"><i class="fa fa-edit"></i></a>
                                            {/if}
                                        </li>
                                    {/if}
                                {/foreach}
                                {if $can_create_languages|count|gt( 0 )}
                                    {if $node.object.can_edit_languages|count|gt( 1 )}
                                        <li role="separator" class="divider"></li>
                                    {/if}
                                    <li><button type="submit" name="EditButton">+ {'Add new translation'|i18n( 'design/admin/node/view/full' )}</button></li>
                                {/if}
                            </ul>
                        {/if}

                        {undef $can_create_languages}
                    </form>
                {/if}
            </li>
            <li>
                <form method="post" id="previewForm" action={concat( 'content/versionview/', $node.object.id, '/', $node.object.current_version, '/', $language.locale, '/', $from_language )|ezurl}>
                    <input type="hidden" id="SelectedLanguage" name="SelectedLanguage" value="{$node.object.current_language_object.locale_object.locale_code}" />
                    <input type="hidden" name="ChangeSettingsButton" value="{'Update view'|i18n( 'design/admin/content/view/versionview' )}" title="{'View the version that is currently being displayed using the selected language, location and design.'|i18n( 'design/admin/content/view/versionview' )}" />
                    <input type="hidden" name="ezxform_token" value="@$ezxFormToken@" />
                </form>
                <a type="submit" name="ChangeSettingsButton" title="{'View the version that is currently being displayed using the selected language, location and design.'|i18n( 'design/admin/content/view/versionview' )}" onclick="document.getElementById('previewForm').submit();"><i class="fa fa-globe"></i> {'Preview'|i18n( 'design/admin/node/view/full' )}</a>
            </li>
        </ul>
    </div>
{/set-block}

{set scope='global' persistent_variable=hash( 'top_menu', $top_menu ) }

<div class="content-view-full class-{$node.class_identifier}">
    {include uri='design:infocollection_validation.tpl'}

    <div class="content-navigation">

        {* Content window. *}


        {* DESIGN: Header START *}
        <div class="title-wrapper clearfix">
            {include uri='design:window_preview_toolbar.tpl'}

            {def $js_class_languages = $node.object.content_class.prioritized_languages_js_array|explode( '"' )|implode( '\'' )
                 $disable_another_language = cond( eq( 0, count( $node.object.content_class.can_create_languages ) ),"'edit-class-another-language'", '-1' )
                 $disabled_sub_menu = "['class-createnodefeed', 'class-removenodefeed']"
                 $hide_status = ''}

            {if $node.is_invisible}
                {set $hide_status = concat( '(', $node.hidden_status_string, ')' )}
            {/if}

            {* Check if user has rights and if there are any RSS/ATOM Feed exports for current node *}
            {if is_set( ezini( 'RSSSettings', 'DefaultFeedItemClasses', 'site.ini' )[ $node.class_identifier ] )}
                {def $create_rss_access = fetch( 'user', 'has_access_to', hash( 'module', 'rss', 'function', 'edit' ) )}
                {if $create_rss_access}
                    {if fetch( 'rss', 'has_export_by_node', hash( 'node_id', $node.node_id ) )}
                        {set $disabled_sub_menu = "'class-createnodefeed'"}
                    {else}
                        {set $disabled_sub_menu = "'class-removenodefeed'"}
                    {/if}
                {/if}
            {/if}
            {* span class="pull-right translation small">{$node.object.current_language_object.locale_object.intl_language_name}&nbsp;<img src="{$node.object.current_language|flag_icon}" width="18" height="12" alt="{$language_code|wash}" style="vertical-align: middle;" /></span> *}

            <a href={concat( '/class/view/', $node.object.contentclass_id )|ezurl} onclick="ezpopmenu_showTopLevel( event, 'ClassMenu', ez_createAArray( new Array( '%classID%', {$node.object.contentclass_id}, '%objectID%', {$node.contentobject_id}, '%nodeID%', {$node.node_id}, '%currentURL%', '{$node.url|wash( javascript )}', '%languages%', {$js_class_languages} ) ), '{$node.class_name|wash(javascript)}', {$disabled_sub_menu}, {$disable_another_language} ); return false;" class="title-edit">{$node.class_identifier|class_icon( normal, $node.class_name )}</a>

            <h1 class="context-title">
                {$node.name|wash}&nbsp;<span class="type">[{$node.class_name|wash}]</span> {$hide_status}

                {undef $js_class_languages $disable_another_language $disabled_sub_menu $hide_status}
            </h1>
        </div>
        {* DESIGN: Header END *}

        <div id="window-controls" class="tab-block">
            {include uri='design:window_controls.tpl'}
        </div>

    </div>
</div>
