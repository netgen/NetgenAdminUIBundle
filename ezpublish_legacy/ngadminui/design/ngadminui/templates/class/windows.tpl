{* Groups window *}
<div id="node-tab-groups-content" class="tab-content{if $node_tab_index|ne('groups')} hide{else} selected{/if}">
    {include uri='design:class/groups.tpl'}
</div>

{* Templates window *}
<div id="node-tab-templates-content" class="tab-content{if $node_tab_index|ne('templates')} hide{else} selected{/if}">
    {include uri='design:class/templates.tpl'}
</div>

{* Translations window *}
<div id="node-tab-translations-content" class="tab-content{if $node_tab_index|ne('translations')} hide{else} selected{/if}">
    {include uri='design:class/translations.tpl'}
</div>