{if eq( $ui_context, 'edit' )}
{* DESIGN: Header START *}

<h4 class="leftmenu-hl">{'Role information'|i18n( 'design/admin/parts/user/menu' )}</h4>

{* DESIGN: Header END *}

{* DESIGN: Content START *}

<p>
    <label>{'Name'|i18n( 'design/admin/parts/user/menu' )}:</label>
    {$role.name|wash}
</p>

<p>
    <label>{'ID'|i18n( 'design/admin/parts/user/menu' )}:</label>
    {$role.id|wash}
</p>

{* DESIGN: Content END *}

{else}

<div id="content-tree">
    {* DESIGN: Header START *}
    <h4 class="leftmenu-hl">{'User accounts'|i18n( 'design/admin/parts/user/menu' )}</h4>
    {* DESIGN: Header END *}

    {* DESIGN: Content START *}

    {* Treemenu. *}
    <div id="contentstructure">
        {include uri='design:contentstructuremenu/content_structure_menu_dynamic.tpl' custom_root_node_id=ezini( 'NodeSettings', 'UserRootNode', 'content.ini')}
    </div>

    {* trashcan. *}
    {if ne( $ui_context, 'browse')}
    <div id="trash">
        <a class="image-text" href={concat( '/content/trash/', ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )|ezurl} title="{'View and manage the contents of the trash bin.'|i18n( 'design/admin/parts/user/menu' )}"><i class="fa fa-trash-o"></i>&nbsp;<span>{'Trash'|i18n( 'design/admin/parts/user/menu' )}</span></a>
    </div>
    {/if}

    {* DESIGN: Content END *}
</div>

{* Roles & policies *}
{* See parts/ini_menu.tpl and menu.ini for more info, or parts/setup/menu.tpl for full example *}
{include uri='design:parts/ini_menu.tpl' ini_section='Leftmenu_user' i18n_hash=hash(
    'access_controll',    'Access control'|i18n( 'design/admin/parts/user/menu' ),
    'roles_and_policies', 'Roles and policies'|i18n( 'design/admin/parts/user/menu' ),
    'unactivated',        'Unactivated users'|i18n( 'design/admin/parts/user/menu' ),
)}

{/if}{* if ne( $ui_context, 'edit' ) *}
