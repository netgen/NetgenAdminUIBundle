<form name="role" method="post" action={concat( $module.functions.view.uri, '/', $role.id, '/')|ezurl}>

    <div class="context-block">

        {* DESIGN: Header START *}
        <div class="box-header">
            <h1 class="context-title">{'role'|icon( 'normal', 'Role'|i18n( 'design/admin/role/view' ) )}&nbsp;{'%role_name [Role]'|i18n( 'design/admin/role/view',, hash( '%role_name', $role.name ) )|wash}</h1>
            {* DESIGN: Mainline *}<div class="header-mainline"></div>
            {* DESIGN: Header END *}
        </div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            <div class="context-attributes">

                <div class="block">
                    <label>{'Name'|i18n( 'design/admin/role/view' )}:</label>
                    {$role.name|wash}
                </div>

                <div class="block">
                    <fieldset>
                        <legend>{'Policies (%policies_count)'|i18n( 'design/admin/role/view',, hash( '%policies_count', $policies|count ) )}</legend>
                        {section show=$policies}
                            <table class="list" cellspacing="0">
                                <tr>
                                    <th>{'Module'|i18n( 'design/admin/role/view' )}</th>
                                    <th>{'Function'|i18n( 'design/admin/role/view' )}</th>
                                    <th>{'Limitation'|i18n( 'design/admin/role/view' )}</th>
                                </tr>
                                {section var=Policies loop=$policies sequence=array( bglight, bgdark )}
                                    <tr class="{$Policies.sequence}">

                                        {* Module. *}
                                        <td>
                                            {if eq( $Policies.item.module_name, '*' )}
                                                <i>{'all modules'|i18n( 'design/admin/role/view' )} </i>
                                            {else}
                                                {$Policies.item.module_name|wash}
                                            {/if}
                                        </td>

                                        {* Function. *}
                                        <td>
                                            {if eq( $Policies.item.function_name, '*' )}
                                                <i>{'all functions'|i18n( 'design/admin/role/view' )} </i>
                                            {else}
                                                {$Policies.item.function_name|wash}
                                            {/if}
                                        </td>

                                        {* Limitations. *}
                                        <td>
                                            {section show=$Policies.item.limitations}
                                                {section var=Limitations loop=$Policies.item.limitations}
                                                    {$Limitations.item.identifier|wash}(
                                                    {foreach $Limitations.item.values_as_array_with_names as $limitation_value}
                                                        {if is_set( $limitation_value.node_data )}
                                                            <a href={concat( 'content/view/full/', $limitation_value.node_data.node_id )|ezurl} title="{'Path: \'/%path_string\', Class identifier: \'%class_identifier\''|i18n( 'design/admin/role/view',, hash( '%path_string', $limitation_value.node_data.path_identification_string, '%class_identifier', $limitation_value.node_data.class_identifier ) )|wash}">{$limitation_value.Name|wash}</a>
                                                        {else}
                                                            {$limitation_value.Name|wash}
                                                        {/if}
                                                        {delimiter}, {/delimiter}
                                                    {/foreach})
                                                    {delimiter}, {/delimiter}
                                                {/section}
                                            {section-else}
                                                <i>{'No limitations'|i18n( 'design/admin/role/view' )}</i>
                                            {/section}
                                        </td>
                                    </tr>
                                {/section}
                            </table>
                        {section-else}
                           <p>{'There are no policies set up for this role.'|i18n( 'design/admin/role/view' )}</p>
                        {/section}
                    </fieldset>
                </div>

            </div>

            {* DESIGN: Content END *}

            <div class="controlbar">
                {* DESIGN: Control bar START *}
                <div class="block">
                    <input class="btn btn-primary" type="submit" name="EditRoleButton" value="{'Edit'|i18n( 'design/admin/role/view' )}" title="{'Edit this role.'|i18n( 'design/admin/role/view' )}" />
                </div>
                {* DESIGN: Control bar END *}
            </div>

            <div class="context-block">
                <h2 class="context-title">{'Users and groups using the <%role_name> role (%users_count)'|i18n( 'design/admin/role/view',, hash('%role_name', $role.name, '%users_count', $user_array|count) )|wash}</h2>

                {section show=$user_array}
                    <table class="list" cellspacing="0">
                        <tr>
                            <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.role, 'IDArray[]' ); return false;"></i></th>
                            <th>{'User/group'|i18n( 'design/admin/role/view' )}</th>
                            <th>{'Limitation'|i18n( 'design/admin/role/view' )}</th>
                        </tr>
                        {section var=Users loop=$user_array sequence=array( bglight, bgdark )}
                            <tr class="{$Users.sequence}">

                                {* Remove. *}
                                <td><input type="checkbox" value="{$Users.item.user_role_id}" name="IDArray[]" title="{'Select user or user group for removal.'|i18n( 'design/admin/role/view' )}" /></td>

                                {* User/group icon + name. *}
                                <td>
                                    {$Users.item.user_object.content_class.identifier|class_icon( 'small', $Users.item.user_object.content_class.name|wash )}&nbsp;<a href={$Users.item.user_object.main_node.url_alias|ezurl}>{$Users.item.user_object.name|wash}</a>
                                </td>

                                {* Linked limitation (if any). *}
                                <td>
                                    {section show=$Users.item.limit_ident}
                                     {section show=$Users.item.limit_value|begins_with( '/' )}
                                          {let  limit_location_array=$Users.item.limit_value|explode( '/' )
                                                limit_location_pinpoint=$limit_location_array|count|sub(2)
                                                limit_node_id=$limit_location_array[$limit_location_pinpoint]
                                                limit_node=fetch('content','node', hash('node_id', $limit_node_id ))}
                                          <a href={concat( '/content/view/full/', $limit_node_id )|ezurl} title="{'Path: \'/%path_string\', Class identifier: \'%class_identifier\''|i18n( 'design/admin/role/view',, hash( '%path_string', $limit_node.path_identification_string, '%class_identifier', $limit_node.class_identifier ) )|wash}">{$Users.item.limit_ident|wash}:&nbsp;"{$limit_node.name|wash}"&nbsp;({$Users.item.limit_value|wash})</a>
                                          {/let}
                                      {section-else}
                                          {let limit_section=fetch( 'section', 'object', hash( 'section_id', $Users.item.limit_value ) )}
                                          <a href={concat( '/section/view/', $Users.item.limit_value )|ezurl}>{$Users.item.limit_ident|wash}:&nbsp;"{$limit_section.name|wash}"&nbsp;({$Users.item.limit_value|wash})</a>
                                          {/let}
                                      {/section}
                                    {section-else}
                                    <i>{'No limitations'|i18n( 'design/admin/role/view' )}</i>
                                    {/section}
                                </td>

                            </tr>
                        {/section}
                    </table>
                {section-else}
                    <div class="block">
                        <p>
                        {'This role is not assigned to any users or user groups.'|i18n( 'design/admin/role/view' )}
                        </p>
                    </div>
                {/section}

                <div class="controlbar">
                    {* DESIGN: Control bar START *}
                    <div class="block">

                        {if $user_array}
                            <input class="btn btn-default" type="submit" name="RemoveRoleAssignmentButton" value="{'Remove selected'|i18n( 'design/admin/role/view' )}" title="{'Remove selected users and/or user groups.'|i18n( 'design/admin/role/view' )}" />
                        {else}
                            <input class="btn btn-default" type="submit" name="RemoveRoleAssignmentButton" value="{'Remove selected'|i18n( 'design/admin/role/view' )}" disabled="disabled" />
                        {/if}

                        <input class="btn btn-default" type="submit" name="AssignRoleButton" value="{'Assign'|i18n( 'design/admin/role/view' )}" title="{'Assign the <%role_name> role to a user or a user group.'|i18n( 'design/admin/role/view',, hash( '%role_name', $role.name ) )|wash}" />
                    </div>
                    <div class="form-inline">
                        <div class="form-group">
                            <select class="form-control" name="AssignRoleType" title="{'Select limitation.'|i18n( 'design/admin/role/view' )}">
                                <option value="subtree">{'Subtree'|i18n( 'design/admin/role/view' )}</option>
                                <option value="section">{'Section'|i18n( 'design/admin/role/view' )}</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <input class="btn btn-default" type="submit" name="AssignRoleLimitedButton" value="{'Assign with limitation'|i18n( 'design/admin/role/view' )}" title="{'Assign the <%role_name> role with limitation (specified to the left) to a user or a user group.'|i18n( 'design/admin/role/view',, hash( '%role_name', $role.name ) )|wash}" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</form>
