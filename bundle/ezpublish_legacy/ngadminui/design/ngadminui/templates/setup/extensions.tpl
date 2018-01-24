{if and( is_set( $warning_messages), $warning_messages|count|ge(1) )}
<div class="alert alert-warning" role="alert">
    <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Problems detected during autoload generation:'|i18n( 'design/admin/setup/extensions' )}</h2>
    <ul>
    {foreach $warning_messages as $warning}
        <li><p>{$warning|break()}</p></li>
    {/foreach}
    </ul>
</div>
{/if}

<form name="extensionform" method="post" action={'/setup/extensions'|ezurl}>

    <div class="panel">

        {* DESIGN: Header START *}

        <h2>{'Available extensions (%extension_count)'|i18n( 'design/admin/setup/extensions',, hash( '%extension_count', $available_extension_array|count ) )}</h2>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        {section show=$available_extension_array}
        <table class="list" cellspacing="0">
            <tr>
                <th class="tight">&nbsp;</th>
                <th>{'Name'|i18n( 'design/admin/setup/extensions' )}</th>
            </tr>
            {section var=Extensions loop=$available_extension_array sequence=array( bglight, bgdark )}
            <tr class="{$Extensions.sequence}">
                {* Status. *}
                <td><input type="checkbox" disabled="disabled "name="ActiveExtensionList[]" value="{$Extensions.item}" {if $selected_extension_array|contains($Extensions.item)}checked="checked"{/if} /></td>
                {* Name. *}
                <td>{$Extensions.item}</td>
            </tr>
            {/section}
        </table>
        {section-else}
        <div class="block">
            <p>{'There are no available extensions.'|i18n( 'design/admin/setup/extensions' )}</p>
        </div>
        {/section}

        {* DESIGN: Content END *}

        <div class="controlbar">
            {* DESIGN: Control bar START *}
            <div class="block">
                <input class="button" type="submit" name="GenerateAutoloadArraysButton" value="{'Regenerate autoload arrays for extensions'|i18n( 'design/admin/setup/extensions' )}" title="{'Click this button to regenerate the autoload arrays used by the system for extensions.'|i18n( 'design/admin/setup/extensions' )}" />
            </div>
            {* DESIGN: Control bar END *}
        </div>
    </div>

</form>
