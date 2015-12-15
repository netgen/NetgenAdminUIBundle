
{* DESIGN: Header START *}

<h2>{'Confirm class group removal'|i18n( 'design/admin/class/removegroup' )}</h2>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}

{* DESIGN: Content START *}
<div class="panel">
    {if $groups_info|count|eq(1)}
        <h2>{'Are you sure you want to remove the class group?'|i18n( 'design/admin/class/removegroup' )}</h2>
    {else}
        <h2>{'Are you sure you want to remove the class groups?'|i18n( 'design/admin/class/removegroup' )}</h2>
    {/if}

    {section var=ClassGroups loop=$groups_info}

    {section show=$ClassGroups.item.class_list}

    <p>{'The following classes will be removed from the %group_name class group'|i18n( 'design/admin/class/removegroup',, hash( '%group_name', $ClassGroups.item.group_name ) )|wash}:</p>

    <ul>
    {section var=Classes loop=$ClassGroups.item.class_list}
        <li>
            {$Classes.class_name}&nbsp;({'%objects objects will be removed'|i18n( 'design/admin/class/removegroup',, hash( '%objects', $Classes.item.object_count ) )|wash})
        </li>
    {/section}
    </ul>
    {/section}

    {/section}


    {* DESIGN: Content END *}
    <div class="controlbar">

        {* DESIGN: Control bar START *}
        <form action={concat( $module.functions.removegroup.uri )|ezurl} method="post" name="GroupRemove">
            <input class="btn btn-primary" type="submit" name="ConfirmButton" value="{'OK'|i18n( 'design/admin/class/removegroup' )}" />
            <input class="btn btn-default" type="submit" name="CancelButton" value="{'Cancel'|i18n( 'design/admin/class/removegroup' )}" />
        </form>

    </div>

    {* DESIGN: Control bar END *}

</div>
