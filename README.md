Netgen Admin UI
---------------

Netgen Admin UI implements an alternate administration UI for eZ Platform, based on
eZ Publish Legacy administration interface.

Netgen Admin UI requires a fully functional eZ Publish 5 or eZ Platform with Legacy Bridge
so make sure you have it installed and fully configured before installing Netgen Admin UI.

## Use Composer to install the package: 

```
composer require netgen/admin-ui-bundle:^2.0
```

## Activate the bundle in your `app/AppKernel.php` file with other required bundles:

```php
public function registerBundles()
{
    ...

    $bundles[] = new Lolautruche\EzCoreExtraBundle\EzCoreExtraBundle();
    $bundles[] = new Netgen\Bundle\AdminUIBundle\NetgenAdminUIBundle();

    return $bundles;
}
```

## Install bundle assets

Use the following script to symlink bundle assets to `web/bundles` directory:

```
php app/console assets:install --symlink --relative
```

## Import the `routing.yml` from the bundle into your main `routing.yml` file:

Since this file overrides some built in routes, make sure you put it at the end of your `routing.yml`.

```
_netgen_admin_ui:
    resource: "@NetgenAdminUIBundle/Resources/config/routing.yml"
```

## Activate the legacy `ngadminui` extension in your central `site.ini.append.php` file along with other required extensions:

```
[ExtensionSettings]
ActiveExtensions[]=ngadminui
ActiveExtensions[]=ngsymfonytools
ActiveExtensions[]=ezdemo
ActiveExtensions[]=ezjscore
ActiveExtensions[]=ezoe
```

## Run the installation wizard:

Run the following command from your installation root to install Netgen Admin UI configuration and follow on-screen instructions:

```
$ php app/console ngadminui:install
```

This will install all required configuration in two places:

* `app/config/ngadminui.yml`
* `ezpublish_legacy/siteaccess/NEW_SITEACCESS_NAME`
 
where `NEW_SITEACCESS_NAME` will be the name of the new siteaccess you selected during the installation wizard.

## Activate the generated configuration

The generated configuration is not activated automatically, so you need to activate it by yourself:

Import `app/config/ngadminui.yml` in your `app/config/ezplatform.yml`:

```
imports:
    - { resource: ngadminui.yml }
```

Activate the generated legacy siteaccess in your central `site.ini.append.php` file:

```
[SiteAccessSettings]
AvailableSiteAccessList[]=NEW_SITEACCESS_NAME
```

Finally, make sure that **only your editors/administrators** have `user/login` policy to the new Admin UI siteaccess.
