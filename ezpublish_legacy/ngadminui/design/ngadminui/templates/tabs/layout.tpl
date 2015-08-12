{def $layout = fetch( ngmore, layout, hash( node_id, $node.node_id, uri, $node.url_alias ) )}
{def $applied_layout_id = false()}

{if $layout}
    {set $applied_layout_id = $layout.id}
    {def $application_type = 'Inherited'}

    {if and( $layout.data_map.apply_layout_to_uri.has_content, concat( '/', $node.url_alias )|begins_with( $layout.data_map.apply_layout_to_uri.content ) )}
        {set $application_type = 'URI'}
    {else}
        {if $layout.data_map.apply_layout_to_objects.has_content}
            {foreach $layout.data_map.apply_layout_to_objects.content.relation_list as $relation_list_item}
                {if $relation_list_item.contentobject_id|eq( $node.contentobject_id )}
                    {set $application_type = 'Direct'}
                    {break}
                {/if}
            {/foreach}
        {/if}
    {/if}

    <table class="list" cellspacing="0">
        <tbody>
            <tr>
                <th>{'Sidebar name'|i18n( 'design/ngmore/node/view' )}</th>
                <th>{'Application type'|i18n( 'design/ngmore/node/view' )}</th>
                <th>&nbsp;</th>
            </tr>
            <tr>
                <td>{$layout.class_identifier|class_icon( 'small', $layout.name|wash )}&nbsp;{$layout.name|wash}</td>
                <td>{$application_type|i18n( 'design/ngmore/node/view' )}</td>
                <td><a href={$layout.main_node.url_alias|ezurl}>{'open'|i18n( 'design/ngmore/node/view' )}&nbsp;&raquo;</a></td>
            </tr>
        </tbody>
    </table>

    <br />

    <div class="block">
        <fieldset>
            <legend>{'Regions'|i18n( 'design/ngmore/node/view' )}</legend>

            <div style="display:none;">
                <p>{'Layout preview'|i18n( 'design/ngmore/node/view' )}</p>

                <div class="layout-preview">
                    <div class="top {if $layout.data_map.disable_top_region.content} disabled{else} enabled{/if}"><p>Top</p></div>
                    <div class="left {if $layout.data_map.disable_left_region.content} disabled{else} enabled{/if}"><p>Left</p></div>
                    <div class="content disabled"><p>Content</p></div>
                    <div class="right {if $layout.data_map.disable_right_region.content} disabled{else} enabled{/if}"><p>Right</p></div>
                    <div class="bottom {if $layout.data_map.disable_bottom_region.content} disabled{else} enabled{/if}"><p>Bottom</p></div>
                </div>
            </div>

            {foreach $layout.data_map.page.content.zones as $zone}
                <div class="block">
                    {if and( is_set( $zone.blocks ), $zone.blocks|count )}
                        <table class="list" cellspacing="0">
                            <tbody>
                                <tr>
                                    <th colspan="3">{ezini( $layout.data_map.page.content.zone_layout, 'ZoneName', 'zone.ini' )[$zone.zone_identifier]|wash} {if $layout.data_map[concat( 'disable_', $zone.zone_identifier, '_region' )].content} [{'Disabled'|i18n( 'design/ngmore/node/view' )}]{/if}</th>
                                </tr>
                                <tr>
                                    <th>{'Block type'|i18n( 'design/ngmore/node/view' )}</th>
                                    <th>{'Block view'|i18n( 'design/ngmore/node/view' )}</th>
                                    <th>{'Block name'|i18n( 'design/ngmore/node/view' )}</th>
                                </tr>

                                {foreach $zone.blocks as $block}
                                    <tr>
                                        <td>{ezini( $block.type, 'Name', 'block.ini' )|wash}</td>
                                        <td>{ezini( $block.type, 'ViewName', 'block.ini' )[$block.view]|wash}</td>
                                        <td>{$block.name|wash}</td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    {else}
                        <table class="list" cellspacing="0">
                            <tbody>
                                <tr><th>{ezini( $layout.data_map.page.content.zone_layout, 'ZoneName', 'zone.ini' )[$zone.zone_identifier]|wash} {if $layout.data_map[concat( 'disable_', $zone.zone_identifier, '_region' )].content} [{'Disabled'|i18n( 'design/ngmore/node/view' )}]{/if}</th></tr>
                                <tr><td>{'No blocks'|i18n( 'design/ngmore/node/view' )}</td></tr>
                            </tbody>
                        </table>
                    {/if}
                </div>
            {/foreach}
        </fieldset>
    </div>

    {undef $application_type}
{else}
    <p>{'No applied sidebar'|i18n( 'design/ngmore/node/view' )}</p>
{/if}

{undef $layout}

{def $all_layouts = fetch( ngmore, all_layouts, hash( node_id, $node.node_id, uri, $node.url_alias ) )}

{if $all_layouts|count|gt( 1 )}
    <div id="other-sidebars" class="block" style="display:none;">
        <fieldset>
            <legend>{'All other sidebars related to this node'|i18n( 'design/ngmore/node/view' )}</legend>

            <table class="list" cellspacing="0">
                <tbody>
                    <tr>
                        <th>{'Sidebar name'|i18n( 'design/ngmore/node/view' )}</th>
                        <th>{'Application type'|i18n( 'design/ngmore/node/view' )}</th>
                        <th>&nbsp;</th>
                    </tr>

                    {foreach $all_layouts as $layout}
                        {if $layout.id|ne( $applied_layout_id )}
                            {def $application_type = 'Inherited'}

                            {if and( $layout.data_map.apply_layout_to_uri.has_content, concat( '/', $node.url_alias )|begins_with( $layout.data_map.apply_layout_to_uri.content ) )}
                                {set $application_type = 'URI'}
                            {else}
                                {if $layout.data_map.apply_layout_to_objects.has_content}
                                    {foreach $layout.data_map.apply_layout_to_objects.content.relation_list as $relation_list_item}
                                        {if $relation_list_item.contentobject_id|eq( $node.contentobject_id )}
                                            {set $application_type = 'Direct'}
                                            {break}
                                        {/if}
                                    {/foreach}
                                {/if}
                            {/if}

                            <tr>
                                <td>{$layout.class_identifier|class_icon( 'small', $layout.name|wash )}&nbsp;{$layout.name|wash}</td>
                                <td>{$application_type|i18n( 'design/ngmore/node/view' )}</td>
                                <td><a href={$layout.main_node.url_alias|ezurl}>{'open'|i18n( 'design/ngmore/node/view' )}&nbsp;&raquo;</a></td>
                            </tr>

                            {undef $application_type}
                        {/if}
                    {/foreach}
                </tbody>
            </table>
        </fieldset>
    </div>
{/if}
