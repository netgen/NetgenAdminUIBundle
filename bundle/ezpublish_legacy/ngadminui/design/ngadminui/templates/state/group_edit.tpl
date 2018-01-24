<form action={concat("/state/group_edit", cond($group.id,concat('/',$group.identifier),true(),''))|ezurl} method="post">

    {if is_set($is_valid)}
    {if $is_valid}
      <div class="alert alert-info" role="alert">
          <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'The content object state group was successfully stored.'|i18n( 'design/admin/state/groups' )}</h2>
      </div>
    {else}
      <div class="alert alert-warning" role="alert">
      <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'The content object state group could not be stored.'|i18n( 'design/admin/state/groups' )}</h2>
      <p>{'Required data is either missing or is invalid'|i18n( 'design/admin/state/groups' )}:</p>
      <ul>
      {foreach $validation_messages as $message}
      <li>{$message|wash}</li>
      {/foreach}
      </ul>
      </div>
    {/if}
    {/if}

    <div class="context-block">

        {* DESIGN: Header START *}<div class="box-header">

        <h1 class="context-title">
        {if $group.id}
        {'Edit content object state group "%group_name"'|i18n('design/admin/state/group_edit', '', hash( '%group_name', $group.current_translation.name ))|wash}
        {else}
        {'New content object state group'|i18n('design/admin/state/group_edit')|wash}
        {/if}
        </h1>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}</div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            <div class="block form-inline">
                <div class="form-group">
                    <label>{"Identifier:"|i18n('design/admin/state/group_edit')}</label>
                    <input class="form-control" type="text" name="ContentObjectStateGroup_identifier" maxlength="45" value="{$group.identifier|wash}" />
                </div>
                {if $group.all_translations|count|gt(1)}
                <div class="form-group">
                    <label>{"Default language:"|i18n('design/admin/state/group_edit')}</label>
                    <select class="form-control" name="ContentObjectStateGroup_default_language_id">
                        {foreach $group.all_translations as $translation}
                            <option value="{$translation.language.id}" {if $group.default_language_id|eq($translation.language.id)}selected="selected"{/if}>{$translation.language.locale_object.intl_language_name|wash}</option>
                        {/foreach}
                    </select>
                </div>
                {/if}
                <div class="break"></div>
            </div>


            <div class="row">
            {let $translations=$group.all_translations
                $useFieldsets=$translations|count|gt(1)}
            {foreach $translations as $translation}
                <div class="col-sm-6">
                    {if $useFieldsets}
                        <div class="block">
                            <fieldset>
                                <legend><img src="{$translation.language.locale|flag_icon}" width="18" height="12" /> {$translation.language.locale_object.intl_language_name|wash}</legend>
                    {/if}
                        <div class="form-group">
                            <label>{"Name:"|i18n('design/admin/state/group_edit')}</label>
                            <input type="text" class="form-control" maxlength="45" name="ContentObjectStateGroup_name[]" value="{$translation.name|wash}" />
                        </div>
                        <div class="form-group">
                            <label>{"Description:"|i18n('design/admin/state/group_edit')}</label>
                            <textarea class="form-control" rows="6" name="ContentObjectStateGroup_description[]">{$translation.description|wash}</textarea>
                        </div>
                    {if $useFieldsets}
                            </fieldset>
                        </div>
                    {/if}
                </div>
            {/foreach}
            </div>


            {* DESIGN: Content END *}
            <div class="controlbar">
            {* DESIGN: Control bar START *}
                {if $group.id}
                <input class="btn btn-primary" type="submit" name="StoreButton" value="{'Save changes'|i18n('design/admin/state/group_edit')|wash}" title="{'Save changes to this state group.'|i18n( 'design/admin/state/group_edit' )|wash}" />
                <input class="btn btn btn-default" type="submit" name="CancelButton" value="{'Cancel'|i18n('design/admin/state/group_edit')|wash}" title="{'Cancel saving any changes.'|i18n( 'design/admin/state/group_edit' )|wash}" />
                {else}
                <input class="btn btn-primary" type="submit" name="StoreButton" value="{'Create'|i18n('design/admin/state/group_edit')|wash}" title="{'Create this state group.'|i18n( 'design/admin/state/group_edit' )|wash}" />
                <input class="btn btn-default" type="submit" name="CancelButton" value="{'Cancel'|i18n('design/admin/state/group_edit')|wash}" title="{'Cancel creating this state group.'|i18n( 'design/admin/state/group_edit' )|wash}" />
                {/if}

            </div>

            {* DESIGN: Control bar END *}

        </div>

    </div>{* class="context-block" *}

</form>