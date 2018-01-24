{def $languages               = fetch('content', 'prioritized_languages')
     $object_language_codes   = $object.language_codes
     $object_edit_languages   = $object.can_edit_languages
     $object_create_languages = $object.can_create_languages
     $can_edit                = true()}

<!--div class="rightmenu">
    <div id="rightmenu-design">

        {include uri="design:content/parts/object_information.tpl" object=$object manage_version_button=false()}

    </div>
</div-->


<!-- Maincontent START -->

<div class="path-edit-container"></div>
<form action={concat('content/edit/',$object.id)|ezurl} method="post">


    {* DESIGN: Header START *}<div class="box-header">

        <h1 class="context-title">{'Edit < %object_name >'|i18n( 'design/admin/content/edit_languages',, hash( '%object_name', $object.name ) )|wash}</h1>



    {* DESIGN: Header END *}</div>

    {* DESIGN: Content START *}
    <div class="box-content panel">

        <div class="context-attributes">

            {if $show_existing_languages}
                {* Translation a user is able to edit *}
                {set-block variable=$existing_languages_output}
                {foreach $object_edit_languages as $language}
                    <div class="radio">
                        <label>
                            <input name="EditLanguage" type="radio" value="{$language.locale|wash}"{run-once} checked="checked"{/run-once} /> {$language.name|wash}
                        </label>
                    </div>
                {/foreach}
                {/set-block}

                {if $existing_languages_output|trim}
                    <div class="block">
                        <fieldset id="ezcoeditlanguages-existingts">
                            <legend>{'Existing translations'|i18n('design/admin/content/edit_languages')}</legend>
                            <p>{'Select the translation you want to edit'|i18n('design/admin/content/edit_languages')}:</p>

                            <div class="indent">
                                {$existing_languages_output}
                            </div>
                        </fieldset>
                    </div>
                {/if}
            {/if}

            {* Translation a user is able to create *}
            {set-block variable=$nonexisting_languages_output}
            {def $select_first_language = and( $object_create_languages|count|eq( 1 ), $show_existing_languages|not ) }
            {foreach $object_create_languages as $language}
                <div class="radio">
                    <label>
                       <input name="EditLanguage" type="radio" value="{$language.locale|wash}"{if $select_first_language} checked="checked"{/if} /> {$language.name|wash}
                    </label>
                </div>
            {/foreach}
            {undef $select_first_language}
            {/set-block}

            {if $nonexisting_languages_output|trim}

                <div class="block">
                    <fieldset id="ezcoeditlanguages-newts">
                        <legend>{'New translation'|i18n('design/admin/content/edit_languages')}</legend>
                        <p>{'Select the translation you want to add'|i18n('design/admin/content/edit_languages')}:</p>

                        <div class="indent">
                            {$nonexisting_languages_output}
                        </div>
                    </fieldset>
                </div>


                <div class="block">
                    <fieldset id="ezcoeditlanguages-sourcets">
                        <legend>{'Translate based on'|i18n('design/admin/content/edit_languages')}</legend>
                        <p>{'Select the language the added translation will be based on'|i18n('design/admin/content/edit_languages')}:</p>

                        <div class="indent">
                            <div class="radio">
                                <label>
                                    <input name="FromLanguage" type="radio" checked="checked" value="" /> {'None'|i18n('design/admin/content/edit_languages')}
                                </label>
                            </div>

                            {foreach $object.languages as $language}
                                <div class="radio">
                                    <label>
                                        <input name="FromLanguage" type="radio" value="{$language.locale|wash}" /> {$language.name|wash}
                                    </label>
                                </div>
                            {/foreach}
                        </div>
                    </fieldset>
                </div>
            {else}
                {if $show_existing_languages|not}
                    {set $can_edit=false()}
                    <p>{'You do not have permission to create a translation in another language.'|i18n('design/admin/content/edit_languages')}</p>

                    {* Translation a user is able to edit *}
                    {set-block variable=$existing_languages_output}
                    {foreach $object_edit_languages as $language}
                        <div class="radio">
                            <label>
                                <input name="EditLanguage" type="radio" value="{$language.locale|wash}"{run-once} checked="checked"{/run-once} /> {$language.name|wash}
                            </label>
                        </div>
                    {/foreach}
                    {/set-block}

                    {if $existing_languages_output|trim}
                        <div class="block">
                            <fieldset id="ezcoeditlanguages-existingts">
                                {set $can_edit=true()}
                                <legend>{'Existing languages'|i18n('design/admin/content/edit_languages')}</legend>
                                <p>{'However you can select one of the following languages for editing.'|i18n('design/admin/content/edit_languages')}:</p>

                                <div class="indent">
                                    {$existing_languages_output}
                                </div>
                            </fieldset>
                        </div>
                    {/if}
                {elseif $existing_languages_output|trim|not}
                    {set $can_edit=false()}
                    {'You do not have permission to edit the object in any available languages.'|i18n('design/admin/content/edit_languages')}
                {/if}
            {/if}

        </div>

        {* DESIGN: Content END *}
        <div class="controlbar">
            {* DESIGN: Control bar START *}

            {if $can_edit}
                <input class="btn btn-primary" type="submit" name="LanguageSelection" value="{'Edit'|i18n('design/admin/content/edit_languages')}" />
            {else}
                <input class="btn btn-primary" disabled="disabled" type="submit" name="LanguageSelection" value="{'OK'|i18n('design/admin/content/edit_languages')}" />
            {/if}

            <input class="btn btn-default" type="submit" name="CancelDraftButton" value="{'Cancel'|i18n('design/admin/content/edit_languages')}" />

            {* DESIGN: Control bar END *}

        </div>
    </div>

</form>


<script type="text/javascript">
{literal}
(function( $ )
{
    if ( document.getElementById('ezcoeditlanguages-sourcets') )
    {
        // setup onchange events
        jQuery( '#ezcoeditlanguages-existingts input[type=radio]' ).change(function()
        {
            jQuery( '#ezcoeditlanguages-sourcets input[type=radio]' ).attr( 'disabled', true );
        });
        jQuery( '#ezcoeditlanguages-newts input[type=radio]' ).change(function()
        {
            jQuery( '#ezcoeditlanguages-sourcets input[type=radio]' ).attr( 'disabled', false );
        });

        // disable source translations if existing translation is selected
        if ( jQuery( '#ezcoeditlanguages-existingts input[checked=checked]' ).size() > 0 )
        {
            jQuery( '#ezcoeditlanguages-sourcets input[type=radio]' ).attr( 'disabled', true );
        }
    }
})( jQuery );
{/literal}
</script>

<!-- Maincontent END -->


