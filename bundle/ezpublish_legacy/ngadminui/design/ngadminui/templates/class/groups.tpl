{*-- Class group Start --*}
<div class="panel">
    <form action={concat( $module.functions.view.uri, '/', $class.id )|ezurl} method="post">
        {* DESIGN: Header START *}
        <h2>{'Member of class groups (%group_count)'|i18n( 'design/admin/class/view',, hash( '%group_count', $class.ingroup_list|count ) )}</h2>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        <table class="list" cellspacing="0">
            <tr>
                <th class="tight">&nbsp;</th>
                <th class="wide">{'Class group'|i18n( 'design/admin/class/view' )}</th>
            </tr>
            {section var=Groups loop=$class.ingroup_list sequence=array( bglight, bgdark )}
            <tr class="{$Groups.sequence}">
                <td class="tight"><input type="checkbox" name="group_id_checked[]" value="{$Groups.item.group_id}" title="{'Select class group for removal.'|i18n( 'design/admin/class/view' )}" /></td>
                <td class="wide">{$Groups.item.group_name|classgroup_icon( small, $Groups.item.group_name )}&nbsp;<a href={concat( '/class/classlist/', $Groups.item.group_id )|ezurl}>{$Groups.item.group_name|wash}</a></td>
            </tr>
            {/section}
        </table>
        {* DESIGN: Content END *}

        <div class="controlbar clearfix">
        {* DESIGN: Control bar START *}
            <div class="button-left">
                <input class="btn btn-default btn-sm" type="submit" name="RemoveGroupButton" value="{'Remove from selected'|i18n( 'design/admin/class/view' )}" title="{'Remove the %class_name class from the selected class groups.'|i18n( 'design/admin/class/view',, hash( '%class_name', $class.name ) )|wash}" />
            </div>
            <div class="button-right">
                {section show=sub( count( $class.group_list ),count( $class.ingroup_list ) )}
                    <select class="form-control inline input-sm" name="ContentClass_group" title="{'Select a group that the %class_name class should be added to.'|i18n( 'design/admin/class/view',, hash( '%class_name', $class.name ) )|wash}">
                    {section name=AllGroup loop=$class.group_list}
                        {if $class.ingroup_id_list|contains( $AllGroup:item.id )|not}
                            <option value="{$AllGroup:item.id}/{$AllGroup:item.name}">{$AllGroup:item.name|wash}</option>
                        {/if}
                    {/section}
                    </select>
                    <input class="btn btn-default btn-sm" type="submit" name="AddGroupButton" value="{'Add to class group'|i18n( 'design/admin/class/view' )}" title="{'Add the %class_name class to the group specified in the menu on the left.'|i18n( 'design/admin/class/view',, hash( '%class_name', $class.name ) )|wash}" />
                {section-else}
                    <select class="form-control inline input-sm" name="ContentClass_group" disabled="disabled" title="{'The %class_name class already exists within all class groups.'|i18n( 'design/admin/class/view',, hash( '%class_name', $class_name ) )|wash}">
                    <option value="-1">{'No group'|i18n( 'design/admin/class/view' )}</option>
                    </select>
                    <input class="btn btn-default btn-sm" type="submit" name="AddGroupButton" value="{'Add to class group'|i18n( 'design/admin/class/view' )}" disabled="disabled" title="{'The %class_name class already exists within all class groups.'|i18n( 'design/admin/class/view',, hash( '%class_name', $class_name ) )|wash}" />
                {/section}
            </div>
        {* DESIGN: Control bar END *}
        </div>
    </form>
</div>
{*-- Class group End --*}

