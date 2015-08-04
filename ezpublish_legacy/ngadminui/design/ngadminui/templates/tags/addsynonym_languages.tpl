<div class="context-block tags-edit">
    <div class="box-header">
        <h1 class="context-title">{"New synonym tag"|i18n( 'extension/eztags/tags/edit' )}</h1>
        <div class="header-mainline"></div>
    </div>

    <div class="box-content panel">
        <form method="post" action={concat( 'tags/addsynonym/', $main_tag.id )|ezurl}>
            <div class="block">
                <fieldset>
                    <legend>{'Add translation'|i18n('extension/eztags/tags/edit')}</legend>
                    <p>{'Select the translation you want to add'|i18n('extension/eztags/tags/edit')}:</p>
                    {foreach $languages as $index => $language}
                        <div class="radio">
                            <label><input name="Locale" type="radio" value="{$language.locale|wash}" {if $index|eq(0)}checked="checked"{/if} > {$language.name|wash}</label>
                        </div>
                    {/foreach}
                </fieldset>
            </div>
            <div class="controlbar">
                <div class="btn-group">
                    <input class="btn btn-primary" type="submit" name="AddTranslationButton" value="{'New synonym tag'|i18n( 'extension/eztags/tags/edit' )}" />
                    <input class="btn btn-default" type="submit" name="DiscardButton" value="{'Discard'|i18n( 'extension/eztags/tags/edit' )}" />
                </div>
            </div>
        </form>
    </div>
</div>
