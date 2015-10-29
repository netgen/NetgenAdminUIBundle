{* DESIGN: Header START *}
<div class="title-wrapper">
    <span class="title-edit">{$group.name|wash|classgroup_icon( 'normal', $group.name|wash )}</span>
    <h1 class="context-title">{'%group_name [Class group]'|i18n( 'design/admin/class/classlist',, hash( '%group_name', $group.name ) )|wash}
        <div class="clearfix">
            <span class="pull-left small">{'Last modified'|i18n( 'design/admin/class/classlist' )}: {$group.modified|l10n( shortdatetime )}, {$group_modifier.name|wash}</span>
            <span class="pull-right translation small">{def $languages=fetch( 'content', 'prioritized_languages' )}</span>
        </div>
    </h1>
    {* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}
</div>

{* DESIGN: Content START *}
<div class="panel">

    <div class="context-attributes">

        <div class="block">
            <h6>{'ID'|i18n( 'design/admin/class/classlist' )}:</h6>
            {$group.id}
        </div>

        <div class="block">
            <h6>{'Name'|i18n( 'design/admin/class/classlist' )}:</h6>
            {$group.name|wash}
        </div>

    </div>

{* DESIGN: Content END *}
    {* DESIGN: Control bar START *}
    <form action={'class/grouplist'|ezurl} method="post" name="GroupList" class="btn-toolbar">
        <input type="hidden" name="DeleteIDArray[]" value="{$group.id}" />
        <input type="hidden" name="EditGroupID" value="{$group.id}" />
        <div class="btn-group">
            <button class="btn btn-primary" type="submit" name="EditGroupButton" title="{'Edit this class group.'|i18n( 'design/admin/class/classlist' )}"><i class="fa fa-pencil-square-o"></i>&nbsp; {'Edit'|i18n( 'design/admin/class/classlist' )}</button>
            <button class="btn btn-default" type="submit" name="RemoveGroupButton" title="{'Remove this class group.'|i18n( 'design/admin/class/classlist' )}">{'Remove'|i18n( 'design/admin/class/classlist' )}</button>
        </div>
    </form>
    {* DESIGN: Control bar END *}

</div>


