{def $search_node_id = first_set( $search_subtree_array[0], $module_result.path[0].node_id, 1 )
     $search_title = "Search in all content"|i18n( 'design/admin/pagelayout' )
     $section_id = -1}
{if ezhttp_hasvariable( 'SectionID', 'get' )}
    {set $section_id = ezhttp( 'SectionID', 'get' )}
{/if}


<form action={'/content/search/'|ezurl} method="get" class="navbar-form navbar-form-sm navbar-left shift" ui-shift="prependTo" data-target=".navbar-collapse" role="search" ng-controller="TypeaheadDemoCtrl">
          <div class="form-group">
            <div class="input-group">
    {if $ui_context_edit}
        <input id="searchtext" name="SearchText" class="form-control input-sm bg-light no-border rounded padder disabled" type="text" size="20" value="{if is_set( $search_text )}{$search_text|wash}{/if}" disabled="disabled" title="{$search_title|wash}" />
        <span class="input-group-btn">
        <button id="searchbutton" name="SearchButton" type="submit" class="btn btn-sm bg-light rounded button-disabled hide" disabled="disabled"><i class="fa fa-search"></i></button>
        </span>
    {else}
        {if $search_node_id|gt( 1 )}
            {set $search_title = "Search in '%node'"|i18n( 'design/admin/pagelayout',, hash( '%node', fetch( 'content', 'node', hash( 'node_id', $search_node_id ) ).name ) )}
        {/if}
        <input id="searchtext" name="SearchText" class="form-control input-sm bg-light no-border rounded padder         " type="text" size="20" value="{if is_set( $search_text )}{$search_text|wash}{/if}" title="{$search_title|wash}" />
        <span class="input-group-btn">
        <button id="searchbutton" name="SearchButton" type="submit" class="btn btn-sm bg-light rounded"><i class="fa fa-search"></i></button>
        </span>
        {if eq( $ui_context, 'browse' ) }
            <input name="Mode" type="hidden" value="browse" />
            <input name="BrowsePageLimit" type="hidden" value="{min( ezpreference( 'admin_list_limit' ), 3)|choose( 10, 10, 25, 50 )}" />
        {/if}

    {/if}
</form>
</div>
</div>

<script type="text/javascript">

{literal}
(function($){
    if ( !document.getElementById('searchbuttonfield') )return;

    $('#searchbuttonfield').click(function(){
        if ( $('#searchtext').val() === $('#searchtext').attr('title') )return;
          $('#searchbutton').click();
    });
    $('#searchscope').click(function(){
        $('#searchscope-pane').addClass('active');
    });
    $('#searchscope-pane-close').click(function(){
        $('#searchscope-pane').removeClass('active');
    });
    $('input:radio[name=SubTreeArray]').change( function() {
        $('#searchtext').attr('value', $(this).attr('title'));
        $('#searchtext').attr('title', $(this).attr('title'));
    } );
})( jQuery );
{/literal}
</script>
{undef $search_node_id $section_id}
