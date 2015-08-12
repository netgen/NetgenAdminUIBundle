{default attribute_base='ContentObjectAttribute' html_class='full'}
{def $class_list_by_group = hash()}
{def $class_list = fetch( class, list_by_groups, hash( group_filter, false() ) )}

{foreach $class_list as $class}
    {if is_set( $class_list_by_group[$class.ingroup_list.0.group_name] )}
        {set $class_list_by_group = $class_list_by_group|merge( hash( $class.ingroup_list.0.group_name, $class_list_by_group[$class.ingroup_list.0.group_name]|append( $class ) ) )}
    {else}
        {set $class_list_by_group = $class_list_by_group|merge( hash( $class.ingroup_list.0.group_name, array( $class ) ) )}
    {/if}
{/foreach}

<select multiple="multiple" size="15" id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="form-control form-control-multiple inline {eq( $html_class, 'half' )|choose( 'box', 'halfbox' )} ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" name="{$attribute_base}_ngclasslist_class_list_{$attribute.id}[]">
    {foreach $class_list_by_group as $group_name => $group_classes}
        <option disabled="disabled" value="group_{$group_name|wash}">{$group_name|wash}</option>
        {foreach $group_classes as $class}
            <option value="{$class.identifier|wash}"{if $attribute.content.class_identifiers|contains( $class.identifier )} selected="selected"{/if}>&nbsp;&nbsp;&nbsp;{$class.name|wash}</option>
        {/foreach}
    {/foreach}
</select>

{undef $class_list_by_group $class_list}
{/default}
