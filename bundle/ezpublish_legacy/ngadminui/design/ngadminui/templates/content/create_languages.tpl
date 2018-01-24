{def $languages=fetch('content', 'prioritized_languages')
     $classes=fetch( 'content', 'can_instantiate_class_list', hash( 'parent_node', $node_id ) )
     $class=false()
     $can_create=false()}

{foreach $classes as $tmp_class}
    {if $tmp_class.id|eq($class_id)}
        {set $class=$tmp_class}
        {break}
    {/if}
{/foreach}
<div class="path-edit-container"></div>

<!-- Maincontent START -->

<form name="CreateLanguages" action={'content/action'|ezurl} method="post">

    <div class="context-block">

        {* DESIGN: Header START *}
        <div class="title-wrapper">
            <h2>{'Language selection'|i18n( 'design/admin/content/create_languages' )}</h2>

            {* DESIGN: Mainline *}<div class="header-mainline"></div>

            {* DESIGN: Header END *}
        </div>

        {* DESIGN: Content START *}
        <div class="panel">

            <div class="block">

                {if or($class|not,$class.can_instantiate_languages|not)}

                <p>{'You do not have permission to create an object of the requested class in any language.'|i18n( 'design/admin/content/create_languages' )}</p>

                {else}

                    {set $can_create=true()}
                    {def $language_codes=$class.can_instantiate_languages}

                    <p>{'Select the language in which you want to create the object'|i18n( 'design/admin/content/create_languages' )}:</p>

                    {foreach $languages as $language}
                        {if $language_codes|contains($language.locale)}
                            <label>
                                <input name="ContentLanguageCode" type="radio" value="{$language.locale|wash}"{run-once} checked="checked"{/run-once} /> {$language.name|wash}
                            </label>
                            <div class="labelbreak"></div>
                        {/if}
                    {/foreach}

                {/if}

                <input type="hidden" name="NodeID" value="{$node_id|wash}" />
                <input type="hidden" name="ClassID" value="{$class_id|wash}" />

                {if $assignment_remote_id}
                    <input type="hidden" name="AssignmentRemoteID" value="{$assignment_remote_id|wash}" />
                {/if}
                {if $redirect_uri_after_publish}
                    <input type="hidden" name="RedirectURIAfterPublish" value="{$redirect_uri_after_publish|wash}" />
                {/if}
                {if $redirect_uri_after_discard}
                    <input type="hidden" name="RedirectIfDiscarded" value="{$redirect_uri_after_discard|wash}" />
                {/if}

                <input type="hidden" name="CancelURI" value="content/view/full/{$node_id|wash}" />

            </div>

            {* DESIGN: Content END *}

            <div class="controlbar">

                {* DESIGN: Control bar START *}

                <div class="block">
                    {if $can_create}
                        <input class="btn btn-primary" type="submit" name="NewButton" value="{'OK'|i18n('design/admin/content/create_languages')}" />
                        <input class="btn btn-default" type="submit" name="CancelButton" value="{'Cancel'|i18n('design/admin/content/create_languages')}" />
                    {else}
                        <input class="btn btn-default" type="submit" name="CancelButton" value="{'OK'|i18n('design/admin/content/create_languages')}" />
                    {/if}
                </div>

                {* DESIGN: Control bar END *}

            </div>
        </div>

    </div>

</form>

<!-- Maincontent END -->

