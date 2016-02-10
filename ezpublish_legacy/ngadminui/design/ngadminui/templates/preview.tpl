<div class="panel content-preview">
    {* Content (pre)view in content window. *}
    {def $custom_actions = $node.object.content_action_list}
    {if $custom_actions}
        <form method="post" action={'content/action'|ezurl}>
            <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
    {/if}

    {node_view_gui content_node=$node view='admin_preview'}

    {if $custom_actions}
            <div class="button-right">
                {* Custom content action buttons. *}
                {foreach $custom_actions as $custom_action}
                    <input class="btn btn-default" type="submit" name="{$custom_action.action}" value="{$custom_action.name}" />
                {/foreach}
            </div>
            <div class="break"></div>
        </form>
    {/if}
    <ul class="node-info-list">
        <li>
            <label>{'Created'|i18n( 'design/admin/node/view/full' )}:</label>
            <p>{$node.object.published|l10n( shortdatetime )}<br />
            <a href={$node.object.owner.main_node.url_alias|ezurl}>{$node.object.owner.name|wash}</a></p>
        </li>
        <li>
            <label>{'Last modified'|i18n( 'design/admin/node/view/full' )}:</label>
            <p>{$node.object.modified|l10n(shortdatetime)} <br /><a href={$node.object.current.creator.main_node.url_alias|ezurl}>{$node.object.current.creator.name|wash}</a><br />{'Versions count'|i18n( 'design/admin/node/view/full' )}: {$node.object.versions|count()}</p>
        </li>
        <li>
            <label>{'Node ID'|i18n( 'design/admin/node/view/full' )}:</label>
            <p>{$node.node_id}</p>
        </li>
        <li>
            <label>{'Object ID'|i18n( 'design/admin/node/view/full' )}:</label>
            <p>{$node.object.id}</p>
        </li>
        <li>
            <label>{'Section'|i18n( 'design/admin/node/view/full' )}:</label>
            <form name="changesection" id="changesection" method="post" action={concat( 'content/edit/', $node.object.id )|ezurl}>
                <input type="hidden" name="RedirectRelativeURI" value="{$node.url_alias|wash}" />
                <input type="hidden" name="ChangeSectionOnly" value="1" />
                <div class="input-group">
                    <select id="selected-section-id" class="form-control input-sm" name="SelectedSectionId">
                    {foreach $node.object.allowed_assign_section_list as $allowed_assign_section}
                        {if eq( $allowed_assign_section.id, $node.object.section_id )}
                        <option value="{$allowed_assign_section.id}" selected="selected">{$allowed_assign_section.name|wash}</option>
                        {else}
                        <option value="{$allowed_assign_section.id}">{$allowed_assign_section.name|wash}</option>
                        {/if}
                    {/foreach}
                    </select>
                    <span class="input-group-btn">
                        <input id="tab-details-set-section" type="submit" value="{'Set'|i18n( 'design/admin/node/view/full' )}" name="SectionEditButton" class="btn btn-default btn-sm" />
                    </span>
                </div>
            </form>
        </li>
        <li>
            <label>{'Node Remote ID'|i18n( 'design/admin/node/view/full' )}:</label>
            <p>{$node.remote_id|wash}</p>
        </li>
        <li>
            <label>{'Object Remote ID'|i18n( 'design/admin/node/view/full' )}:</label>
            <p>{$node.object.remote_id|wash}</p>
        </li>
        {if $states_count}
            <li>
                {* States window. *}
                <form name="statesform" method="post" action={'state/assign'|ezurl}>
                    <input type="hidden" name="ObjectID" value="{$node.object.id}" />
                    <input type="hidden" name="RedirectRelativeURI" value="{$node.url_alias|wash}" />

                    <table id="tab-details-states-list" class="list" cellspacing="0" summary="{'States and their states groups for current object.'|i18n( 'design/admin/node/view/full' )}">
                        <tr>
                            <th>
                                {'Content state'|i18n( 'design/admin/node/view/full' )}
                            </th>
                        </tr>
                        {foreach $states as $allowed_assign_state_info sequence array( 'bglight', 'bgdark' ) as $sequence}
                            <tr>
                                <td>
                                    <p>{$allowed_assign_state_info.group.current_translation.name|wash}</p>
                                    <label>{'Available states'|i18n( 'design/admin/node/view/full' )}</label>
                                    <select class="form-control input-sm" name="SelectedStateIDList[]" {if $allowed_assign_state_info.states|count|eq(1)}disabled="disabled"{/if}>
                                        {foreach $allowed_assign_state_info.states as $state}
                                            <option value="{$state.id}" {if $node.object.state_id_array|contains($state.id)}selected="selected"{/if}>{$state.current_translation.name|wash}</option>
                                        {/foreach}
                                    </select>
                                </td>
                            </tr>
                        {/foreach}
                    </table>

                    <input class="btn btn-default btn-sm" type="submit" id="tab-details-set-states" value="{'Set states'|i18n( 'design/admin/node/view/full' )}" name="AssignButton" class="button" title="{'Apply states from the list above.'|i18n( 'design/admin/node/view/full' )}" />

                </form>
            </li>
        {/if}
    </ul>
</div>
<script type="text/javascript">
{literal}
(function( $ )
{
    $('#tab-details-states-list select').change(function()
    {
        var btn = $('#tab-details-set-states');
        if ( !btn.attr('disabled') )
        {
            btn.removeClass('button').removeClass('btn-default').addClass('btn-primary');
        }
    });
    $('#selected-section-id').change(function()
    {
        var btn = $('#tab-details-set-section');
        if ( !btn.attr('disabled') )
        {
            btn.removeClass('button').removeClass('btn-default').addClass('btn-primary');
        }
    });
})( jQuery );
{/literal}
</script>
