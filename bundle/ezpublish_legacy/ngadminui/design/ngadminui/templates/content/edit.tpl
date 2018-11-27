<form name="editform" id="editform" enctype="multipart/form-data" method="post" action={concat( '/content/edit/', $object.id, '/', $edit_version, '/', $edit_language|not|choose( concat( $edit_language, '/' ), '/' ), $is_translating_content|not|choose( concat( $from_language, '/' ), '' ) )|ezurl}>

{* This is to force form to use publish action instead of 'Manage version' button on enter key press in input and textarea elements. *}
    <input class="btn btn-primary hide" type="submit" id="ezedit-default-button" name="PublishButton" value="{'Send for publishing'|i18n( 'design/admin/content/edit' )}" />

    {* Current gui locale, to be used for class [attribute] name & description fields *}
    {def $content_language = ezini( 'RegionalSettings', 'Locale' )
         $edit_menu_collapsed = cond( ezpreference( 'admin_edit_menu_collapsed' ), 1, 0 )}

    <script type="text/javascript">
        {literal}

        YUI(YUI3_config).use('ezcollapsiblemenu', 'event', 'io-ez', function (Y) {

            Y.on('domready', function () {
                var rightmenu = new Y.eZ.CollapsibleMenu({
                    link: '#objectinfo-showhide',
                    content: false,
        {/literal}
                    collapsed: "{$edit_menu_collapsed}",
        {literal}
                    elements:[{
                        selector: '.rightmenu',
                        duration: 0.25,
                        fullStyle: {marginRight: '0'},
                        collapsedStyle: {marginRight: '-222px'},
                    },{
                        selector: '#maincontent',
                        duration: 0.25,
                        // workaround to http://yuilibrary.com/projects/yui3/ticket/2531641
                        // for IE, margin has to be set in px
                        fullStyle: {marginRight: (Y.one('.rightmenu').get('offsetWidth')) + 'px'},
                        collapsedStyle: {marginRight: '18px'}
                    }],
                    callback: function () {
                        Y.io.ez.setPreference('admin_edit_menu_collapsed', this.conf.collapsed);
                    }
                });
            });

        });

        {/literal}
    </script>
    <div class="rightmenu{if $edit_menu_collapsed} closed" style="margin-right:-222px;{/if}">
        <a id="objectinfo-showhide" onClick="$('.rightmenu').toggleClass('closed');" class="show-hide-control" title="{'Show / Hide rightmenu'|i18n( 'design/admin/pagelayout/rightmenu' )}" href="#"></a>
        <div id="rightmenu-design">

           {include uri='design:content/edit_menu.tpl'}

        </div>
    </div>


    <div id="maincontent"{if $edit_menu_collapsed} style="margin-right:18px"{/if} class="clearfix node-edit-container">
        <div class="path-edit-container"></div>
        <div id="controlbar-top" class="node-controlbar">
            <span class="pull-left translation small">
                {let language_index=0
                     from_language_index=0
                     translation_list=$content_version.translation_list}

                {section loop=$translation_list}
                  {if eq( $edit_language, $item.language_code )}
                    {set language_index=$:index}
                  {/if}
                {/section}

                {if $is_translating_content}

                    {let from_language_object=$object.languages[$from_language]}

                    {'Translating content from %from_lang to %to_lang'|i18n( 'design/admin/content/edit',, hash(
                        '%from_lang', concat( $from_language_object.name, '&nbsp;<img src="', $from_language_object.locale|flag_icon, '" width="18" height="12" style="vertical-align: middle;" alt="', $from_language_object.locale, '" />' ),
                        '%to_lang', concat( $translation_list[$language_index].locale.intl_language_name, '&nbsp;<img src="', $translation_list[$language_index].language_code|flag_icon, '" width="18" height="12" style="vertical-align: middle;" alt="', $translation_list[$language_index].language_code, '" />' ) ) )}

                    {/let}

                {else}

                    <img src="{$translation_list[$language_index].language_code|flag_icon}" width="18" height="12" style="vertical-align: middle;" alt="{$translation_list[$language_index].language_code}" />&nbsp;<span class="tt">{$translation_list[$language_index].locale.intl_language_name}</span>

                {/if}

                {/let}
            </span>
            <span class="box-bc pull-left"><span class="button-right"></span></span>
            {* DESIGN: Control bar START *}
            <div class="btn-group">
                <input class="btn btn-default" type="submit" name="StoreButton" value="{'Store draft'|i18n( 'design/admin/content/edit' )}" title="{'Store the contents of the draft that is being edited and continue editing. Use this button to periodically save your work while editing.'|i18n( 'design/admin/content/edit' )}" />
                <input class="btn btn-default" type="submit" name="StoreExitButton" value="{'Store draft and exit'|i18n( 'design/admin/content/edit' )}" title="{'Store the draft that is being edited and exit from edit mode. Use when you need to exit your work and return later to continue.'|i18n( 'design/admin/content/edit' )}" />
                <input class="btn btn-default" type="submit" name="DiscardButton" value="{'Discard draft'|i18n( 'design/admin/content/edit' )}" onclick="return confirmDiscard( '{'Are you sure you want to discard the draft?'|i18n( 'design/admin/content/edit' )|wash(javascript)}' );" title="{'Discard the draft that is being edited. This will also remove the translations that belong to the draft (if any).'|i18n( 'design/admin/content/edit' ) }" />
            </div>
            <input class="btn btn-primary" type="submit" name="PublishButton" value="{'Send for publishing'|i18n( 'design/admin/content/edit' )}" title="{'Publish the contents of the draft that is being edited. The draft will become the published version of the object.'|i18n( 'design/admin/content/edit' )}" />
            {* DESIGN: Control bar END *}
        </div>

        <!-- Maincontent START -->

        {include uri='design:content/edit_validation.tpl'}


        {* DESIGN: Header START *}

        {* DESIGN: Content START *}
        <div class="edit-tab-control">
            <h4>Sub menu</h4>
            <div class="edit-tab-triggers">
                {default $view_parameters            = array()
                         $attribute_categorys        = ezini( 'ClassAttributeSettings', 'CategoryList', 'content.ini' )
                         $attribute_default_category = ezini( 'ClassAttributeSettings', 'DefaultCategory', 'content.ini' )}

                {foreach $content_attributes_grouped_data_map as $attribute_group => $content_attributes_grouped}
                    <a href="#" data-field-group="{$attribute_group}">{$attribute_categorys[$attribute_group]}</a>
                {/foreach}

                {/default}
            </div>
        </div>
        <div class="box-content">

            {if $is_translating_content}
            <div class="content-translation">
            {/if}

                {foreach ezini( 'EditSettings', 'AdditionalTemplates', 'content.ini' ) as $additional_tpl}
                    {include uri=concat( 'design:', $additional_tpl )}
                {/foreach}

                <div class="context-attributes edit-tabs panel">
                    {include uri='design:content/edit_attribute.tpl' view_parameters=$view_parameters}
                </div>

            {if $is_translating_content}
            </div>
            {/if}

        {* DESIGN: Content END *}
            <div class="panel">
                <div class="node-controlbar">
                {* DESIGN: Control bar START *}
                    {if ezpreference( 'admin_edit_show_re_edit' )}
                        <input type="checkbox" name="BackToEdit" />{'Back to edit'|i18n( 'design/admin/content/edit' )}
                    {/if}
                    <div class="btn-group">
                        <input class="btn btn-default" type="submit" name="StoreButton" value="{'Store draft'|i18n( 'design/admin/content/edit' )}" title="{'Store the contents of the draft that is being edited and continue editing. Use this button to periodically save your work while editing.'|i18n( 'design/admin/content/edit' )}" />
                        <input class="btn btn-default" type="submit" name="StoreExitButton" value="{'Store draft and exit'|i18n( 'design/admin/content/edit' )}" title="{'Store the draft that is being edited and exit from edit mode. Use when you need to exit your work and return later to continue.'|i18n( 'design/admin/content/edit' )}" />
                        <input class="btn btn-default" type="submit" name="DiscardButton" value="{'Discard draft'|i18n( 'design/admin/content/edit' )}" onclick="return confirmDiscard( '{'Are you sure you want to discard the draft?'|i18n( 'design/admin/content/edit' )|wash(javascript)}' );" title="{'Discard the draft that is being edited. This will also remove the translations that belong to the draft (if any).'|i18n( 'design/admin/content/edit' ) }" />
                    </div>
                    <input class="btn btn-primary" type="submit" name="PublishButton" value="{'Send for publishing'|i18n( 'design/admin/content/edit' )}" title="{'Publish the contents of the draft that is being edited. The draft will become the published version of the object.'|i18n( 'design/admin/content/edit' )}" />
                    <input type="hidden" name="DiscardConfirm" value="1" />
                {* DESIGN: Control bar END *}
                </div>
            </div>
        </div>

        {* Locations window. *}
        {if or( ezpreference( 'admin_edit_show_locations' ),
                          count( $invalid_node_assignment_list )|gt(0) )}
            {* We never allow changes to node assignments if the object has been published/archived.
               This is controlled by the $location_ui_enabled variable. *}
            {include uri='design:content/edit_locations.tpl'}
        {else}
            {* This disables all node assignment checking in content/edit *}
            <input type="hidden" name="UseNodeAssigments" value="0" />
        {/if}


            <!-- Maincontent END -->

        <div class="break"></div>

    </div>
</form>




{literal}
<script type="text/javascript">
function confirmDiscard( question )
{
    // Disable/bypass the reload-based (plain HTML) confirmation interface.
    document.editform.DiscardConfirm.value = "0";

    // Ask user if she really wants do it, return this to the handler.
    return confirm( question );

}

$(document).ready(function(){
    $('#editform').on('keypress keydown keyup', ':input:not(textarea)', function(e){
        if(e.keyCode == 13) {
            e.preventDefault();
        }
    });

});

</script>
{/literal}
