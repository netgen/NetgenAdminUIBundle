{default parent_group_id=0
         current_depth=0
         offset=$view_parameters.offset item_limit=10
         summary_indentation=10}

{* Status 1 corresponds to eZCollaborationItem::STATUS_ACTIVE *}
{def $status = array( 1 )}
{let group_tree=fetch("collaboration","group_tree",hash("parent_group_id",$parent_group_id))
     latest_item_count=fetch("collaboration","item_count",hash("is_active",true(),"parent_group_id",$parent_group_id,"status",$status))}


{* DESIGN: Header START *}
<div class="box-header">

    <h1 class="context-title">{'Item list'|i18n( 'design/admin/collaboration/view/summary' )}</h1>

    {* DESIGN: Mainline *}<div class="header-mainline"></div>

    {* DESIGN: Header END *}
</div>

{* DESIGN: Content START *}
<div class="box-content panel">

    {if $latest_item_count}

    {include uri="design:collaboration/item_list.tpl" item_list=fetch( "collaboration", "item_list", hash( "limit", $item_limit, "offset", $offset, "is_active", true(), "status", $status ) )}

    {include name=Navigator
             uri='design:navigator/google.tpl'
             page_uri="/collaboration/view/summary"
             item_count=$latest_item_count
             view_parameters=$view_parameters
             item_limit=$item_limit}

    {else}
    <div class="block">
        <p>{"No new items to be handled."|i18n('design/admin/collaboration/view/summary')}</p>
    </div>
    {/if}

    {* DESIGN: Content END *}



    {* DESIGN: Header START *}


    <h2>{'Group tree'|i18n( 'design/admin/collaboration/view/summary' )}</h2>



    {* DESIGN: Header END *}


    {* DESIGN: Content START *}


      {include uri="design:collaboration/group_tree.tpl" group_tree=$group_tree current_depth=$current_depth
               summary_indentation=$summary_indentation parent_group_id=$parent_group_id}

    {* DESIGN: Content END *}

</div>

{/let}

{/default}


