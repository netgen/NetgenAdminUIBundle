<form action={concat( $module.functions.groupedit.uri, '/', $workflow_group.id )|ezurl} method="post" name="WorkflowGroupEdit">

    <div class="context-block">

        {* DESIGN: Header START *}<div class="box-header">

        <h1 class="context-title">{'Edit < %group_name > [Workflow group]'|i18n( 'design/admin/workflow/groupedit',, hash( '%group_name', $workflow_group.name ) )|wash}</h1>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}</div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            <div class="context-attributes">

                <div class="block">
                    <label>{'Name'|i18n( 'design/admin/workflow/groupedit' )}:</label>
                    <input class="form-control" id="workflowGroupName" type="text" name="WorkflowGroup_name" value="{$workflow_group.name|wash}" />
                </div>

            </div>

            {* DESIGN: Content END *}


            {* Buttons. *}
            <div class="controlbar">
                {* DESIGN: Control bar START *}
                <input class="btn btn-primary" type="submit" name="StoreButton" value="{'OK'|i18n( 'design/admin/workflow/groupedit' )}" />
                <input class="btn btn-default" type="submit" name="DiscardButton" value="{'Cancel'|i18n( 'design/admin/workflow/groupedit' )}" />
            </div>
            {* DESIGN: Control bar END *}
        </div>

    </div>

</form>

{literal}
<script type="text/javascript">
jQuery(function( $ )//called on document.ready
{
    document.getElementById('workflowGroupName').select();
    document.getElementById('workflowGroupName').focus();
});
</script>
{/literal}
