<div class="block">
    <fieldset>
        <label>{'Tags search'|i18n( 'extension/eztags/tags/search' )}</label>
        <form class="form-inline" method="get" action={'tags/search'|ezurl}>
            <div class="form-group">
                <div class="input-group">
                    <input class="form-control" id="tags_search_text" name="TagsSearchText" type="text" value="" />
                    <span class="input-group-btn">
                        {if is_set( $tag.id )}
                            <input type="hidden" value="{$tag.id}" name="TagsSearchSubTree" />
                        {else}
                            <input type="hidden" value="0" name="TagsSearchSubTree" />
                        {/if}
                        <button class="btn btn-default" type="submit" name="TagsSearchButton">{"Search tags"|i18n( "extension/eztags/tags/search" )}
                    </span>
                </div>
            </div>
            <div class="form-group">
                <label for="tags_include_synonyms">
                    <input type="checkbox" id="tags_include_synonyms" name="TagsIncludeSynonyms" checked="checked" /> {"Include synonyms in search"|i18n( "extension/eztags/tags/search" )}
                </label>
            </div>
        </form>
    </fieldset>
</div>
