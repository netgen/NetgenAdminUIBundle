{def $has_edit_views = ezini_hasvariable( 'EditSettings', 'AvailableViews', 'eztags.ini' )}

<div class="block"></div>

{* Subtree limit *}
<div class="block">
    <label>{'Limit by tags subtree'|i18n( 'extension/eztags/datatypes' )}:</label>
    <input id="eztags_parent_id_{$class_attribute.id}" type="hidden" name="ContentClass_eztags_subtree_limit_{$class_attribute.id}" value="{$class_attribute.data_int1}" />
    <span id="eztags_parent_keyword_{$class_attribute.id}">{eztags_parent_string( $class_attribute.data_int1 )|wash}</span>&nbsp;
    <input class="btn btn-default" type="button" name="SelectParentButton_{$class_attribute.id}" id="eztags-parent-selector-button-{$class_attribute.id}" value="{'Select subtree'|i18n( 'extension/eztags/datatypes' )}" />
</div>

{* Hide root subtree limit tag when editing object *}
<div class="checkbox">
    <label><input type="checkbox" name="ContentClass_eztags_hide_root_tag_{$class_attribute.id}"{cond( $class_attribute.data_int3|ne( 0 ), ' checked="checked"', '' )} /> {'Hide root subtree limit tag when editing object'|i18n( 'extension/eztags/datatypes' )}</label>
</div>

{if $has_edit_views|not}
{* Show dropdown instead of autocomplete *}
<div class="checkbox">
    <label><input type="checkbox" name="ContentClass_eztags_show_dropdown_{$class_attribute.id}"{cond( $class_attribute.data_int2|ne( 0 ), ' checked="checked"', '' )} /> {'Show dropdown instead of autocomplete'|i18n( 'extension/eztags/datatypes' )}</label>
</div>
{/if}

{* Maximum number of allowed tags *}
<div class="block form-inline">
    <label>{'Maximum number of allowed tags'|i18n( 'extension/eztags/datatypes' )}:</label> <input type="text" class="form-control" maxlength="5" size="5" name="ContentClass_eztags_max_tags_{$class_attribute.id}" value="{if $class_attribute.data_int4|gt( 0 )}{$class_attribute.data_int4}{else}0{/if}" />&nbsp;{'(0 = unlimited)'|i18n( 'extension/eztags/datatypes' )}
</div>

{if $has_edit_views}
{def $available_edit_views = ezini( 'EditSettings', 'AvailableViews', 'eztags.ini' )}

{* Edit view *}
<div class="block form-inline">
    <label for="ContentClass_eztags_edit_view_{$class_attribute.id}">{'Edit view'|i18n( 'extension/eztags/datatypes' )}:</label>
    <select class="form-control" id="ContentClass_eztags_edit_view_{$class_attribute.id}" name="ContentClass_eztags_edit_view_{$class_attribute.id}">
        {foreach $available_edit_views as $edit_view => $edit_view_name}
            <option value="{$edit_view|wash}" {if $edit_view|eq( $class_attribute.data_text1 )} selected="selected"{/if}>{$edit_view_name|wash|i18n( 'extension/eztags/datatypes' )}</option>
        {/foreach}
    </select>
</div>
{/if}

{run-once}
    {include uri='design:ezjsctemplate/modal_dialog.tpl'}
{/run-once}
