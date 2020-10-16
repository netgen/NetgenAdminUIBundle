{let content=$attribute.content
     classContent=$attribute.class_content
     id=$attribute.id
     i18n_context="extension/sckenhancedselection/object/edit"
     available_options=$classContent.options}

{section show=and(is_set($classContent.db_options),count($classContent.db_options)|gt(0))}
    {set available_options=$classContent.db_options}
{/section}

{if $classContent.is_expanded}
    {if $classContent.is_multiselect}
        {section var=option loop=$available_options}
            <div class="form-row">
                <input type="checkbox" name="ContentObjectAttribute_sckenhancedselection_selection_{$id}[]" value="{$option.item.identifier|wash}"
                       {if $content|contains($option.item.identifier))}checked="checked"{/if}>
                {$option.item.name|wash}
            </div>
        {/section}
    {else}
        {section var=option loop=$available_options}
            <div class="form-row">
                <input type="radio" name="ContentObjectAttribute_sckenhancedselection_selection_{$id}[]" value="{$option.item.identifier|wash}"
                       {if and($content|count|eq(1), $content|contains($option.item.identifier))}checked="checked"{/if}>
                {$option.item.name|wash}
            </div>
        {/section}
    {/if}
{else}
    {* select (single or multiple choice) *}
    <select class="form-control inline" name="ContentObjectAttribute_sckenhancedselection_selection_{$id}[]"
            {section show=$classContent.is_multiselect}multiple="multiple"{/section}>

        {section var=option loop=$available_options}
            <option value="{$option.item.identifier|wash}"
                    {section show=$content|contains($option.item.identifier)}selected="selected"{/section}>
                {$option.item.name|wash}
            </option>
        {/section}
    </select>
{/if}
{/let}
