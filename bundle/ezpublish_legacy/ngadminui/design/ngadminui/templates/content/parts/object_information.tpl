<div class="objectinfo block">

    {* DESIGN: Header START *}

    <h3>{'Object information'|i18n( 'design/admin/content/history' )}</h3>

    {* DESIGN: Header END *}

    {* DESIGN: Content START *}
    <div class="box-content">

        {* Object ID *}
        <p>
            <label>{'ID'|i18n( 'design/admin/content/history' )}:</label>
            {$object.id}
        </p>

        {* Created *}
        <p>
            <label>{'Created'|i18n( 'design/admin/content/history' )}:</label>
            {if $object.published}
            {$object.published|l10n( shortdatetime )}<br />
            {$object.owner.name|wash}
            {else}
            {'Not yet published'|i18n( 'design/admin/content/history' )}
            {/if}
        </p>

        {* Modified *}
        <p>
            <label>{'Modified'|i18n( 'design/admin/content/history' )}:</label>
            {if $object.modified}
            {def $latest_version=$object.versions|extract_right(1)[0]}
            {$object.modified|l10n( shortdatetime )}<br />
            {$latest_version.creator.name|wash}
            {else}
            {'Not yet published'|i18n( 'design/admin/content/history' )}
            {/if}
        </p>

        {* Published version*}
        <p>
            <label>{'Published version'|i18n( 'design/admin/content/history' )}:</label>
            {if $object.published}
            {$object.published_version}
            {else}
            {'Not yet published'|i18n( 'design/admin/content/history' )}
            {/if}
        </p>

        {if and( is_set($manage_version_button), $manage_version_button )}
        {* Manage versions *}
            {if $object.versions|count|gt( 1 )}
                <input class="btn btn-default btn-sm" type="submit" name="VersionsButton" value="{'Manage versions'|i18n( 'design/admin/content/view/versionview' )}" title="{'View and manage (copy, delete, etc.) the versions of this object.'|i18n( 'design/admin/content/view/versionview' )}" />
            {else}
                <input class="btn btn-default btn-sm" type="submit" name="VersionsButton" value="{'Manage versions'|i18n( 'design/admin/content/view/versionview' )}" disabled="disabled" title="{'You cannot manage the versions of this object because there is only one version available (the one that is being displayed).'|i18n( 'design/admin/content/view/versionview' )}" />
            {/if}
        {/if}
        <input class="btn btn-default btn-sm" type="submit" name="PreviewButton" value="{'Preview'|i18n( 'design/admin/content/edit' )}" title="{'Preview the draft that is being edited.'|i18n( 'design/admin/content/edit' )}" />

    {* DESIGN: Content END *}
    </div>

</div>
