{let content=$attribute.content
     classContent=$attribute.class_content
     id=$attribute.id
     i18n_context="extension/sckenhancedselection/object/edit"
     available_options=$classContent.options}

{section show=and(is_set($classContent.db_options),count($classContent.db_options)|gt(0))}
    {set available_options=$classContent.db_options}
{/section}

<select class="form-control inline" name="ContentObjectAttribute_sckenhancedselection_selection_{$id}[]"
        {section show=$classContent.is_multiselect}multiple="multiple"{/section}>

    {section var=option loop=$available_options}
        <option value="{$option.item.identifier|wash}"
                {section show=$content|contains($option.item.identifier)}selected="selected"{/section}>
            {$option.item.name|wash}
        </option>
    {/section}

</select>

{/let}
