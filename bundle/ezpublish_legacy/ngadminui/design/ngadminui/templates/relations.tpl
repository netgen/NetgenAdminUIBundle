<div class="panel">
    {* Relations windows. *}
    {def $page_limit = min( ezpreference( 'admin_list_limit' ), 3 )|choose( 10, 10, 25, 50 )
         $offset = first_set( $view_parameters.offset, 0 )}
    {* Related objects list. *}
    {def $relation_type_names = hash( 'common',   'Common'|i18n( 'design/admin/content/edit' ),
                                      'xml_embed', 'Embedded'|i18n( 'design/admin/content/edit' ),
                                      'xml_link',  'Linked'|i18n( 'design/admin/content/edit' ),
                                      'attribute', 'Attribute'|i18n( 'design/admin/content/edit' ) )}
    {def $relation_name_delimiter = ', '}

    <table class="list" cellspacing="0" summary="{'Object relation list from current object.'|i18n( 'design/admin/node/view/full' )}">
    <tr>
        <th>{'Related objects (%related_objects_count)'|i18n( 'design/admin/node/view/full',, hash( '%related_objects_count', $related_objects_count ) )}</th>
        {if $related_objects_count}
        <th>{'Class'|i18n( 'design/admin/node/view/full' )}</th>
        <th>{'Relation type'|i18n( 'design/admin/node/view/full')}</th>
        {/if}
    </tr>
    {if $related_objects_count}
        {def $related_objects_grouped = fetch( 'content', 'related_objects', hash( 'object_id', $node.object.id, 'all_relations', true(), 'group_by_attribute', true(), 'sort_by', array( array( 'class_identifier', true() ), array( 'name', true() ) ), 'offset', $offset, 'limit', $page_limit ) )}
        {def $related_objects_id_typed = fetch( 'content', 'related_objects_ids', hash( 'object_id', $node.object.id ) )}

        {def $tr_class='bglight'}
        {def $attr = 0}
        {foreach $related_objects_grouped as $attribute_id => $related_objects_array }
            {if ne( $attribute_id, 0 )}
                {set $attr = fetch( 'content', 'class_attribute', hash( 'attribute_id', $attribute_id ) )}
            {/if}
            {foreach $related_objects_array as $object }
                <tr class="{$tr_class}">
                {if or( $object.can_read, $object.can_view_embed )}
                    <td>{$object.content_class.identifier|class_icon( small, $object.content_class.name|wash )}&nbsp;{content_view_gui view=text_linked content_object=$object}</td>
                    <td>{$object.content_class.name|wash}</td>
                {else}
                    <td colspan="2"><em>{'You are not allowed to view the related object'|i18n( 'design/admin/node/view/full' )}</em></td>
                {/if}
                <td>
                    {if and( ne( $attribute_id, 0 ), $related_objects_id_typed['attribute']|contains( $object.id ) )}
                        {$relation_type_names['attribute']} ( {$attr.name} )
                    {elseif eq( $attribute_id, 0 )}
                        {def $relation_name_array = array()}
                        {foreach $related_objects_id_typed as $relation_type => $relation_id_array}
                            {if ne( $relation_type, 'attribute' )}
                                {if $relation_id_array|contains( $object.id )}
                                    {set $relation_name_array = $relation_name_array|append( $relation_type_names[$relation_type] )}
                                {/if}
                            {/if}
                        {/foreach}
                        {$relation_name_array|implode( $relation_name_delimiter )}
                        {undef $relation_name_array}
                    {/if}
                </td>
                </tr>
                {if eq( $tr_class,'bgdark' )}
                    {set $tr_class='bglight'}
                {else}
                    {set $tr_class='bgdark'}
                {/if}
            {/foreach}
        {/foreach}
        {undef $tr_class $attr}
    {else}
        <tr><td>{'The item being viewed does not make use of any other objects.'|i18n( 'design/admin/node/view/full' )}</td></tr>
    {/if}
    </table>

    <br />
    {* Reverse related objects list. *}

    <table class="list" cellspacing="0" summary="{'Reverse object relation list to current object.'|i18n( 'design/admin/node/view/full' )}">
    <tr>
        <th>{'Reverse related objects (%related_objects_count)'|i18n( 'design/admin/node/view/full',, hash( '%related_objects_count', $reverse_related_objects_count ) )}</th>
        {if $reverse_related_objects_count}
        <th>{'Class'|i18n( 'design/admin/node/view/full' )}</th>
        <th>{'Relation type'|i18n( 'design/admin/node/view/full' )}</th>
        {/if}
    </tr>
    {if $reverse_related_objects_count}
        {def $reverse_related_objects_grouped = fetch( 'content', 'reverse_related_objects', hash( 'object_id', $node.object.id, 'all_relations', true(), 'group_by_attribute', true(), 'sort_by', array( array( 'class_identifier', true() ), array( 'name', true() ) ), 'limit', $page_limit, 'offset', $offset ) )}
        {def $reverse_related_objects_id_typed = fetch( 'content', 'reverse_related_objects_ids', hash( 'object_id', $node.object.id ) )}

        {def $tr_class='bglight'}
        {def $attr = 0}
        {foreach $reverse_related_objects_grouped as $attribute_id => $related_objects_array }
            {if ne( $attribute_id, 0 )}
                {set $attr = fetch( 'content', 'class_attribute', hash( 'attribute_id', $attribute_id ) )}
            {/if}
            {foreach $related_objects_array as $object }
                <tr class="{$tr_class}">
                {if or( $object.can_read, $object.can_view_embed )}
                    <td>{$object.content_class.identifier|class_icon( small, $object.content_class.name|wash )}&nbsp;{content_view_gui view=text_linked content_object=$object}</td>
                    <td>{$object.content_class.name|wash}</td>
                {else}
                    <td colspan="2"><em>{'You are not allowed to view the related object'|i18n( 'design/admin/node/view/full' )}</em></td>
                {/if}
                <td>
                    {if and( ne( $attribute_id, 0 ), $reverse_related_objects_id_typed['attribute']|contains( $object.id ) )}
                        {$relation_type_names['attribute']} ( {$attr.name} )
                    {elseif eq( $attribute_id, 0 )}
                        {def $relation_name_array = array()}
                        {foreach $reverse_related_objects_id_typed as $relation_type => $relation_id_array}
                            {if ne( $relation_type, 'attribute' )}
                                {if $relation_id_array|contains( $object.id )}
                                    {set $relation_name_array = $relation_name_array|append( $relation_type_names[$relation_type] )}
                                {/if}
                            {/if}
                        {/foreach}
                        {$relation_name_array|implode( $relation_name_delimiter )}
                        {undef $relation_name_array}
                    {/if}
                </td>
                </tr>
                {if eq( $tr_class,'bdark' )}
                    {set $tr_class='bglight'}
                {else}
                    {set $tr_class='bgdark'}
                {/if}
            {/foreach}
        {/foreach}
        {undef $tr_class $attr}
    {else}
        <tr><td>{'The item being viewed is not used by any other objects.'|i18n( 'design/admin/node/view/full' )}</td></tr>
    {/if}
    </table>
</div>
    {include name=navigator
             uri='design:navigator/google.tpl'
             page_uri=$node.url_alias
             item_count=max( $related_objects_count, $reverse_related_objects_count )
             view_parameters=$view_parameters
             node_id=$node.node_id
             item_limit=$page_limit}
