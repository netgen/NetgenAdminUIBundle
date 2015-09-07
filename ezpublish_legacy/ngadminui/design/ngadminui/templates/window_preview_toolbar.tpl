{* DESIGN: Control bar START *}
<div class="node-control-toolbar">

    <form method="post" action={'content/action'|ezurl} class="btn-toolbar">
        <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
        <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
        <div class="form-inline">
            <div class="btn-group">
                {*
                    {def $can_create_languages = $node.object.can_create_languages
                        $languages            = fetch( 'content', 'prioritized_languages' )}

                    {if $node.can_edit}
                        {if and(eq( $languages|count, 1 ), is_set( $languages[0] ) )}
                            <input name="ContentObjectLanguageCode" value="{$languages[0].locale}" type="hidden" />
                        {else}
                            <select name="ContentObjectLanguageCode" class="form-control">
                                {foreach $node.object.can_edit_languages as $language}
                                    <option value="{$language.locale|wash}"{if $language.locale|eq($node.object.current_language)} selected="selected"{/if}>{$language.name|wash}</option>
                                {/foreach}
                                {if gt( $can_create_languages|count, 0 )}
                                    <option value="">{'New translation'|i18n( 'design/admin/node/view/full')}</option>
                                {/if}
                            </select>
                        {/if}
                    {else}
                        <select name="ContentObjectLanguageCode" class="form-control" disabled="disabled">
                            <option value="">{'Not available'|i18n( 'design/admin/node/view/full')}</option>
                        </select>
                    {/if}
                    {undef $can_create_languages}
                *}
                
                {* Edit button. *}
                <button class="btn btn-primary" type="submit" name="EditButton" {if $node.can_edit}title="{'Edit the contents of this item.'|i18n( 'design/admin/node/view/full' )}"{else}title="{'You do not have permission to edit this item.'|i18n( 'design/admin/node/view/full' )}" disabled="disabled"{/if}><i class="fa fa-pencil-square-o"></i>&nbsp; {'Edit'|i18n( 'design/admin/node/view/full' )}</button>
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><strong>...</strong></button>
                    <ul class="dropdown-menu dropdown-menu-right">
                        {* Move button. *}
                        {if $node.can_move}
                            <li><input type="submit" name="MoveNodeButton" value="{'Move'|i18n( 'design/admin/node/view/full' )}" title="{'Move this item to another location.'|i18n( 'design/admin/node/view/full' )}" /></li>
                        {else}
                            <li><input class="disabled" type="submit" name="MoveNodeButton" value="{'Move'|i18n( 'design/admin/node/view/full' )}" title="{'You do not have permission to move this item to another location.'|i18n( 'design/admin/node/view/full' )}" disabled="disabled" /></li>
                        {/if}

                        {* Remove button. *}
                        {if $node.can_remove}
                            <li><input type="submit" name="ActionRemove" value="{'Remove'|i18n( 'design/admin/node/view/full' )}" title="{'Remove this item.'|i18n( 'design/admin/node/view/full' )}" /></li>
                        {else}
                            <li><input class="disabled" type="submit" name="ActionRemove" value="{'Remove'|i18n( 'design/admin/node/view/full' )}" title="{'You do not have permission to remove this item.'|i18n( 'design/admin/node/view/full' )}" disabled="disabled" /></li>
                        {/if}
                        <li role="separator" class="divider"></li>
                        {* Link to manage versions *}
                        <li><a href={concat("content/history/", $node.contentobject_id )|ezurl} title="{'View and manage (copy, delete, etc.) the versions of this object.'|i18n( 'design/admin/content/edit' )}">{'Manage versions'|i18n( 'design/admin/content/edit' )}</a></li>
                    </ul>
                </div>
            </div>
        </div>


        <!--div class="btn-group">
            <button class="btn btn-default" data-toggle="tooltip" data-placement="bottom" data-title="Refresh" data-original-title="" title=""><i class="fa fa-refresh"></i></button>
        </div>

        <div class="btn-group dropdown">
            <button class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                <span class="dropdown-label">More</span>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu text-left text-sm">
                <li><a ui-sref="app.mail.list()">Unread</a></li>
                <li><a ui-sref="app.mail.list()">Starred</a></li>
            </ul>
        </div-->


    </form>
</div>
{* DESIGN: Control bar END *}
