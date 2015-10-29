{*-- Override templates start. --*}
{let override_templates=fetch( class, override_template_list, hash( class_id, $class.id ) )}
<div class="panel">
    {* DESIGN: Header START *}
    <h2>{'Override templates (%1)'|i18n( 'design/admin/class/view',, array( $override_templates|count ) )}</h2>

    {* DESIGN: Header END *}

    {* DESIGN: Content START *}

    {section show=$override_templates|count}
    <table class="list" cellspacing="0">
        <tr>
            <th>{'Siteaccess'|i18n( 'design/admin/class/view' )}</th>
            <th>{'Override'|i18n( 'design/admin/class/view' )}</th>
            <th>{'Source template'|i18n( 'design/admin/class/view' )}</th>
            <th>{'Override template'|i18n( 'design/admin/class/view' )}</th>
            <th class="tight">&nbsp;</th>
        </tr>

        {section var=Overrides loop=$override_templates sequence=array( bglight, bgdark )}
        <tr class="{$Overrides.sequence}">
            <td>{$Overrides.item.siteaccess}</td>
            <td>{$Overrides.item.block}</td>
            <td><a href={concat( '/visual/templateview', $Overrides.item.source )|ezurl} title="{'View template overrides for the %source_template_name template.'|i18n( 'design/admin/class/view',, hash( '%source_template_name', $Overrides.item.source ) )|wash}">{$Overrides.item.source}</a></td>
            <td>{$Overrides.item.target}</td>
            <td><a href={concat( '/visual/templateedit/', $Overrides.item.target)|ezurl}><i class="fa fa-pencil-square-o" title="{'Edit the override template for the %override_name override.'|i18n( 'design/admin/class/view',, hash( '%override_name', $Overrides.item.block ) )|wash}"></i></a></td>
        </tr>
        {/section}
    </table>
    {section-else}
    <p>
    {'This class does not have any class-level override templates.'|i18n( 'design/admin/class/view' )}
    </p>
    {/section}
    {* DESIGN: Content END *}

</div>
{/let}
{*-- Override templates end. --*}