<div class="panel">
    <form action={concat( 'class/classlist/', $GroupID )|ezurl} method="post" name="ClassList">
        {* DESIGN: Header START *}
        <div class="button-left">
            <h2><a href={'/class/grouplist'|ezurl}><i class="fa fa-arrow-left" title="{'Back to class groups.'|i18n( 'design/admin/class/classlist' )}"></i></a>&nbsp;{'Classes inside %group_name (%class_count)'|i18n( 'design/admin/class/classlist',, hash( '%group_name', $group.name, '%class_count', $class_count ) )|wash}</h2>
        </div>

        <div class="button-right">
            {if gt( $languages|count, 1 )}
                <select class="form-control inline input-sm" name="ClassLanguageCode" title="{'Use this menu to select the language you to want use then click the "New class" button. The item will be created within the current location.'|i18n( 'design/admin/class/classlist' )|wash()}">
                    {foreach $languages as $language}
                        <option value="{$language.locale|wash()}">{$language.name|wash()}</option>
                    {/foreach}
                </select>
            {else}
                <input type="hidden" name="ClassLanguageCode" value="{$languages[0].locale|wash()}" />
            {/if}
            <input class="btn btn-default btn-sm" type="submit" name="NewButton" id="NewButtonTop" value="{'New class'|i18n( 'design/admin/class/classlist' )}" title="{'Create a new class within the %class_group_name class group.'|i18n( 'design/admin/class/classlist',, hash( '%class_group_name', $group.name ) )|wash}" />
        </div>

        <div class="break"></div>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        {section show=$class_count}
        <table class="list" cellspacing="0" summary="{'List of classes inside %group_name class group (%class_count)'|i18n( 'design/admin/class/classlist',, hash( '%group_name', $group.name, '%class_count', $class_count ) )|wash}">
            <tr>
                <th class="tight"><i class="fa fa-check-square-o" title="{'Invert selection.'|i18n( 'design/admin/class/classlist' )}" onclick="ezjs_toggleCheckboxes( document.ClassList, 'DeleteIDArray[]' ); return false;"></i></th>
                <th>{'Name'|i18n('design/admin/class/classlist')}</th>
                <th class="tight">{'ID'|i18n('design/admin/class/classlist')}</th>
                <th>{'Identifier'|i18n('design/admin/class/classlist')}</th>
                <th>{'Modifier'|i18n('design/admin/class/classlist')}</th>
                <th>{'Modified'|i18n('design/admin/class/classlist')}</th>
                <th>{'Objects'|i18n('design/admin/class/classlist')}</th>
                <th class="tight">&nbsp;</th>
                <th class="tight">&nbsp;</th>
            </tr>

            {section var=Classes loop=$groupclasses sequence=array( bglight, bgdark )}
            <tr class="{$Classes.sequence}">
                <td><input type="checkbox" name="DeleteIDArray[]" value="{$Classes.item.id}" title="{'Select class for removal.'|i18n( 'design/admin/class/classlist' )}" /></td>
                <td>{$Classes.item.identifier|class_icon( small, $Classes.item.name|wash )}&nbsp;<a href={concat( "/class/view/", $Classes.item.id )|ezurl}>{$Classes.item.name|wash}</a></td>
                <td class="number" align="right">{$Classes.item.id}</td>
                <td>{$Classes.item.identifier|wash}</td>
                <td>{content_view_gui view=text_linked content_object=$Classes.item.modifier.contentobject}</td>
                <td>{$Classes.item.modified|l10n( shortdatetime )}</td>
                <td class="number" align="right">{$Classes.item.object_count}</td>
                <td><a href={concat( 'class/copy/', $Classes.item.id )|ezurl} title="{'Create a copy of the %class_name class.'|i18n( 'design/admin/class/classlist',, hash( '%class_name', $Classes.item.name ) )|wash}"><i class="fa fa-clone" title="Copy"></i></a></td>
                <td><a href={concat( 'class/edit/', $Classes.item.id, '/(language)/', $Classes.item.top_priority_language_locale )|ezurl} title="{'Edit the %class_name class.'|i18n( 'design/admin/class/classlist',, hash( '%class_name', $Classes.item.name ) )|wash}"><i class="fa fa-pencil-square-o" title="Edit"></i></a></td>
            </tr>
            {/section}
        </table>
        {section-else}
        <div class="block">
            <p>{'There are no classes in this group.'|i18n( 'design/admin/class/classlist' )}</p>
        </div>
        {/section}

        {* DESIGN: Content END *}

        <div class="controlbar clearfix">
        {* DESIGN: Control bar START *}
            <div class="button-left">
                <input type="hidden" name = "CurrentGroupID" value="{$GroupID}" />
                <input type="hidden" name = "CurrentGroupName" value="{$group.name|wash}" />

                {if $class_count}
                <input class="btn btn-default btn-sm" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/class/classlist' )}" title="{'Remove selected classes from the %class_group_name class group.'|i18n( 'design/admin/class/classlist',, hash( '%class_group_name', $group.name ) )|wash}" />
                {else}
                <input class="btn btn-default btn-sm" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/class/classlist' )}" disabled="disabled" />
                {/if}
            </div>

            <div class="button-right">
                {if gt( $languages|count, 1 )}
                    <select class="form-control inline input-sm" name="ClassLanguageCode" id="ClassLanguageCodeBottom" title="{'Use this menu to select the language you to want use then click the "New class" button. The item will be created within the current location.'|i18n( 'design/admin/class/classlist' )|wash()}">
                        {foreach $languages as $language}
                            <option value="{$language.locale|wash()}">{$language.name|wash()}</option>
                        {/foreach}
                    </select>
                {else}
                    <input type="hidden" name="ClassLanguageCode" value="{$languages[0].locale|wash()}" />
                {/if}
                <input class="btn btn-default btn-sm" type="submit" name="NewButton" value="{'New class'|i18n( 'design/admin/class/classlist' )}" title="{'Create a new class within the %class_group_name class group.'|i18n( 'design/admin/class/classlist',, hash( '%class_group_name', $group.name ) )|wash}" />
            </div>

        {* DESIGN: Control bar END *}
        </div>
        {undef $languages}
    </form>
</div>
{literal}
<script type="text/javascript">
jQuery(function( $ )//called on document.ready
{
    // Disable bottom datatype dropp down when using new button in top
    jQuery('#NewButtonTop').click(function()
    {
        jQuery('#ClassLanguageCodeBottom').attr('disabled', true);
    });
});
</script>
{/literal}

