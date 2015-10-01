{let version=fetch( content, version, hash( object_id, $browse.content.object_id, version_id, $browse.content.object_version ) )}



{* DESIGN: Header START *}<div class="box-header">

<h1 class="context-title">{'Choose locations for <%version_name>'|i18n( 'design/admin/content/browse_placement',, hash( '%version_name', $version.version_name ) )|wash}</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div>

{* DESIGN: Content START *}

<div class="panel">
<p>{'Choose locations for <%version_name> using the checkboxes then click "Select".'|i18n( 'design/admin/content/browse_placement',, hash( '%version_name', $version.version_name ) )|wash}</p>
<p>{'Navigate using the available tabs (above), the tree menu (left) and the content list (middle).'|i18n( 'design/admin/content/browse_placement' )}</p>
</div>

{* DESIGN: Content END *}



{/let}
