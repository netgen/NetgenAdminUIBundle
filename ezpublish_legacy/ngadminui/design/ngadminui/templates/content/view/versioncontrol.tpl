<form method="post" id="versioncontrol" class="language-switch form-inline" action={concat( 'content/versionview/', $object.id, '/', $version.version, '/', $language, '/', $from_language )|ezurl}>
    {* Translation *}
    {if fetch( content, translation_list )|count|gt( 1 )}
        <select class="form-control" id="SelectedLanguage" name="SelectedLanguage" onchange="this.form.submit()">
            {def $locale_object = false}
            {foreach $translation_list as $locale_code}
                {set $locale_object = $locale_code|locale()}
                <option name="SelectedLanguage" value="{$locale_code}" {if eq( $locale_code, $object_languagecode )}selected="selected"{/if}>
                    {if $locale_object.is_valid}
                        {$locale_object.intl_language_name|shorten( 32 )}
                    {else}
                        {'%1 (No locale information available)'|i18n( 'design/admin/content/view/versionview',, array( $locale_code ) )}
                    {/if}
                </option>
            {/foreach}
        </select>
    {/if}

    {* Location }
    {section show=$version.node_assignments|count|gt( 0 )}
        <select class="form-control" id="SelectedPlacement" name="SelectedPlacement" onchange="this.form.submit()">
            {section var=Locations loop=$version.node_assignments}
                <option name="SelectedPlacement" value="{$Locations.item.id}" {if eq( $Locations.item.id, $placement )}selected="selected"{/if}>{$Locations.item.parent_node_obj.name|wash}</option>
            {/section}
        </select>
    {/section*}

    {* Design *}
    {if $site_access_locale_map|count|gt( 1 )}
        <select class="form-control" id="SelectedSiteAccess" name="SelectedSiteAccess" onchange="this.form.submit()">
            {foreach $site_access_locale_map as $related_site_access => $related_site_access_locale}
                <option name="SelectedSiteAccess" value="{$related_site_access}" {if eq( $related_site_access, $siteaccess )}selected="selected"{/if}>{$related_site_access|wash}</option>
            {/foreach}
        </select>
    {else}
        <input type="hidden" name="SelectedSiteAccess" value="{$site_designs[0]}" />
    {/if}

    <input type="hidden" name="ChangeSettingsButton" value="{'Update view'|i18n( 'design/admin/content/view/versionview' )}" title="{'View the version that is currently being displayed using the selected language, location and design.'|i18n( 'design/admin/content/view/versionview' )}" />
    <input type="hidden" name="ezxform_token" value="@$ezxFormToken@" />
</form>
