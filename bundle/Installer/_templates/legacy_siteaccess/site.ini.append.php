<?php /* #?ini charset="utf-8"?

[SiteSettings]
DefaultPage=content/dashboard
LoginPage=custom

[SiteAccessSettings]
RequireUserLogin=true
RelatedSiteAccessList[]
{% for siteAccess in relatedSiteAccessList %}
RelatedSiteAccessList[]={{ siteAccess }}
{% endfor %}
ShowHiddenNodes=true

[DesignSettings]
SiteDesign=ngadminui
AdditionalSiteDesignList[]
AdditionalSiteDesignList[]=admin2
AdditionalSiteDesignList[]=admin
AdditionalSiteDesignList[]=standard
AdditionalSiteDesignList[]=base

[RegionalSettings]
Locale={{ siteAccessLocale }}
ContentObjectLocale={{ siteAccessLocale }}
ShowUntranslatedObjects=enabled
SiteLanguageList[]
{% for languageCode in siteLanguageList %}
SiteLanguageList[]={{ languageCode }}
{% endfor %}
TextTranslation=disabled

[ContentSettings]
CachedViewPreferences[full]=admin_navigation_content=1;admin_children_viewmode=list;admin_list_limit=1
TranslationList={{ translationList }}
RedirectAfterPublish=node

[TemplateSettings]
Debug=disabled
*/
