
<div class="controlbar">
{* DESIGN: Control bar START *}


{if $current_step.next_step}
    <div class="block">
        <input class="button" type="submit" name="NextStepButton" value="{'Next %arrowright'|i18n( 'design/admin/package',, hash( '%arrowright', '&raquo;' ) )}" />
    </div>
{else}
    <div class="block">
        <input class="button" type="submit" name="NextStepButton" value="{'Continue'|i18n( 'design/admin/package' )}" />
    </div>
{/if}


{* DESIGN: Control bar END *}
</div>
