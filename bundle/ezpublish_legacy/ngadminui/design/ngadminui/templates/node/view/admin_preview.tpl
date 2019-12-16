{* Default preview template for ngadminui interface. *}
{* Will be used if there is no suitable override for a specific class. *}
{* Group display all the attributes using their default template. *}

{default
    $attribute_categories = ezini( 'ClassAttributeSettings', 'CategoryList', 'content.ini' )
    $attribute_default_category = ezini( 'ClassAttributeSettings', 'DefaultCategory', 'content.ini' )
}

<div class="node-preview-content">
    {foreach $node.object.grouped_data_map as $attribute_group => $content_attributes_grouped}
        {foreach $content_attributes_grouped as $attribute_identifier => $attribute}
            <div class="preview-row">
                {if $attribute.display_info.view.grouped_input}
                <fieldset>
                    <div class="label-preview">
                        <legend title="identifier: {$attribute.contentclass_attribute_identifier}, attribute ID: {$attribute.id}, type: {$attribute.data_type_string}, class attribute ID: {$attribute.contentclassattribute_id}">{$attribute.contentclass_attribute.name|wash}{if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}</legend>
                    </div>
                    <div class="attribute-preview">
                        {attribute_view_gui attribute=$attribute}
                    </div>
                </fieldset>
                {else}
                    <div class="label-preview">
                        <label title="identifier: {$attribute.contentclass_attribute_identifier}, attribute ID: {$attribute.id}, type: {$attribute.data_type_string}, class attribute ID: {$attribute.contentclassattribute_id}">{$attribute.contentclass_attribute.name|wash}{if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}:</label>
                    </div>
                    <div class="attribute-preview">
                        {attribute_view_gui attribute=$attribute}
                    </div>
                {/if}
            </div>
        {/foreach}
    {/foreach}
</div>
