Netgen More Admin UI installation instructions
----------------------------------------------

## Use Composer to install the package:

```
composer require netgen/more-admin-ui-bundle:~0.9
```

## Activate the bundle in your `app/AppKernel.php` file:

```php
public function registerBundles()
{
    ...

    $bundles[] = new Netgen\Bundle\MoreAdminUIBundle\NetgenMoreAdminUIBundle();

    return $bundles;
}
```

## Install bundle assets

Use the following script to symlink bundle assets to `web/bundles` directory:

```
php app/console assets:install --symlink --relative
```

## Import the `ezpublish.yml` from the bundle into your main `ezplatform.yml` file:

```
imports:
    - { resource: '@NetgenMoreAdminUIBundle/Resources/config/ezpublish.yml' }
```

## Import the `routing.yml` from the bundle into your main `routing.yml` file:

Since this file overrides some built in routes, make sure you put it at the end of your `routing.yml`.

```
_netgen_more_admin_ui:
    resource: "@NetgenMoreAdminUIBundle/Resources/config/routing.yml"
```

## Activate the legacy `ngadminui` extension in your `site.ini.append.php` file

```
[ExtensionSettings]
ActiveExtensions[]=ngadminui
```

## Create a new administration siteaccess with `legacy_mode: false` config and configure it:

Use the following config to configure the templates in your new siteaccess. This config usually goes
into your `ezpublish.yml` file imported from your **project bundle**.
(change `administration_group` to something more appropriate for your installation):

```
ezpublish:
    system:
        administration_group:
            user:
                layout: 'NetgenMoreAdminUIBundle::pagelayout_login.html.twig'
                login_template: 'NetgenMoreAdminUIBundle:user:login.html.twig'

ez_publish_legacy:
    system:
        administration_group:
            templating:
                view_layout: 'NetgenMoreAdminUIBundle::pagelayout_legacy.html.twig'
                module_layout: 'NetgenMoreAdminUIBundle::pagelayout_module.html.twig'
```

Use the following config to configure the pagelayout and some other required settings in your new
siteaccess. This config usually goes into your `parameters.yml` file imported from
your **project bundle**. (change `administration_group` to something more appropriate for your installation):

```
ngmore.administration_group.pagelayout: 'NetgenMoreAdminUIBundle::pagelayout.html.twig'
ngmore.administration_group.content_view.show_invisible_locations: true
ngmore.administration_group.content_view.handle_legacy_fallback_error_result: false
eztags.administration_group.routing.enable_tag_router: false
ezsettings.administration_group.treemenu.http_cache: false
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
