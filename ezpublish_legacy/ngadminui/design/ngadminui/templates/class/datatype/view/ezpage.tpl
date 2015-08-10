<div class="block">

    <div class="element">
        <label>{'Default layout:'|i18n( 'design/standard/class/datatype' )}</label>
        <p>
            {if ne( $class_attribute.data_text1, '' )}
                {$class_attribute.data_text1}
            {else}
                {'None'|i18n( 'design/standard/class/datatype' )}
            {/if}
        </p>
    </div>

</div>