{def $translations=$class.prioritized_languages
     $translations_count=$translations|count}
<div class="panel">
    <form name="translationsform" method="post" action={'class/translation'|ezurl}>
        <input type="hidden" name="ContentClassID" value="{$class.id}" />
        <input type="hidden" name="ContentClassLanguageCode" value="{$language_code|wash}" />

        {* DESIGN: Header START *}

        <h2>{'Translations (%translations)'|i18n( 'design/admin/class/view',, hash( '%translations', $translations_count ) )}</h2>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        <fieldset>
            <p>{'Existing languages'|i18n( 'design/admin/class/view' )}:</p>

            <table class="list" cellspacing="0">
                <tr>
                    <th class="tight"><i class="fa fa-check-square-o" title="{'Invert selection.'|i18n( 'design/admin/class/view' )}" onclick="ezjs_toggleCheckboxes( document.translationsform, 'LanguageID[]' ); return false;"></i></th>
                    <th>{'Language'|i18n( 'design/admin/class/view' )}</th>
                    <th>{'Locale'|i18n( 'design/admin/class/view' )}</th>
                    <th class="tight">{'Main'|i18n( 'design/admin/class/view' )}</th>
                    <th class="tight">&nbsp;</th>
                </tr>

                {section var=Translations loop=$translations sequence=array( bglight, bgdark )}

                <tr class="{$Translations.sequence}">

                {* Remove. *}
                <td>
                    <input type="checkbox" name="LanguageID[]" value="{$Translations.item.id}"{if $Translations.item.id|eq($class.initial_language_id)} disabled="disabled"{/if} />
                </td>

                {* Language name. *}
                <td>
                    <img src="{$Translations.item.locale|flag_icon}" width="18" height="12" alt="{$Translations.item.locale}" />
                    &nbsp;
                    {if eq( $Translations.item.locale, $language_code )}
                    <b><a href={concat( 'class/view/', $class.id, '/(language)/', $Translations.item.locale )|ezurl} title="{'View translation.'|i18n( 'design/admin/class/view' )}">{$Translations.item.name}</a></b>
                    {else}
                    <a href={concat( 'class/view/', $class.id, '/(language)/', $Translations.item.locale )|ezurl} title="{'View translation.'|i18n( 'design/admin/class/view' )}">{$Translations.item.name}</a>
                    {/if}
                </td>

                {* Locale code. *}
                <td>{$Translations.item.locale}</td>

                {* Main. *}
                <td>

                    <input type="radio"{if $Translations.item.id|eq($class.initial_language_id)} checked="checked"{/if} name="InitialLanguageID" value="{$Translations.item.id}" title="{'Use these radio buttons to select the desired main language.'|i18n( 'design/admin/class/view' )}" />

                </td>

                {* Edit. *}
                <td>

                    <a href={concat( 'class/edit/', $class.id, '/(language)/', $Translations.item.locale )|ezurl}><i class="fa fa-pencil-square-o" title="{'Edit in %language_name.'|i18n( 'design/admin/class/view',, hash( '%language_name', $Translations.item.locale_object.intl_language_name ) )|wash}"></i></a>

                </td>

                </tr>

                {/section}
            </table>

            <div class="controlbar clearfix">
                <div class="button-left">
                    {if $translations_count|gt( 1 )}
                    <input class="btn btn-default btn-sm" type="submit" name="RemoveTranslationButton" value="{'Remove selected'|i18n( 'design/admin/class/view' )}" title="{'Remove selected languages from the list above.'|i18n( 'design/admin/class/view' )}" />
                    {else}
                    <input class="btn btn-default btn-sm" type="submit" name="RemoveTranslationButton" value="{'Remove selected'|i18n( 'design/admin/class/view' )}" title="{'There is no removable language.'|i18n( 'design/admin/class/view' )}" disabled="disabled" />
                    {/if}
                </div>

                <div class="button-right">
                    {if $translations_count|gt( 1 )}
                    <input class="btn btn-default btn-sm" type="submit" name="UpdateInitialLanguageButton" value="{'Set main'|i18n( 'design/admin/class/view' )}" title="{'Select the desired main language using the radio buttons above then click this button to store the setting.'|i18n( 'design/admin/class/view' )}" />
                    {else}
                    <input class="btn btn-default btn-sm" type="submit" name="_Disabled" value="{'Set main'|i18n( 'design/admin/class/view' )}" disabled="disabled" title="{'You cannot change the main language because the object is not translated to any other languages.'|i18n( 'design/admin/class/view' )}" />
                    {/if}
                </div>

            </div>
        </fieldset>

        {* DESIGN: Content END *}

    </form>
</div>
{undef $translations
       $translations_count}
