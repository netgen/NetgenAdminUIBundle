{if is_set( $browse.content.name_list )}
    {def $content_object_name = $browse.content.name_list|implode(', ')}
{else}
    {def $content_object=fetch( 'content', 'object', hash( 'object_id', $browse.content.object_id ) )
        $content_object_name = $content_object.name}
{/if}

{* DESIGN: Header START *}
<div class="box-header">

    <h1 class="context-title">{'Choose a new location for <%object_name>'|i18n( 'design/admin/content/browse_move_node',, hash( '%object_name', $content_object_name ) )|wash}</h1>

    {* DESIGN: Mainline *}<div class="header-mainline"></div>

    {* DESIGN: Header END *}
</div>

{* DESIGN: Content START *}
<div class="panel">
    <p>{'Choose a new location for <%object_name> using the radio buttons then click "Select".'|i18n( 'design/admin/content/browse_move_node',, hash( '%object_name', $content_object_name ) )|wash}</p>
    <p>{'Navigate using the available tabs (above), the tree menu (left) and the content list (middle).'|i18n( 'design/admin/content/browse_move_node' )}</p>
</div>

{* DESIGN: Content END *}

{undef}
