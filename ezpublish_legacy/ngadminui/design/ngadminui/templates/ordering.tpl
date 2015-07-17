<div class="panel">

    {* Ordering windows. *}
    <form name="ordering" method="post" action={'content/action'|ezurl}>
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
        <fieldset>

            {def $sort_fields=hash( 6, 'Class identifier'|i18n( 'design/admin/node/view/full' ),
                                    7, 'Class name'|i18n( 'design/admin/node/view/full' ),
                                    5, 'Depth'|i18n( 'design/admin/node/view/full' ),
                                    3, 'Modified'|i18n( 'design/admin/node/view/full' ),
                                    9, 'Name'|i18n( 'design/admin/node/view/full' ),
                                    1, 'Path String'|i18n( 'design/admin/node/view/full' ),
                                    8, 'Priority'|i18n( 'design/admin/node/view/full' ),
                                    2, 'Published'|i18n( 'design/admin/node/view/full' ),
                                    4, 'Section'|i18n( 'design/admin/node/view/full' ) )
                $title='You cannot set the sorting method for the current location because you do not have permission to edit the current item.'|i18n( 'design/admin/node/view/full' )
                $disabled=' disabled="disabled"' }

            {if $node.can_edit}
                {set title='Use these controls to sort the sub items of the current location on frontend:'|i18n( 'design/admin/node/view/full' )}
                {set disabled=''}
                <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
            {/if}
            <p>{$title}</p>
            <div class="form-inline">
                <div class="form-group">
                    <select id="ezasi-sort-field" name="SortingField" title="{$title}"{$disabled} class="form-control input-sm">
                    {foreach $sort_fields as $key => $field}
                        <option value="{$key}" {if eq( $key, $node.sort_field )}selected="selected"{/if}>{$field}</option>
                    {/foreach}
                    </select>
                </div>
                <div class="form-group">
                    <select id="ezasi-sort-order" name="SortingOrder" title="{$title}"{$disabled} class="form-control input-sm">
                        <option value="0"{if eq($node.sort_order, 0)} selected="selected"{/if}>{'Descending'|i18n( 'design/admin/node/view/full' )}</option>
                        <option value="1"{if eq($node.sort_order, 1)} selected="selected"{/if}>{'Ascending'|i18n( 'design/admin/node/view/full' )}</option>
                    </select>
                </div>
                <div class="form-group">
                    <input  id="ezasi-sort-set" class="btn btn-default btn-sm {if $disabled}disabled{/if}" type="submit" name="SetSorting" value="{'Set'|i18n( 'design/admin/node/view/full' )}" title="{$title}" {$disabled} />
                </div>
            {undef}
        </fieldset>
    </form>
</div>
<div class="panel">

    {* Children window.*}
    <div id="content-view-children">
    {if $node.is_container}
        {include uri='design:children.tpl'}
    {else}
        {include uri='design:no_children.tpl'}
    {/if}
    </div>

    {* Highlight "SetSorting" button on change *}
    {literal}
    <script type="text/javascript">
    jQuery('#ezasi-sort-field, #ezasi-sort-order').each( function(){
        jQuery( this ).attr( 'initial', this.value );
    } ).change(function(){
        var t = $(this), o = $(this.id === 'ezasi-sort-field' ? '#ezasi-sort-order' : '#ezasi-sort-field'), s = $('#ezasi-sort-set');
        // signal in gui if user needs to save this or not
        if ( t.val() === t.attr('initial') && o.val() === o.attr('initial') )
            s.removeClass('defaultbutton').addClass('button');
        else
            s.removeClass('button').addClass('defaultbutton');
    });
    </script>
    {/literal}
</div>