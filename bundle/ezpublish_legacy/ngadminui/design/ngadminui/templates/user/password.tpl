{* Feedbacks. *}
{if $message}

{if or( $oldPasswordNotValid, $newPasswordNotMatch, $newPasswordTooShort )}
    <div class="alert alert-warning" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'The password could not be changed.'|i18n( 'design/admin/user/password' )}</h2>
        {if $oldPasswordNotValid}
            <ul>
                <li>{'The old password was either missing or incorrect.'|i18n( 'design/admin/user/password' )}</li>
                <li>{'Please retype the old password and try again.'|i18n( 'design/admin/user/password' )}</li>
            <ul>
        {/if}
        {if $newPasswordNotMatch}
            <ul>
                <li>{'The new passwords did not match.'|i18n( 'design/admin/user/password' )}</li>
                <li>{'Please retype the new passwords and try again.'|i18n( 'design/admin/user/password' )}</li>
            </ul>
        {/if}
        {if $newPasswordTooShort}
            <ul>
                <li>{'The password must be at least %1 characters long.'|i18n( 'design/admin/user/password','',array( ezini('UserSettings','MinPasswordLength') ) )}</li>
                <li>{'Please retype the new passwords and try again.'|i18n( 'design/admin/user/password' )}</li>
            </ul>
        {/if}
    </div>
{else}
    <div class="alert alert-success" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'The password was successfully changed.'|i18n( 'design/admin/user/password' )}</h2>
    </div>
{/if}
{/if}


<div class="panel">
    {* DESIGN: Header START *}
    <div class="panel-hl">
        <h3>{'Change password for %username'|i18n( 'design/admin/user/password',, hash( '%username', $userAccount.login ) )|wash}</h3>
    </div>

    {* DESIGN: Mainline *}
    {* DESIGN: Header END *}

    <div class="row">
        <div class="col-lg-6">
            <form name="Password" method="post" action={concat( $module.functions.password.uri, '/', $userID )|ezurl}>
                {* DESIGN: Content START *}

                {* Username. *}
                <div class="form-group">
                    <label>{'Username'|i18n( 'design/admin/user/password' )}:</label>
                    {$userAccount.login}
                </div>

                {* Old password. *}
                <div class="form-group">
                    <label>{'Old password'|i18n( 'design/admin/user/password' )}:</label>
                    <input class="form-control" id="pass" type="password" name="oldPassword" value="{$oldPassword|wash}" />
                </div>

                {* New password. *}
                <div class="form-group">
                    <label>{'New password'|i18n( 'design/admin/user/password' )}:</label>
                    <input class="form-control" type="password" name="newPassword" value="{$newPassword|wash}" />
                </div>

                {* Confirm new password. *}
                <div class="form-group">
                    <label>{'Confirm new password'|i18n( 'design/admin/user/password' )}:</label>
                    <input class="form-control" type="password" name="confirmPassword" value="{$confirmPassword|wash}" />
                </div>

                {* DESIGN: Content END *}

                <div class="controlbar">
                    {* DESIGN: Control bar START *}
                    <div class="block">
                        <input class="btn btn-primary" type="submit" name="OKButton" value="{'OK'|i18n( 'design/admin/user/password' )}" />
                        <input class="btn btn-default" type="submit" name="CancelButton" value="{'Cancel'|i18n( 'design/admin/user/password' )}" />
                    </div>
                </div>
                {* DESIGN: Control bar END *}
            </form>
        </div>
    </div>
</div>

{literal}
<script type="text/javascript">
    jQuery(function( $ )//called on document.ready
    {
        document.getElementById('pass').focus();
    });
</script>
{/literal}
