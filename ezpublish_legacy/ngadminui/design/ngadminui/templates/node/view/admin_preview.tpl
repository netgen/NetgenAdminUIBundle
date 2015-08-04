{* Default preview template for ngadminui interface. *}
{* Will be used if there is no suitable override for a specific class. *}

{* Group Display all the attributes using their default template. *}

{default
$attribute_categorys        = ezini( 'ClassAttributeSettings', 'CategoryList', 'content.ini' )
$attribute_default_category = ezini( 'ClassAttributeSettings', 'DefaultCategory', 'content.ini' )}

{foreach group_data_map($node.object.contentobject_attributes) as $attribute_group => $content_attributes_grouped}
    {*if $attribute_group|ne( $attribute_default_category )}
    <fieldset class="ezcca-collapsible ezcca-attributes-group-{$attribute_group|wash}">
        <legend><a href="JavaScript:void(0);">{$attribute_categorys[$attribute_group]}</a></legend>
        <div class="ezcca-collapsible-fieldset-content">
    {/if*}
    {foreach $content_attributes_grouped as $attribute_identifier => $attribute}
        <div class="row">
            {if $attribute.display_info.view.grouped_input}
            <fieldset>
                <div class="col-sm-3 text-right">
                    <legend>{$attribute.contentclass_attribute.name|wash}{if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}</legend>
                </div>
                <div class="col-sm-9">
                    {attribute_view_gui attribute=$attribute}
                </div>
            </fieldset>
            {else}
                <div class="col-sm-3 text-right">
                    <label>{$attribute.contentclass_attribute.name|wash}{if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}:</label>
                </div>
                <div class="col-sm-9">
                    {attribute_view_gui attribute=$attribute}
                </div>
            {/if}
        </div>
    {/foreach}
    {*if $attribute_group|ne( $attribute_default_category )}
        </div>
        </fieldset>
    {/if*}
{/foreach}
