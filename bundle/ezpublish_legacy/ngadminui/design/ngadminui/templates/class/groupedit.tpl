<form name="GroupEdit" method="post" action={concat( $module.functions.groupedit.uri, '/', $classgroup.id )|ezurl}>

    {* DESIGN: Header START *}<div class="title-wrapper">
        <span class="title-edit">{$classgroup.name|wash|classgroup_icon( normal, $classgroup.name|wash )}</span>
        <h1 class="context-title">{'Edit %group_name [Class group]'|i18n( 'design/admin/class/groupedit',, hash( '%group_name', $classgroup.name ) )|wash}</h1>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

    {* DESIGN: Header END *}
    </div>

    {* DESIGN: Content START *}
    <div class="panel">

        {* Name. *}
        <div class="row">
            <div class="form-group col-md-6 col-sm-12">
                <label for="classGroupName">{'Name'|i18n( 'design/admin/class/groupedit' )}:</label>
                <input class="form-control" id="classGroupName" name="Group_name" value="{$classgroup.name|wash}" />
            </div>
        </div>

        {* DESIGN: Content END *}

        <div class="controlbar">
            {* DESIGN: Control bar START *}
            <input class="btn btn-primary" type="submit" name="StoreButton" value="{'OK'|i18n( 'design/admin/class/groupedit' )}" />
            <input class="btn btn-default" type="submit" name="DiscardButton" value="{'Cancel'|i18n( 'design/admin/class/groupedit' )}" />
            {* DESIGN: Control bar END *}
        </div>

    </div>

</form>




{literal}
<script type="text/javascript">
jQuery(function( $ )//called on document.ready
{
    document.getElementById('classGroupName').select();
    document.getElementById('classGroupName').focus();
});
</script>
{/literal}
