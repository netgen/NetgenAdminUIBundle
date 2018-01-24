{literal}
<script type="text/javascript">
function toggleInputs( selection )
{
    var nameField = document.getElementById( "field1" );
    var localeField = document.getElementById( "field2" );

    if( selection.value == "-1" )
    {
        nameField.disabled = localeField.disabled = false;
    }
    else
    {
        nameField.disabled = localeField.disabled = true;
        nameField.value = localeField.value = "";
    }
}
</script>
{/literal}

<form name="languageform" action={concat( 'content/translations' )|ezurl} method="post" >

    {* DESIGN: Header START *}
    <div class="title-wrapper">
        <span class="title-edit">{'translation'|icon( 'normal', 'Translation'|i18n( 'design/admin/content/translationnew' ) )}</span>
        <h1 class="context-title">{'New translation for content'|i18n( 'design/admin/content/translationnew' )}</h1>
        {* DESIGN: Mainline *}<div class="header-mainline"></div>
        {* DESIGN: Header END *}
    </div>

    {* DESIGN: Content START *}
    <div class="row">
        <div class="col-md-6 col-sm-12">
            <div class="panel content-translations content-translations-new">
                <div class="form-group">
                    {* Translation. *}
                    <label for="localeSelector">{'Translation'|i18n( 'design/admin/content/translationnew' )}:</label>
                    <select class="form-control" id="localeSelector" name="LocaleID" onchange="toggleInputs(this); return false;">
                        <option value="-1">{'Custom'|i18n( 'design/admin/content/translationnew' )}</option>
                        {section var=Translations loop=fetch( content, locale_list, hash( with_variations, false() ) )}
                        <option value="{$Translations.item.locale_full_code|wash}">
                        {$Translations.item.intl_language_name|wash}{if $Translations.item.country_variation} [{$Translations.item.language_comment|wash}]{/if}
                        </option>
                        {/section}
                    </select>
                </div>

                {* Custom name. *}
                <div class="form-group">
                    <label for="field1">{'Name of custom translation'|i18n( 'design/admin/content/translationnew' )}:</label>
                    <input class="form-control" id="field1" type="text" name="TranslationName" value=""  size="20" />
                </div>

                {* Custom locale. *}
                <div class="form-group">
                    <label for="field2">{'Locale for custom translation'|i18n( 'design/admin/content/translationnew' )}:</label>
                    <input class="form-control" id="field2" type="text" name="TranslationLocale" value="" size="8" />
                </div>

                {* DESIGN: Content END *}


                {* Buttons. *}
                <div class="controlbar">
                    {* DESIGN: Control bar START *}
                    <div class="block">
                        {if $is_edit}
                            <input class="btn btn-primary" type="submit" name="ChangeButton" value="{'OK'|i18n( 'design/admin/content/translationnew')}" />
                        {else}
                            <input class="btn btn-primary" type="submit" name="StoreButton" value="{'OK'|i18n('design/admin/content/translationnew')}" />
                        {/if}

                        <input class="btn btn-default" type="submit" name="CancelButton" value="{'Cancel'|i18n('design/admin/content/translationnew')}" />
                    </div>
                    {* DESIGN: Control bar END *}
                </div>
            </div>
        </div>

    </div>

</form>

