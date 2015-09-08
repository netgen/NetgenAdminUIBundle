{def $search_node_id = first_set( $search_subtree_array[0], $module_result.path[0].node_id, 1 )
     $search_title = "Search in all content"|i18n( 'design/admin/pagelayout' )
     $section_id = -1}
{if ezhttp_hasvariable( 'SectionID', 'get' )}
    {set $section_id = ezhttp( 'SectionID', 'get' )}
{/if}


<form action={'/content/search/'|ezurl} method="get" class="navbar-form search-form" role="search">
    {if $ui_context_edit}
        <input id="searchText" name="searchText" class="search-input disabled" type="text" size="20" value="{if is_set( $search_text )}{$search_text|wash}{/if}" disabled="disabled" title="{$search_title|wash}" />
        <button id="searchButton" name="SearchButton" type="submit" class="search-btn disabled" disabled="disabled"><i class="fa fa-search"></i></button>
    {else}
        {if $search_node_id|gt( 1 )}
            {set $search_title = "Search in '%node'"|i18n( 'design/admin/pagelayout',, hash( '%node', fetch( 'content', 'node', hash( 'node_id', $search_node_id ) ).name ) )}
        {/if}
        <input id="searchText" name="searchText" class="search-input" type="text" value="{if is_set( $search_text )}{$search_text|wash}{/if}" title="{$search_title|wash}" placeholder="Search content..." />
        <button id="searchButton" name="SearchButton" type="submit" class="search-btn"><i class="fa fa-search"></i></button>
        {if eq( $ui_context, 'browse' ) }
            <input name="Mode" type="hidden" value="browse" />
            <input name="BrowsePageLimit" type="hidden" value="{min( ezpreference( 'admin_list_limit' ), 3)|choose( 10, 10, 25, 50 )}" />
        {/if}

    {/if}
</form>

<script type="text/javascript">

{literal}
(function($){
    if ( !document.getElementById('searchbuttonfield') )return;

    $('#searchbuttonfield').click(function(){
        if ( $('#searchText').val() === $('#searchText').attr('title') )return;
          $('#searchButton').click();
    });
    $('#searchscope').click(function(){
        $('#searchscope-pane').addClass('active');
    });
    $('#searchscope-pane-close').click(function(){
        $('#searchscope-pane').removeClass('active');
    });
    $('input:radio[name=SubTreeArray]').change( function() {
        $('#searchText').attr('value', $(this).attr('title'));
        $('#searchText').attr('title', $(this).attr('title'));
    } );
})( jQuery );
{/literal}
</script>
{undef $search_node_id $section_id}
