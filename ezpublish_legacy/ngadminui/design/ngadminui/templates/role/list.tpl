<form name="roles" action={concat( $module.functions.list.uri, '/' )|ezurl} method="post" >

    {let number_of_items=min( ezpreference( 'admin_role_list_limit' ), 3)|choose( 10, 10, 25, 50 )}

    <div class="context-block">
        {* DESIGN: Header START *}
        <div class="box-header">
            <h1 class="context-title">{'Roles (%role_count)'|i18n( 'design/admin/role/list',, hash( '%role_count', $role_count ) )}</h1>
            {* DESIGN: Mainline *}<div class="header-mainline"></div>
            {* DESIGN: Header END *}
        </div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            {* Items per page selector. *}
            <div class="context-toolbar">
                <div class="button-left">
                    <p class="btn-group">
                        {switch match=$number_of_items}
                            {case match=25}
                                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_role_list_limit/1'|ezurl}>10</a>
                                <span  class="btn btn-default btn-sm active">25</span>
                                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_role_list_limit/3'|ezurl}>50</a>
                            {/case}

                            {case match=50}
                                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_role_list_limit/1'|ezurl}>10</a>
                                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_role_list_limit/2'|ezurl}>25</a>
                                <span class="btn btn-default btn-sm active">50</span>
                            {/case}

                            {case}
                                <span class="btn btn-default btn-sm active">10</span>
                                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_role_list_limit/2'|ezurl}>25</a>
                                <a class="btn btn-default btn-sm" href={'/user/preferences/set/admin_role_list_limit/3'|ezurl}>50</a>
                            {/case}

                        {/switch}
                    </p>
                </div>
                <div class="float-break"></div>
            </div>

            <table class="list" cellspacing="0">
                <tr>
                    <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.roles, 'DeleteIDArray[]' ); return false;"></i></th>
                    <th>{'Name'|i18n( 'design/admin/role/list' )}</th>
                    <th class="tight">&nbsp;</th>
                    <th class="tight">&nbsp;</th>
                    <th class="tight">&nbsp;</th>
                </tr>

                {section var=Roles loop=$roles sequence=array( bglight, bgdark )}
                    {let role_name=$Roles.item.name|wash}
                    <tr class="{$Roles.sequence}">
                    <td class="tight"><input type="checkbox" name="DeleteIDArray[]" value="{$Roles.item.id}" title="{'Select role for removal.'|i18n( 'design/admin/role/list' )}" /></td>
                    <td>{'role'|icon( 'small', 'Role'|i18n( 'design/admin/role/list' ) )}&nbsp;<a href={concat( '/role/view/', $Roles.item.id)|ezurl}>{$role_name|wash}</a></td>
                    <td><a href={concat( '/role/assign/', $Roles.item.id)|ezurl}><i class="fa fa-plus-square-o" title="{'Assign the <%role_name> role to a user or a user group.'|i18n( 'design/admin/role/list',, hash( '%role_name', $role_name ) )|wash}"></i></a></td>
                    <td><a href={concat( '/role/copy/', $Roles.item.id)|ezurl}><i class="fa fa-clone" title="{'Copy the <%role_name> role.'|i18n( 'design/admin/role/list',, hash( '%role_name', $role_name ) )|wash}"></i></a></td>
                    <td><a href={concat( '/role/edit/', $Roles.item.id)|ezurl}><i class="fa fa-pencil-square-o" title="{'Edit the <%role_name> role.'|i18n( 'design/admin/role/list',, hash( '%role_name', $role_name ) )|wash}"></i></a></td>
                    </tr>
                {/let}
                {/section}
            </table>

            <div class="context-toolbar">
                {include name=navigator
                         uri='design:navigator/google.tpl'
                         page_uri='/role/list'
                         item_count=$role_count
                         view_parameters=$view_parameters
                         item_limit=$limit}
                {/let}
            </div>

            {* DESIGN: Content END *}

            <div class="controlbar">
            {* DESIGN: Control bar START *}
                <div class="block">
                    <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/role/list' )}" title="{'Remove selected roles.'|i18n( 'design/admin/role/list' )}" />
                    <input class="btn btn-default" type="submit" name="NewButton" value="{'New role'|i18n( 'design/admin/role/list' )}" title="{'Create a new role.'|i18n( 'design/admin/role/list' )}" />
                </div>
            {* DESIGN: Control bar END *}
            </div>
        </div>

    </div>

</form>
