{set-block variable=$top_menu}
<div class="node-top-switch">
    <form class="dropdown language-switch" method="post" action={'content/action'|ezurl}>
        {def $can_create_languages = $node.object.can_create_languages
                    $languages            = fetch( 'content', 'prioritized_languages' )}
        <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
        <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
        <input name="ContentObjectLanguageCode" value="" type="hidden" />
        <button class="btn btn-default dropdown-toggle" type="button" id="languageDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            <img src="{$node.object.current_language|flag_icon}" width="18" height="12" alt="{$node.object.current_language|wash}" style="vertical-align: middle;" /> {$node.object.current_language_object.locale_object.intl_language_name}
            <span class="caret"></span>
        </button>

        <ul{if $translation_list|count|gt( 1 )} class="dropdown-menu" aria-labelledby="languageDropdown"{/if}>
            {def $locale_object = false}
            {foreach $translation_list as $locale_code}
                {set $locale_object = $locale_code|locale()}
                {if eq( $locale_code, $object_languagecode )|not}
                    <li>
                        <a href="" title="{'View translation.'|i18n( 'design/admin/node/view/full' )}">
                            <img src="{$locale_code|flag_icon}" width="18" height="12" alt="{$locale_code|wash}" style="vertical-align: middle;" /> {$locale_object.intl_language_name}
                        </a>
                    </li>
                {/if}
            {/foreach}
        </ul>
        {undef $can_create_languages}
    </form>
    <ul class="node-view-switch">
        <li><a href={$node.url_alias|ezurl}><i class="fa fa-file-text-o"></i> Content</a></li>
        <li><a href=""><i class="fa fa-th-large"></i> Layout</a></li>
        <li class="active"><a href="#"><i class="fa fa-globe"></i> Preview</a></li>
    </ul>
</div>
{/set-block}

{ezpagedata_set( 'top_menu', $top_menu )}

<!-- Maincontent START -->

<div class="box-header preview-box-header">

    {* <h1 class="context-title"><a href={concat( '/class/view/', $object.contentclass_id )|ezurl} onclick="ezpopmenu_showTopLevel( event, 'ClassMenu', ez_createAArray( new Array( '%classID%', {$object.contentclass_id},'%objectID%',{$object.id}, '%nodeID%', {if $node.node_id}{$node.node_id}{else}null{/if}, '%currentURL%','{$node.url|wash( javascript )}')), '{$object.content_class.name|wash(javascript)}', ['class-createnodefeed', 'class-removenodefeed' {if $node.node_id|is_null()}, 'class-history', 'url-alias'{/if}] ); return false;">{$object.content_class.identifier|class_icon( normal, $node.class_name )}</a>&nbsp;{$object.name|wash}&nbsp;[{$object.content_class.name|wash}]</h1> *}

    <div class="btn-toolbar" role="toolbar" id="preview-control">
        <div class="btn-group iframe-control" role="group">
            <button type="button" class="btn btn-default" data-width="320" data-height="480"><span class="icon-mobile-vertical"></span> 320px</button>
            <button type="button" class="btn btn-default" data-width="480" data-height="320"><span class="icon-mobile-horizontal"></span> 480px</button>
            <button type="button" class="btn btn-default" data-width="768" data-height="1024"><span class="icon-tablet-vertical"></span> 768px</button>
            <button type="button" class="btn btn-default" data-width="1024" data-height="768"><span class="icon-tablet-horizontal"></span> 1024px</button>
            <button type="button" class="btn btn-default" data-width="1200" data-height="768"><span class="icon-desktop"></span> 1200px</button>
        </div>
        <div class="btn-group" role="group">
            <form class="dropdown pull-left form-siteaccess" method="post" action={concat( 'content/versionview/', $object.id, '/', $version.version, '/', $language, '/', $from_language )|ezurl}>
                <select class="form-control" name="SelectedSiteAccess">
                    {if $site_access_locale_map|count|gt( 1 )}
                        {foreach $site_access_locale_map as $related_site_access => $related_site_access_locale}
                            <option id="{$related_site_access}" value="{$related_site_access}" {if eq( $related_site_access, $siteaccess )}selected{/if}>{$related_site_access|wash}</option>
                        {/foreach}
                    {else}
                        <option id="{$site_designs[0]}" value="{$site_designs[0]}">{$site_designs[0]|wash}</option>
                    {/if}
                </select>
                <input class="btn btn-default btn-sm" type="hidden" name="ChangeSettingsButton" />
            </form>
        </div>
    </div>
    <div class="path-edit-container"></div>

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
    <div class="container-design">
        <div class="preview-frame-container">

            <iframe src={concat("content/versionview/",$object.id,"/",$view_version.version,"/",$language, "/site_access/", $siteaccess )|ezurl} id="preview-frame">
                Your browser does not support iframes. Please see this <a href={concat("content/versionview/",$object.id,"/",$view_version.version,"/",$language, "/site_access/", $siteaccess)|ezurl}>link</a> instead.
            </iframe>

        </div>
    </div>

    {* DESIGN: Content END *}
</div>

{literal}
<script type="text/javascript">
    $(document).ready(function(){
        $('.inner-cell').addClass('contentPreview');

        /* preview iframe resizing */
        (function(){
            var frame = $('#preview-frame'),
                container = $('.preview-frame-container'),
                containerDesign = $('.container-design'),
                initialW = localStorage.getItem('previewIframeW'),
                initialH = localStorage.getItem('previewIframeH'),
                control = $('.iframe-control'),
                sizes = [],
                screenW = $(document).width(),
                contHeight = function(){
                    var fContainer = $('.preview-page'),
                        fContainerH = $(document).height() - fContainer.offset().top - (parseInt(fContainer.css('padding-top'), 10) * 2) - 20;
                    return fContainerH;
                },
                sizing = function(w, h){
                    container.width(w).height(h);
                    containerDesign.width(w).height(h);
                    frame.width(w).height(h);
                }
                switching = function(el, w, h){
                    containerDesign.attr('class', 'container-design');
                    switch (w) {
                        case '320':
                            containerDesign.addClass('mobile-vertical');
                            break;
                        case '480':
                            containerDesign.addClass('mobile-horizontal');
                            break;
                        case '768':
                            containerDesign.addClass('tablet-vertical');
                            break;
                        case '1024':
                            containerDesign.addClass('tablet-horizontal');
                            break;
                        default:
                            containerDesign.addClass('desktop');
                            h = contHeight();
                    }
                    el.addClass('active').siblings().removeClass('active');
                    sizing(w, h);
                };
            control.children('.btn').each(function(){
                sizes.push($(this).attr('data-width'));
            });
            if(initialW == undefined) {
                var i = Math.max.apply(Math, sizes.filter(function(x){return x <= screenW})),
                    initialTrigger = $('.btn[data-width=' + i + ']');
                initialW = initialTrigger.attr('data-width');
                initialH = initialTrigger.attr('data-height');
            } else {
                var initialTrigger = $('.btn[data-width=' + initialW + ']');
            }
            switching(initialTrigger, initialW, initialH);
            control.on('click', '.btn', function(){
                var trigger = $(this),
                    frameW = trigger.attr('data-width'),
                    frameH = trigger.attr('data-height');
                localStorage.setItem('previewIframeW', frameW);
                localStorage.setItem('previewIframeH', frameH);
                switching(trigger, frameW, frameH);
            });
            $(window).resize(function(){
                if(containerDesign.hasClass('desktop')) {
                    var contW = containerDesign.width();
                    sizing(contW, contHeight());
                }
            });
        })();

    });
</script>
{/literal}
