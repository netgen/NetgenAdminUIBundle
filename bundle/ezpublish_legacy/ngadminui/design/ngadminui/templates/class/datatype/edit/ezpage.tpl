<div class="block form-inline">
    <label>
        {'Default layout:'|i18n( 'design/standard/class/datatype' )}
    </label>
    {def $allowed_zones = fetch('ezflow', 'allowed_zones')
         $class = fetch( 'content', 'class', hash( 'class_id', $class_attribute.contentclass_id ) )}

    <select class="form-control" name="ContentClass_ezpage_default_layout_{$class_attribute.id}">
        <option value="">{'None'|i18n( 'design/standard/class/datatype' )}</option>
        {foreach $allowed_zones as $allowed_zone}
        {if $allowed_zone.classes|contains( $class.identifier )}
        <option value="{$allowed_zone['type']}" {if eq( $class_attribute.data_text1, $allowed_zone['type'] )}selected="selected"{/if}>{$allowed_zone['name']|wash()}</option>
        {/if}
        {/foreach}
    </select>
</div>