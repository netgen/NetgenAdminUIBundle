<form name="languageform" action={$module.functions.translations.uri|ezurl} method="post" >
    <div class="panel">

        {* Translation window *}
        {* DESIGN: Header START *}
        <h1>{'%translation [Translation]'|i18n( 'design/admin/content/translationview',, hash( '%translation', $translation.locale_object.intl_language_name ) ) }</h1>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        {* ID *}
        <div class="preview-content">
            <div class="block">
                <label>{'ID'|i18n( 'design/admin/content/translationview' )}:</label>
                {$translation.id}
            </div>

            {* Locale *}
            <div class="block">
                <label>{'Locale'|i18n( 'design/admin/content/translationview' )}:</label>
                {$translation.locale}
            </div>
        </div>

        <div class="controlbar">
        {* DESIGN: Control bar START *}
            <input type="hidden" name="DeleteIDArray[]" value="{$translation.id}" />
            {if ne( false()|locale.locale_code, $translation.locale_object.locale_code )}
            <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove'|i18n( 'design/admin/content/translationview' )}" />
            {else}
            <input class="btn btn-default" type="submit" name="RemoveButton" value="{'Remove'|i18n( 'design/admin/content/translationview' )}" disabled="disabled" />
            {/if}
        </div>

    </div>

    {* DESIGN: Content END *}

    {* DESIGN: Control bar END *}

</form>


{* Locale window *}
<div class="panel">
    {* DESIGN: Header START *}
    <h2>{'%locale [Locale]'|i18n( 'design/admin/content/translationview',, hash( '%locale', $translation.locale ) ) }</h2>



    {* DESIGN: Header END *}

    {* DESIGN: Content START *}
    <div class="preview-content">

        {* Charset *}
        <div class="block">
        <label>{'Charset'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.charset}
            {$translation.locale_object.charset}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Allowed charsets *}
        <div class="block">
        <label>{'Allowed charsets'|i18n( 'design/admin/content/translationview' )}:</label>
        {section var=Charsets loop=$translation.locale_object.allowed_charsets}
            {$Charsets.item}<br />
        {/section}
        </div>

        {* Country/region name *}
        <div class="block">
        <label>{'Country/region name'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.country_name}
            {$translation.locale_object.country_name}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Country/region comment *}
        <div class="block">
        <label>{'Country/region comment'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.country_comment}
            {$translation.locale_object.country_comment}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Country/region code *}
        <div class="block">
        <label>{'Country/region code'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.country_code}
            {$translation.locale_object.country_code}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Country/region variation *}
        <div class="block">
        <label>{'Country/region variation'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.country_variation}
            {$translation.locale_object.country_variation}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Language name *}
        <div class="block">
        <label>{'Language name'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.language_name}
            {$translation.locale_object.language_name}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* International language name *}
        <div class="block">
        <label>{'International language name'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.intl_language_name}
            {$translation.locale_object.intl_language_name}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Language code *}
        <div class="block">
        <label>{'Language code'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.language_code}
            {$translation.locale_object.language_code}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Language comment *}
        <div class="block">
        <label>{'Language comment'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.language_comment}
            {$translation.locale_object.language_comment}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Locale code *}
        <div class="block">
        <label>{'Locale code'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.locale_code}
            {$translation.locale_object.locale_code}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Full locale code *}
        <div class="block">
        <label>{'Full locale code'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.locale_full_code}
            {$translation.locale_object.locale_full_code}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* HTTP locale code *}
        <div class="block">
        <label>{'HTTP locale code'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.http_locale_code}
            {$translation.locale_object.http_locale_code}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Decimal symbol *}
        <div class="block">
        <label>{'Decimal symbol'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.decimal_symbol}
            {$translation.locale_object.decimal_symbol}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Thousands separator *}
        <div class="block">
        <label>{'Thousands separator'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.thousands_separator}
            {$translation.locale_object.thousands_separator}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Decimal count *}
        <div class="block">
        <label>{'Decimal count'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.decimal_count}
            {$translation.locale_object.decimal_count}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Negative symbol *}
        <div class="block">
        <label>{'Negative symbol'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.negative_symbol}
            {$translation.locale_object.negative_symbol}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Positive symbol *}
        <div class="block">
        <label>{'Positive symbol'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.positive_symbol}
            {$translation.locale_object.positive_symbol}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency decimal symbol *}
        <div class="block">
        <label>{'Currency decimal symbol'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_decimal_symbol}
            {$translation.locale_object.currency_decimal_symbol}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency thousands separator *}
        <div class="block">
        <label>{'Currency thousands separator'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_thousands_separator}
            {$translation.locale_object.currency_thousands_separator}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency decimal count *}
        <div class="block">
        <label>{'Currency decimal count'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_decimal_count}
            {$translation.locale_object.currency_decimal_count}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency negative symbol *}
        <div class="block">
        <label>{'Currency negative symbol'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_negative_symbol}
            {$translation.locale_object.currency_negative_symbol}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency positive symbol *}
        <div class="block">
        <label>{'Currency positive symbol'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_positive_symbol}
            {$translation.locale_object.currency_positive_symbol}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency symbol *}
        <div class="block">
        <label>{'Currency symbol'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_symbol}
            {$translation.locale_object.currency_symbol}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency name *}
        <div class="block">
        <label>{'Currency name'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_name}
            {$translation.locale_object.currency_name}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* Currency short name *}
        <div class="block">
        <label>{'Currency short name'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.currency_short_name}
            {$translation.locale_object.currency_short_name}
        {else}
            <i>{'Not set'|i18n( 'design/admin/content/translationview' )}</i>
        {/if}
        </div>

        {* First day of week *}
        <div class="block">
        <label>{'First day of week'|i18n( 'design/admin/content/translationview' )}:</label>
        {if $translation.locale_object.is_monday_first}
            {'Monday'|i18n( 'design/admin/content/translationview' )}
        {else}
            {'Sunday'|i18n( 'design/admin/content/translationview' )}
        {/if}
        </div>

        {* Weekday names *}
        <div class="block">
        <label>{'Weekday names'|i18n( 'design/admin/content/translationview' )}:</label>
        {section var=Weekdays loop=$translation.locale_object.weekday_name_list}
            {$Weekdays.item}<br />
        {/section}
        </div>

        {* Month names *}
        <div class="block">
        <label>{'Month names'|i18n( 'design/admin/content/translationview' )}:</label>
        {section var=Months loop=$translation.locale_object.month_name_list}
            {$Months.item}<br />
        {/section}
        </div>
    </div>

    {* DESIGN: Content END *}

</div>
