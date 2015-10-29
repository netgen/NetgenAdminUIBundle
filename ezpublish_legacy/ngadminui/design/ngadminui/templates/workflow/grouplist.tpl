<form name="grouplistform" action={concat($module.functions.grouplist.uri)|ezurl} method="post">

    <div class="context-block">

        {* DESIGN: Header START *}<div class="box-header">

            <h1 class="context-title">{'Workflow groups (%groups_count)'|i18n( 'design/admin/workflow/grouplist',, hash( '%groups_count', $groups|count ) )}</h1>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}</div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            {section show=$groups}
            <table class="list" cellspacing="0">
                <tr>
                    <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.grouplistform, 'ContentClass_id_checked[]' ); return false;" title="{'Invert selection.'|i18n( 'design/admin/workflow/grouplist' )}"></i></th>
                    <th>{'Name'|i18n( 'design/admin/workflow/grouplist' )}</th>
                    <th class="tight">&nbsp;</th>

                </tr>
                {section var=Groups loop=$groups sequence=array( bglight, bgdark )}
                <tr class="{$Groups.sequence}">
                    <td><input type="checkbox" name="ContentClass_id_checked[]" value="{$Groups.item.id}" title="{'Select workflow group for removal.'|i18n( 'design/admin/workflow/grouplist' )}" /></td>
                    <td><a href={concat( $module.functions.workflowlist.uri, '/', $Groups.item.id )|ezurl}>{$Groups.item.name|wash}</a></td>
                    <td><a href={concat( $module.functions.groupedit.uri, '/', $Groups.item.id )|ezurl}><i class="fa fa-pencil-square-o" title="{'Edit the < %workflow_group_name > workflow group.'|i18n( 'design/admin/workflow/grouplist',, hash( '%workflow_group_name', $Groups.item.name ) )|wash}"></i></a></td>
                </tr>
                {/section}
                {section-else}
                <div class="block">
                    <p>{'There are no workflow groups.'|i18n( 'design/admin/workflow/grouplist' )}</p>
                </div>
                {/section}

            </table>

            {* DESIGN: Content END *}

            {* Buttons. *}
            <div class="controlbar">
            {* DESIGN: Control bar START *}

                {if $groups}
                <input class="btn btn-default" type="submit" name="DeleteGroupButton" value="{'Remove selected'|i18n( 'design/admin/workflow/grouplist' )}"  title="{'Remove selected workflow groups.'|i18n( 'design/admin/workflow/grouplist' )}"  />
                {else}
                <input class="btn btn-default" type="submit" name="DeleteGroupButton" value="{'Remove selected'|i18n( 'design/admin/workflow/grouplist' )}" disabled="disabled" />
                {/if}
                <input class="btn btn-default" type="submit" name="NewGroupButton" value="{'New workflow group'|i18n( 'design/admin/workflow/grouplist' )}" title="{'Create a new workflow group.'|i18n( 'design/admin/workflow/grouplist' )}" />
            </div>
            {* DESIGN: Control bar END *}

        </div>

    </div>

</form>
