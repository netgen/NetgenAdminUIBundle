Netgen Admin UI install instructions
------------------------------------

## Use Composer to install the package 

```
composer require netgen/admin-ui-bundle:^2.0
```

## Activate the Admin UI bundle along with other required bundles

Add the following in your `app/AppKernel.php` file:

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

## Import the `routing.yml` from the bundle into your main `routing.yml` file

Since this file overrides some built in routes, make sure you put it at the end of your `routing.yml`:

```
_netgen_admin_ui:
    resource: "@NetgenAdminUIBundle/Resources/config/routing.yml"
```

## Activate the legacy `ngadminui` extension along with other required extensions

Add the following in your central `site.ini.append.php` file (usually `ezpublish_legacy/settings/override/site.ini.append.php`):

```
[ExtensionSettings]
ActiveExtensions[]=ngadminui
ActiveExtensions[]=ngsymfonytools
ActiveExtensions[]=ezdemo
ActiveExtensions[]=ezjscore
ActiveExtensions[]=ezoe
```

## Run the installation wizard

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

Activate the generated legacy siteaccess in your central `site.ini.append.php` file (usually `ezpublish_legacy/settings/override/site.ini.append.php`):

```
[SiteAccessSettings]
AvailableSiteAccessList[]=NEW_SITEACCESS_NAME
```

## That's it

Clear the caches and make sure that **only your editors/administrators** have `user/login` policy to the new Admin UI siteaccess.

Admin UI will be accessible at `/NEW_SITEACCESS_NAME` URL of your installation.
