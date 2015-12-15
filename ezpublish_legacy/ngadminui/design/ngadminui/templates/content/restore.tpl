<form action={concat( 'content/restore/', $object.id )|ezurl} method="post" name="ObjectRestore">

    <div class="context-block">

        {* DESIGN: Header START *}<div class="box-header">

        <h1 class="context-title">{'Object retrieval'|i18n( 'design/admin/content/restore' )|wash}</h1>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}</div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            <div class="block">
                <p>{'Specify the location where you want to restore < %name >.'|i18n( 'design/admin/node/removeobject',, hash( '%name', $object.name ) )|wash}</p>
            </div>

            <div class="block">
                {if $location}
                <div class="radio">
                    <label title="{'The object will be restored at its original location.'|i18n( 'design/admin/content/restore' )|wash}"><input type="radio" name="RestoreType" value="1" checked="checked" title="{'The object will be restored at its original location.'|i18n( 'design/admin/content/restore' )|wash}" />&nbsp;{'Restore at original location (below < %nodeName >).'|i18n( 'design/admin/content/restore',, hash( '%nodeName', $location.name ) )|wash}</label>
                </div>
                <div class="radio">
                    <label title="{'The system will prompt you to specify a location by browsing the tree.'|i18n( 'design/admin/content/restore' )|wash}"><input type="radio" name="RestoreType" value="2" title="{'The system will prompt you to specify a location by browsing the tree.'|i18n( 'design/admin/content/restore' )|wash}" />&nbsp;{'Select a location.'|i18n( 'design/admin/content/restore' )}</label>
                </div>
                    {else}
                <div class="radio">
                    <label><input type="radio" disabled="disabled" name="RestoreType" value="1" />&nbsp;{'Restore at original location (unavailable).'|i18n( 'design/admin/content/restore' )}</label>
                </div>
                <div class="radio">
                    <label title="{'The system will prompt you to specify a location by browsing the tree.'|i18n( 'design/admin/content/restore' )|wash}"><input type="radio" name="RestoreType" value="2" checked="checked" title="{'The system will prompt you to specify a location by browsing the tree.'|i18n( 'design/admin/content/restore' )|wash}" />&nbsp;{'Select a location.'|i18n( 'design/admin/content/restore' )}</label>
                </div>
                {/if}
            </div>

            {* DESIGN: Content END *}

            <div class="controlbar">
                {* DESIGN: Control bar START *}
                <input class="btn btn-primary" type="submit" name="ConfirmButton" value="{'OK'|i18n( 'design/admin/content/restore' )}" title="{'Continue restoring < %name >.'|i18n( 'design/admin/content/restore',, hash( '%name', $object.name ) )|wash}" />
                <input type="submit" class="btn btn-default" name="CancelButton" value="{'Cancel'|i18n( 'design/admin/content/restore' )}" title="{'Do not restore < %name > and return to trash.'|i18n( 'design/admin/content/restore',, hash( '%name', $object.name ) )|wash}" />
            </div>
            {* DESIGN: Control bar END *}
        </div>

    </div>

</form>
