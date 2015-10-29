
{* DESIGN: Header START *}<div class="box-header">

<h1 class="context-title">{'%group_name [Workflow group]'|i18n( 'design/admin/workflow/workflowlist',, hash( '%group_name', $group.name ) )|wash}</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div>

{* DESIGN: Content START *}
<div class="box-content panel">

    <div class="context-attributes">

        <div class="block">
            <label>{'ID'|i18n( 'design/admin/workflow/workflowlist' )}:</label>
            {$group.id}
            <br />
            <label>{'Name'|i18n( 'design/admin/workflow/workflowlist' )}:</label>
            {$group.name|wash}
        </div>

    </div>

    {* DESIGN: Content END *}

    <div class="controlbar">
        {* DESIGN: Control bar START *}
        <form name="GroupList" method="post" action={'workflow/grouplist'|ezurl}>
            <input type="hidden" name="ContentClass_id_checked[]" value="{$group.id}" />
            <input type="hidden" name="EditGroupID" value="{$group.id}" />
            <input class="btn btn-default" type="submit" name="EditGroupButton" value="{'Edit'|i18n( 'design/admin/workflow/workflowlist' )}" title="{'Edit this workflow group.'|i18n( 'design/admin/workflow/workflowlist' )}" />
            <input class="btn btn-default" type="submit" name="DeleteGroupButton" value="{'Remove'|i18n( 'design/admin/workflow/workflowlist' )}" title="{'Remove this workflow group.'|i18n( 'design/admin/workflow/workflowlist' )}" />
        </form>
        {* DESIGN: Control bar END *}
    </div>

</div>
<div class="panel">
    <form name="workflowlistform" method="post" action={concat( $module.functions.workflowlist.uri, '/', $group_id )|ezurl}>


        {* DESIGN: Header START *}

        <h2><a href={'/workflow/grouplist'|ezurl}><i class="fa fa-arrow-up"></i></a>&nbsp;{'Workflows (%workflow_count)'|i18n( 'design/admin/workflow/workflowlist',, hash( '%workflow_count', $workflow_list|count ) )}</h2>



        {* DESIGN: Header END *}

        {* DESIGN: Content START *}
        <div class="box-content">

            {section show=$workflow_list}
            <table class="list" cellspacing="0">
            <tr>
                <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.workflowlistform, 'Workflow_id_checked[]' ); return false;" title="{'Invert selection.'|i18n( 'design/admin/workflow/workflowlist' )}"></i></th>
                <th>{'Name'|i18n( 'design/admin/workflow/workflowlist' )}</th>
                <th class="tight">{'ID'|i18n( 'design/admin/workflow/workflowlist' )}</th>
                <th>{'Modifier'|i18n( 'design/admin/workflow/workflowlist' )}</th>
                <th>{'Modified'|i18n( 'design/admin/workflow/workflowlist' )}</th>
                <th class="tight">&nbsp;</th>
              </tr>
               {section var=Workflows loop=$workflow_list sequence=array( bglight, bgdark )}
                   <tr class="{$Workflows.sequence}">
                <td><input type="checkbox" name="Workflow_id_checked[]" value="{$Workflows.item.id}" title="{'Select workflow for removal.'|i18n( 'design/admin/workflow/workflowlist' )}" /></td>
                <td><a href={concat( $module.functions.view.uri, '/', $Workflows.item.id )|ezurl}>{$Workflows.item.name|wash}</a></td>
                <td class="number" align="right">{$Workflows.item.id}</td>
                <td>
                {let modifier=fetch( content, object, hash( object_id, $Workflows.item.modifier_id ) )}
                <a href={$modifier.main_node.url_alias|ezurl}>{$modifier.name|wash}</a>
                {/let}
                </td>
                <td>{$Workflows.item.modified|l10n( shortdatetime )}</td>
                <td><a href={concat( $module.functions.edit.uri, '/', $Workflows.item.id )|ezurl}><i class="fa fa-pencil-square-o" title="{'Edit the < %workflow_name > workflow.'|i18n( 'design/admin/workflow/workflowlist',, hash( '%workflow_name', $Workflows.item.name ) )|wash}"></i></a></td>
                </tr>
               {/section}
            </table>
            {section-else}
            <div class="block">
                <p>{'There are no workflows in this group.'|i18n( 'design/admin/workflow/workflowlist' )}</p>
            </div>
            {/section}


            {* DESIGN: Content END *}
        </div>

        {* Buttons. *}
        <div class="controlbar">
        {* DESIGN: Control bar START *}
            {if $workflow_list}
            <input class="btn btn-default" type="submit" name="DeleteButton" value="{'Remove selected'|i18n( 'design/admin/workflow/workflowlist' )}" title="{'Remove selected workflows.'|i18n( 'design/admin/workflow/workflowlist' )}" />
            {else}
            <input class="btn btn-default" type="submit" name="DeleteButton" value="{'Remove selected'|i18n( 'design/admin/workflow/workflowlist' )}" disabled="disabled" />
            {/if}

            <input class="btn btn-default" type="submit" name="NewWorkflowButton" value="{'New workflow'|i18n( 'design/admin/workflow/workflowlist' )}" title="{'Create a new workflow.'|i18n( 'design/admin/workflow/workflowlist' )}" />
            <input type="hidden" name="CurrentGroupID" value="{$group_id}" />
            <input type="hidden" name="CurrentGroupName" value="{$group_name}" />

        {* DESIGN: Control bar END *}
        </div>

    </form>
</div>
