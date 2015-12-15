<div id="content-tree">
    {* DESIGN: Header START *}
    <h4 class="leftmenu-hl">{'Content structure'|i18n( 'design/admin/parts/content/menu' )}</h4>
    {* DESIGN: Header END *}
    {* DESIGN: Content START *}

    {* Treemenu. *}
    <div id="contentstructure">
        {include uri='design:contentstructuremenu/content_structure_menu_dynamic.tpl'}
    </div>

    {* Trashcan. *}
    {if ne( $ui_context, 'browse' )}
    <div id="trash">
        <a class="image-text" href={concat( '/content/trash/', ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )|ezurl} title="{'View and manage the contents of the trash bin.'|i18n( 'design/admin/parts/content/menu' )}"><i class="fa fa-trash-o"></i>&nbsp;<span>{'Trash'|i18n( 'design/admin/parts/content/menu' )}</span></a>
    </div>
    {/if}

    {* DESIGN: Content END *}
</div>

{* See parts/ini_menu.tpl and menu.ini for more info, or parts/setup/menu.tpl for full example *}
{include uri='design:parts/ini_menu.tpl' ini_section='Leftmenu_content'}
