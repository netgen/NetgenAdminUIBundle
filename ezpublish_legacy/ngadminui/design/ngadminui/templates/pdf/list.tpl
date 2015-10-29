<form name="pdfexportlist" method="post" action={'pdf/list'|ezurl}>

    {* DESIGN: Header START *}
    <div class="box-header">
        <h1 class="context-title">{'PDF exports (%export_count)'|i18n( 'design/admin/pdf/list',, hash( '%export_count', $pdfexport_list|count ) )}</h1>

    {* DESIGN: Mainline *}<div class="header-mainline"></div>

    {* DESIGN: Header END *}
    </div>

    {* DESIGN: Content START *}
    <div class="box-content panel">

        {section show=$pdfexport_list}
        <table class="list" cellspacing="0">
            <tr>
                <th class="tight"><i class="fa fa-check-square-o" onclick="ezjs_toggleCheckboxes( document.pdfexportlist, 'DeleteIDArray[]' ); return false;" title="{'Invert selection.'|i18n( 'design/admin/pdf/list' )}"></i></th>
                <th>{'Name'|i18n( 'design/admin/pdf/list' )}</th>
                <th>{'Modifier'|i18n( 'design/admin/pdf/list' )}</th>
                <th>{'Modified'|i18n( 'design/admin/pdf/list' )}</th>
                <th class="tight">&nbsp;</th>
            </tr>

            {section var=PDFExports loop=$pdfexport_list sequence=array( bglight, bgdark )}
            <tr class="{$PDFExports.sequence}">

                {*Remove. *}
                <td><input type="checkbox" name="DeleteIDArray[]" value="{$PDFExports.item.id}" title="{'Select PDF export for removal.'|i18n( 'design/admin/pdf/list' )}" /></td>

                {* Name. *}
                <td>{'pdfexport'|icon( 'small', 'PDF Export'|i18n( 'design/admin/pdf/list' ) )}&nbsp;
                {section show=$PDFExports.item.status|eq(1)}
                {if and( is_set( $PDFExports.item.source_node ), $PDFExports.item.source_node )}
                <a href={$PDFExports.item.filepath|ezroot}>
                {/if}
                {$PDFExports.item.title|wash}
                {if and( is_set( $PDFExports.item.source_node ), $PDFExports.item.source_node )}
                </a>
                {/if}
                {section-else show=$PDFExports.item.status|eq(2)}
                <a href={concat('pdf/edit/', $PDFExports.item.id, '/generate')|ezurl}>{$PDFExports.item.title|wash}</a>
                {/section}
                </td>

                {* Modifier. *}
                <td><a href={$PDFExports.item.modifier.contentobject.main_node.url_alias|ezurl}>{$PDFExports.item.modifier.contentobject.name|wash}</a></td>

                {* Modified. *}
                <td>{$PDFExports.item.modified|l10n( shortdatetime )}</td>

                {* Edit. *}
                <td><a href={concat( 'pdf/edit/', $PDFExports.item.id )|ezurl}><i class="fa fa-pencil-square-o" title="{'Edit the < %pdf_export_name > PDF export.'|i18n( 'design/admin/pdf/list',, hash( '%pdf_export_name', $PDFExports.item.title ) )|wash}"></i></a></td>

            </tr>
            {/section}
        </table>
        {section-else}
        <div class="block">
            <p>{'There are no PDF exports in the list.'|i18n( 'design/admin/pdf/list' )}</p>
        </div>
        {/section}

        {* DESIGN: Content END *}
        {* Buttons. *}
        <div class="controlbar">
            {* DESIGN: Control bar START *}
            {if $pdfexport_list}
              <input class="btn btn-default" type="submit" name="RemoveExportButton" value="{'Remove selected'|i18n( 'design/admin/pdf/list' )}" title="{'Remove selected PDF exports.'|i18n( 'design/admin/pdf/list' )}" />
            {else}
              <input class="btn btn-default" type="submit" name="RemoveExportButton" value="{'Remove selected'|i18n( 'design/admin/pdf/list' )}" disabled="disabled" />
            {/if}

            <input class="btn btn-default" type="submit" name="NewPDFExport" value="{'New PDF export'|i18n( 'design/admin/pdf/list' )}" title="{'Create a new PDF export.'|i18n( 'design/admin/pdf/list' )}" />
        </div>
        {* DESIGN: Control bar END *}

    </div>


</form>
