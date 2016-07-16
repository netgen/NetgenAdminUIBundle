Netgen Admin UI
---------------

Netgen Admin UI requires a fully functional eZ Publish 5 or eZ Platform with Legacy Bridge
so make sure you have it installed and fully configured before installing Netgen Admin UI.

## Use Composer to install the package: 

```
composer require netgen/admin-ui-bundle:^1.0
```

## Activate the bundle in your `app/AppKernel.php` file:

```php
public function registerBundles()
{
    ...

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

## Activate the legacy `ngadminui` extension in your `site.ini.append.php` file along with other required extensions:

```
[ExtensionSettings]
ActiveExtensions[]=ngadminui
ActiveExtensions[]=ezdemo
ActiveExtensions[]=ezjscore
ActiveExtensions[]=ezoe
```

## Create a new administration siteaccess with `legacy_mode: false` config and configure it:

Use the following config somewhere in your app to configure the templates for your new siteaccess.

Make sure to change `ngadminui` to the name of your Netgen Admin UI siteaccess:

```
parameters:
    netgen_admin_ui.ngadminui.is_admin_ui_siteaccess: true
    eztags.ngadminui.routing.enable_tag_router: false
    ezsettings.ngadminui.treemenu.http_cache: false

ezpublish:
    system:
        ngadminui:
            user:
                layout: 'NetgenAdminUIBundle::pagelayout_login.html.twig'
                login_template: 'NetgenAdminUIBundle:user:login.html.twig'

ez_publish_legacy:
    system:
        ngadminui:
            templating:
                view_layout: 'NetgenAdminUIBundle::pagelayout_legacy.html.twig'
                module_layout: 'NetgenAdminUIBundle::pagelayout_module.html.twig'
```

## Create a new legacy administration siteaccess and make sure you set the main design to `ngadminui`:

```
[DesignSettings]
SiteDesign=ngadminui
AdditionalSiteDesignList[]
AdditionalSiteDesignList[]=admin2
AdditionalSiteDesignList[]=admin
AdditionalSiteDesignList[]=standard
AdditionalSiteDesignList[]=base
```

Also, make sure that **only your editors/administrators** have `user/login` policy to the new administration siteaccess.
