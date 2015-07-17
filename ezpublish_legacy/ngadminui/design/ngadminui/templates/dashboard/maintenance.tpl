<div class="dashboard-logo"></div>
<div class="maintenance-text">
    <h2>{'Software update and Maintenance'|i18n( 'design/admin/dashboard/maintenance' )}</h2>

    <p>{'Your installation: <span class="highlight">%1</span>'|i18n( 'design/admin/dashboard/maintenance', , array( fetch( 'setup', 'version' ) ) )}</p>
    <p>{'You are running <span class="highlight">%edition</span>, it might not be up to date with the latest hot fixes and service packs. Contact <a href="%ez_link">eZ Systems</a> for more infomation.'|i18n( 'design/admin/dashboard/maintenance', , hash( '%edition', fetch( 'setup', 'edition' ), '%ez_link', "http://ez.no" ) )}</p>
</div>
