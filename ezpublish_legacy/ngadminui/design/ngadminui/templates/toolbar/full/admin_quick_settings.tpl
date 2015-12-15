{if fetch( 'user', 'has_access_to', hash( 'module', 'setup', 'function', 'setup' ) )}

{*<div id="quicksettings-tool" class="quicksettings-tool">

    {if eq( $ui_context, 'edit' )}
        <h4><span class="disabled">{'Quick settings'|i18n( 'design/admin/pagelayout' )}</span></h4>
       {else}
        <h4>{'Quick settings'|i18n( 'design/admin/pagelayout' )}</h4>
       {/if}

    {let siteaccess        = ezpreference( 'admin_quicksettings_siteaccess' )
         select_siteaccess = true}
        {include uri='design:setup/quick_settings.tpl'}
    {/let}
</div>*}

{/if}
