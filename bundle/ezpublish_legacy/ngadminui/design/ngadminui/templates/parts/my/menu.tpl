{* See parts/ini_menu.tpl and menu.ini for more info, or parts/setup/menu.tpl for full example *}
{include uri='design:parts/ini_menu.tpl' ini_section='Leftmenu_my' i18n_hash=hash(
    'my_account',         'My account'|i18n( 'design/admin/parts/my/menu' ),
    'my_drafts',          'My drafts'|i18n( 'design/admin/parts/my/menu' ),
    'my_pending',         'My pending items'|i18n( 'design/admin/parts/my/menu' ),
    'my_notifications',   'My notification settings'|i18n( 'design/admin/parts/my/menu' ),
    'my_bookmarks',       'My bookmarks'|i18n( 'design/admin/parts/my/menu' ),
    'collaboration',      'Collaboration'|i18n( 'design/admin/parts/my/menu' ),
    'change_password',    'Change password'|i18n( 'design/admin/parts/my/menu' ),
    'my_shopping_basket', 'My shopping basket'|i18n( 'design/admin/parts/my/menu' ),
    'my_wish_list',       'My wish list'|i18n( 'design/admin/parts/my/menu' ),
    'edit_profile',       'Edit profile'|i18n( 'design/admin/parts/my/menu' ),
    'dashboard',          'Dashboard'|i18n( 'design/admin/parts/my/menu' ),
)}


{def $custom_root_node = fetch( 'content', 'node', hash( 'node_id', 1 ) )}
{if $custom_root_node.can_read}
<div id="content-tree">
    {* DESIGN: Header START *}
    <h4 class="leftmenu-hl">{'Site structure'|i18n( 'design/admin/parts/content/menu' )}</h4>
    {* DESIGN: Header END *}

    {* DESIGN: Content START *}
    {* Treemenu. *}
    <div id="contentstructure">
        {include uri='design:contentstructuremenu/content_structure_menu_dynamic.tpl' custom_root_node=$custom_root_node menu_persistence=false() hide_node_list=array(ezini( 'NodeSettings', 'DesignRootNode', 'content.ini'), ezini( 'NodeSettings', 'SetupRootNode', 'content.ini'))}
    </div>

    {* DESIGN: Content END *}
</div>
{/if}