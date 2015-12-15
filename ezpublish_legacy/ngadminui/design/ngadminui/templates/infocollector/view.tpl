<form name="objects" method="post" action={concat( '/infocollector/collectionlist/', $collection.contentobject_id )|ezurl}>

    {* DESIGN: Header START *}
    <div class="box-header">
        <h1 class="context-title">
            {'Collection #%collection_id for <%object_name>'|i18n( 'design/admin/infocollector/view',, hash( '%collection_id', $collection.id, '%object_name', $collection.object.name ) )|wash}
            <span class="small-info">{'Last modified'|i18n( 'design/admin/infocollector/view' )}: {$collection.created|l10n( shortdatetime )}, {if $collection.creator} {$collection.creator.contentobject.name|wash} {else} {'Unknown user'|i18n( 'design/admin/infocollector/view' )} {/if}</span>
        </h1>
        {* DESIGN: Mainline *}
        <div class="header-mainline"></div>
    {* DESIGN: Header END *}
    </div>

    {* DESIGN: Content START *}
    <div class="panel">
        <div class="context-attributes infocollector-attributes">
            {section var=CollectedAttributes loop=$collection.attributes}
                <div class="block">
                    <label>{$CollectedAttributes.item.contentclass_attribute_name|wash}:</label>
                    <span class="attribute">{attribute_result_gui view=info attribute=$CollectedAttributes.item}</span>
                </div>
            {/section}
        </div>

        {* DESIGN: Content END *}

        {* Buttons. *}
        <div class="controlbar">
        {* DESIGN: Control bar START *}
            <input class="btn btn-primary" type="submit" name="RemoveCollectionsButton" value="{'Remove'|i18n( 'design/admin/infocollector/view' )}" title="{'Remove collection.'|i18n( 'design/admin/infocollector/view' )}" />
            <input type="hidden" name="CollectionIDArray[]" value="{$collection.id}" />
        </div>
        {* DESIGN: Control bar END *}

    </div>
</form>
