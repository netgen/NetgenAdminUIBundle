<form name="roleedit" method="post" action={concat( $module.functions.edit.uri, '/', $role.id, '/' )|ezurl}>

    <div class="context-block">

        {* DESIGN: Header START *}<div class="box-header">

            <h1 class="context-title">{'role'|icon( 'normal', 'Role'|i18n( 'design/admin/role/edit' ) )}&nbsp;{'Edit <%role_name> [Role]'|i18n( 'design/admin/role/edit',, hash( '%role_name', $role.name ) )|wash}</h1>

            {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}</div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            <div class="context-attributes">

                {* Name. *}
                <div class="block">
                    <label for="roleName">{'Name'|i18n( 'design/admin/role/edit' )}:</label>
                    <input class="form-control" id="roleName" type="text" name="NewName" value="{$role.name|wash}" />
                </div>

                {* Policies. *}
                <div class="block">
                    <fieldset>
                        <legend>{'Policies'|i18n( 'design/admin/role/edit' )}</legend>
                        {section show=$policies}
                            <table class="list" cellspacing="0">
                                <tr>
                                    <th class="tight"><i class="fa fa-check-square-o" title="{'Invert selection.'|i18n( 'design/admin/role/edit' )}" onclick="ezjs_toggleCheckboxes( document.roleedit, 'DeleteIDArray[]' ); return false;"></i></th>
                                    <th>{'Module'|i18n( 'design/admin/role/edit' )}</th>
                                    <th>{'Function'|i18n( 'design/admin/role/edit' )}</th>
                                    <th>{'Limitations'|i18n( 'design/admin/role/edit' )}</th>
                                    <th class="tight">&nbsp;</th>
                                </tr>
                                {section var=Policies loop=$policies sequence=array( bglight, bgdark )}
                                    <tr class="{$Policies.sequence}">

                                        {* Remove. *}
                                        <td>
                                            <input type="checkbox" name="DeleteIDArray[]" value="{$Policies.item.id}" title="{'Select policy for removal.'|i18n( 'design/admin/role/edit' )}" />
                                        </td>

                                        {* Module. *}
                                        <td>
                                            {if eq( $Policies.item.module_name, '*' )}
                                            <i>{'all modules'|i18n( 'design/admin/role/edit' )} </i>
                                            {else}
                                            {$Policies.item.module_name|wash}
                                            {/if}
                                        </td>

                                        {* Function. *}
                                        <td>
                                            {if eq( $Policies.item.function_name, '*' )}
                                            <i>{'all functions'|i18n( 'design/admin/role/edit' )} </i>
                                            {else}
                                            {$Policies.item.function_name|wash}
                                            {/if}
                                        </td>

                                        {* Limitations. *}
                                        <td>
                                            {section show=$Policies.item.limitations}
                                                {section var=Limitations loop=$Policies.item.limitations}
                                                    {$Limitations.item.identifier}(
                                                        {section var=LimitationValues loop=$Limitations.item.values_as_array_with_names}
                                                            {$LimitationValues.item.Name|wash}
                                                            {delimiter}, {/delimiter}
                                                        {/section})
                                                       {delimiter}, {/delimiter}
                                                {/section}
                                            {section-else}
                                                <i>{'No limitations'|i18n( 'design/admin/role/edit' )}</i>
                                            {/section}
                                        </td>

                                        {* Edit. *}
                                        <td>
                                            <a href={concat( 'role/policyedit/', $Policies.item.id )|ezurl}><i class="fa fa-pencil-square-o" title="{"Edit the policy's function limitations."|i18n( 'design/admin/role/edit' )}"></i></a>
                                        </td>
                                    </tr>
                                {/section}
                            </table>
                        {section-else}
                            <p>{'There are no policies set up for this role.'|i18n( 'design/admin/role/edit' )}</p>
                        {/section}

                        {* Policy manipulation buttons. *}
                        <div class="block">
                            {if $policies}
                                <input class="btn btn-default" type="submit" name="RemovePolicies" value="{'Remove selected'|i18n( 'design/admin/role/edit' )}" title="{'Remove selected policies.'|i18n( 'design/admin/role/edit' )}" />
                            {else}
                                <input class="btn btn-default" type="submit" name="RemovePolicies" value="{'Remove selected'|i18n( 'design/admin/role/edit' )}" disabled="disabled" />
                            {/if}

                            <input class="btn btn-default" type="submit" name="CreatePolicy" value="{'New policy'|i18n( 'design/admin/role/edit' )}" title="{'Create a new policy.'|i18n( 'design/admin/role/edit' )}" />
                        </div>
                    </fieldset>
                </div>

            </div>

            {* DESIGN: Content END *}

            {* Buttons. *}
            <div class="controlbar">
            {* DESIGN: Control bar START *}
                <input class="btn btn-primary" type="submit" name="Apply" value="{'Save'|i18n( 'design/admin/role/edit' )}" title="{'Save policy changes to this role'|i18n( 'design/admin/role/edit' )}" />
                <input class="btn btn-default" type="submit" name="Discard" value="{'Cancel'|i18n( 'design/admin/role/edit' )}" />
            </div>
            {* DESIGN: Control bar END *}
        </div>

    </div>

</form>

{literal}
<script type="text/javascript">
jQuery(function( $ )//called on document.ready
{
    document.getElementById('roleName').select();
    document.getElementById('roleName').focus();
});
</script>
{/literal}
