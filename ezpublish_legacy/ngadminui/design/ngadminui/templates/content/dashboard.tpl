{* set scope=global persistent_variable=hash('extra_menu', false()) *}

<div class="context-block content-dashboard">
    {* DESIGN: Content START *}
    <div class="panel">
        <div class="row">
            {def $right_blocks = array()}

            <div class="col-lg-6">
                {foreach $blocks as $block sequence array( 'left', 'right' ) as $position}

                    {if $position|eq('left')}
                        <div class="context-block">
                            {if $block.template}
                                {include uri=concat( 'design:', $block.template )}
                            {else}
                                {include uri=concat( 'design:dashboard/', $block.identifier, '.tpl' )}
                            {/if}
                        </div>
                    {else}
                       {append-block variable=$right_blocks}
                            <div class="context-block">
                                {if $block.template}
                                    {include uri=concat( 'design:', $block.template )}
                                {else}
                                    {include uri=concat( 'design:dashboard/', $block.identifier, '.tpl' )}
                                {/if}
                            </div>
                        {/append-block}
                    {/if}
                {/foreach}
            </div>
            <div class="col-lg-6">
                {$right_blocks|implode('')}
            </div>
        </div>
    </div>

    {* DESIGN: Content END *}

</div>
