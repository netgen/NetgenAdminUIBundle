{* (Pre)view window *}
<div id="node-tab-view-content" class="tab-content{if $node_tab_index|ne('view')} hide{else} selected{/if}">
    <div class="wrapper clearfix">
    {include uri='design:preview.tpl'}
    </div>
</div>

{* Subitems window *}
<div id="node-tab-subitems-content" class="tab-content{if $node_tab_index|ne('subitems')} hide{else} selected{/if}">
    {include uri='design:subitems.tpl'}
<div class="break"></div>
</div>

{* Translations window *}
<div id="node-tab-translations-content" class="tab-content{if $node_tab_index|ne('translations')} hide{else} selected{/if}">
    <div class="wrapper clearfix">
    {include uri='design:translations.tpl'}
    </div>
</div>

{* Locations window *}
<div id="node-tab-locations-content" class="tab-content{if $node_tab_index|ne('locations')} hide{else} selected{/if}">
    <div class="wrapper clearfix">
    {include uri='design:locations.tpl'}
    </div>
</div>

{* Relations window *}
<div id="node-tab-relations-content" class="tab-content{if $node_tab_index|ne('relations')} hide{else} selected{/if}">
    <div class="wrapper clearfix">
    {include uri='design:relations.tpl'}
    </div>
</div>



{include uri='design:windows_extratabs.tpl'}
