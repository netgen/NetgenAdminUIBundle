{def $disableContainer='true'}
<div class="content-view-full class-{$node.class_identifier}">

    <div class="node-top-switch">
        <div class="dropdown language-switch">
            <button class="btn btn-default dropdown-toggle" type="button" id="languageDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <img src="{$node.object.current_language|flag_icon}" width="18" height="12" alt="{$language_code|wash}" style="vertical-align: middle;" /> {$node.object.current_language_object.locale_object.intl_language_name}
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="languageDropdown">
                <li><a href="#">Croatian (Hrvatska)</a></li>
                <li role="separator" class="divider"></li>
                <li><a href="#">+ Add new translation</a></li>
            </ul>
        </div>
        <ul class="node-view-switch">
            <li class="active"><a href=""><i class="fa fa-file-text-o"></i> Content</a></li>
            <li><a href=""><i class="fa fa-th-large"></i> Layout</a></li>
            <li><a href=""><i class="fa fa-globe"></i> Preview</a></li>
        </ul>
    </div>

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
                {$node.name|wash}&nbsp;[{$node.class_name|wash}]&nbsp;{$hide_status}

                {undef $js_class_languages $disable_another_language $disabled_sub_menu $hide_status}
            </h1>
        </div>
        {* DESIGN: Header END *}


        <div id="window-controls" class="tab-block">
            {include uri='design:window_controls.tpl'}
        </div>

    </div>
</div>