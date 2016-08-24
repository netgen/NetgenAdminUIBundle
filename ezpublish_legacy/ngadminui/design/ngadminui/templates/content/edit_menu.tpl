
{foreach ezini( 'ContentEditSettings', 'LeftMenuParts', 'admininterface.ini' ) as $tpl}
    {include uri=concat( 'design:', $tpl ) object=$object}
{/foreach}

{include uri="design:content/parts/object_information.tpl" object=$object manage_version_button=true()}

<div class="drafts block">

    {* DESIGN: Header START *}

    <h3>{'Current draft'|i18n( 'design/admin/content/edit' )}</h3>

    {* DESIGN: Header END *}

    {* DESIGN: Content START *}
    <div class="box-content">

        {* Created *}
        <p>
            <label>{'Created'|i18n( 'design/admin/content/edit' )}:</label>
            {$content_version.created|l10n( shortdatetime )}<br />
            {$content_version.creator.name|wash}
        </p>

        {* Modified *}
        <p>
            <label>{'Modified'|i18n( 'design/admin/content/edit' )}:</label>
            {$content_version.modified|l10n( shortdatetime )}<br />
            {$content_version.creator.name|wash}
        </p>

        {* Version *}
        <p>
            <label>{'Version'|i18n( 'design/admin/content/edit' )}:</label>
            {$edit_version}
        </p>

        {* DESIGN: Content END *}
    </div>
</div>

<!-- Translation box start-->
<div class="translations block">

    {* DESIGN: Header START *}

    <h3>{'Existing translations'|i18n( 'design/admin/content/edit' )}</h3>

    {* DESIGN: Header END *}

    {* DESIGN: Content START *}
    <div class="box-content">
        <p>{'Base translation on'|i18n( 'design/admin/content/edit' )}:</p>
        <label><input type="radio" name="FromLanguage" value=""{if $from_language|not} checked="checked"{/if}{if $object.status|eq(0)} disabled="disabled"{/if} /> {'None'|i18n( 'design/admin/content/edit' )}</label>

        {if $object.status}
        {foreach $object.languages as $language}
            {if not( eq($language.locale, $object.current_language_object.locale) )} {* Only providing other languages than current *}
            <label>
                <input type="radio" name="FromLanguage" value="{$language.locale|wash}"{if $language.locale|eq($from_language)} checked="checked"{/if} />
                <img src="{$language.locale|flag_icon}" width="18" height="12" alt="{$language.locale|wash}" style="vertical-align: middle;" />
                {$language.locale|wash}
            </label>
            {/if}
        {/foreach}
        {/if}

        <input {if $object.status|eq(0)}disabled="disabled"{/if} class="btn btn-default btn-sm" type="submit" name="FromLanguageButton" value="{'View'|i18n( 'design/admin/content/edit' )}" title="{'Edit the current object showing the selected language as a reference.'|i18n( 'design/admin/content/edit' )}" />

    {* DESIGN: Content END *}
    </div>
</div>

<!-- Translation box end-->

{* Edit section *}
<div class="sections block">
    {include uri='design:content/parts/edit_sections.tpl'}
</div>


{* Edit states *}
<div class="states block">
    {include uri='design:content/parts/edit_states.tpl'}
</div>
