{if fetch( 'user', 'has_access_to', hash( 'module', 'setup', 'function', 'managecache' ) )}

<div id="clearcache-tool" class="clearcache-tool">
	{* DESIGN: Header START *}

	    {if and( ne( $ui_context, 'edit' ), ne( $ui_context, 'browse' ) )}
	        <h4>{'Clear cache'|i18n( 'design/admin/pagelayout' )}</h4>
	    {else}
		    {if eq( $ui_context, 'edit' )}
		       <h4><span class="disabled">{'Clear cache'|i18n( 'design/admin/pagelayout' )}</span></h4>
		    {else}
		       <h4>{'Clear cache'|i18n( 'design/admin/pagelayout' )}</h4>
		    {/if}
	    {/if}
    
	{* DESIGN: Header END *}


	{* DESIGN: Content START *}
	    {include uri='design:setup/clear_cache.tpl'}
	{* DESIGN: Content END *}

</div>

{/if}