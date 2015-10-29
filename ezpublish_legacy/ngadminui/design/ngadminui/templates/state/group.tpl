<form action={concat("/state/group/", $group.identifier)|ezurl} method="post" id="stateList">


    {* DESIGN: Header START *}<div class="box-header">

    <h1 class="context-title">{'%group_name [Content object state group]'|i18n('design', '', hash( '%group_name', $group.current_translation.name))|wash}</h1>

    {* DESIGN: Mainline *}<div class="header-mainline"></div>

    {* DESIGN: Header END *}</div>

    {* DESIGN: Content START *}
    <div class="box-content panel">

        <div class="context-attributes">

            <div class="block">
                <div class="form-group">
                    <label>{"ID"|i18n('design/admin/state/group')}</label>
                    {$group.id}
                </div>

                <div class="form-group">
                    <label>{"Identifier"|i18n('design/admin/state/group')}</label>
                    {$group.identifier}
                </div>

                <div class="form-group">
                <label>{"Name"|i18n('design/admin/state/group')}</label>
                {$group.current_translation.name|wash}
                </div>
                <div class="form-group">
                    <label>{"Description"|i18n('design/admin/state/group')}</label>
                    <p>
                    {$group.current_translation.description|nl2br}
                    </p>
                </div>

                <div class="break"></div>
            </div>

        </div>
        {* DESIGN: Content END *}
        <div class="block">
            <div class="controlbar">
            {* DESIGN: Control bar START *}
              {if $group.is_internal|not}
              <input class="btn btn-default" type="submit" name="EditButton" value="{'Edit'|i18n('design')}" />
              {else}
              <input class="btn btn-default" type="submit" name="EditButton" value="{'Edit'|i18n('design')}" disabled="disabled" />
              {/if}
            </div>
        </div>

            {* DESIGN: Control bar END *}



        <div class="context-block">

            {* DESIGN: Header START *}

            <h2>{'Translations (%translations)'|i18n( 'design/admin/node/view/full',, hash( '%translations', $group.languages|count ) )}</h2>



            {* DESIGN: Header END *}

            {* DESIGN: Content START *}

            <table class="list" cellspacing="0">
                <tr>
                    <th>{'Language'|i18n( 'design/admin/node/view/full' )}</th>
                    <th>{'Locale'|i18n( 'design/admin/node/view/full' )}</th>
                    <th class="tight">{'Main'|i18n( 'design/admin/node/view/full' )}</th>
                </tr>

                {foreach $group.languages as $language sequence array( 'bglight', 'bgdark' ) as $sequence}
                <tr class="{$sequence}">
                    <td><img src="{$language.locale|flag_icon}" width="18" height="12" alt="{$language.locale|wash}" />&nbsp;<a href={concat( '/state/group/', $group.identifier, '/', $language.locale )|ezurl} title="{'View translation.'|i18n( 'design/admin/node/view/full' )}">{$language.name|wash}</td>
                    <td>{$language.locale|wash}</td>
                    <td>{if $language.id|eq($group.default_language_id)}Yes{/if}</td>
                </tr>
                {/foreach}

            </table>

            {* DESIGN: Content END *}

        </div>{* class="context-block" *}



        <div class="context-block">


            {* DESIGN: Header START *}
            <h2>{'Object states in this group (%state_count)'|i18n( 'design/admin/state/group', '', hash( '%state_count', $group.states|count ))}</h2>



            {* DESIGN: Header END *}

            {* DESIGN: Content START *}

            <table class="list" cellspacing="0">
                <tr>
                    <th class="tight"><i class="fa fa-check-square-o" title="{'Invert selection.'|i18n( 'design/admin/state/group' )|wash}" onclick="ezjs_toggleCheckboxes( document.getElementById('stateList'), 'DeleteIDArray[]' ); return false;"></i></th>
                    <th class="tight">{'ID'|i18n('design/admin/state/group')|wash}</th>
                    <th>{'Identifier'|i18n('design/admin/state/group')|wash}</th>
                    <th>{'Name'|i18n('design/admin/state/group')|wash}</th>
                    <th>{'Object count'|i18n('design/admin/state/group')|wash}</th>
                    <th class="tight">{'Order'|i18n('design/admin/state/group')|wash}</th>
                    <th class="tight">&nbsp;</th>
                </tr>
                {foreach $group.states as $state sequence array( 'bglight', 'bgdark' ) as $sequence}
                <tr class="{$sequence}">
                    <td><input type="checkbox" name="RemoveIDList[]" value="{$state.id}" title="{'Select content object state group for removal.'|i18n( 'design/admin/state/group' )|wash}" {if $group.is_internal}disabled="disabled"{/if} /></td>
                    <td class="number">{$state.id}</td>
                    <td><a href={concat("/state/view/",$group.identifier,"/",$state.identifier)|ezurl}>{$state.identifier|wash}</a></td>
                    <td><a href={concat("state/view/",$group.identifier,"/",$state.identifier)|ezurl}>{$state.current_translation.name|wash}</a></td>
                    <td>{$state.object_count}</td>
                    <td>
                        <input type="text" name="Order[{$state.id}]" size="3" value="{$state.priority}" {if $group.is_internal}disabled="disabled"{/if} />
                    </td>
                    <td>
                    {if $group.is_internal|not}
                    <a href={concat("state/edit/",$group.identifier,"/",$state.identifier)|ezurl}><i class="fa fa-pencil-square-o"></i></a></td>
                    {else}
                    <img src={'edit-disabled.gif'|ezimage} alt="{'Edit'|i18n( 'design/admin/node/view/full' )|wash}" />
                    {/if}
                </tr>
                {/foreach}
            </table>

            {* DESIGN: Content END *}
        </div>

        <div class="controlbar">

        {* DESIGN: Control bar START *}
            <div class="button-left">
              {if $group.is_internal|not}
              <input class="btn btn-default" type="submit" id="remove_state_button" name="RemoveButton" value="{'Remove selected'|i18n('design/admin/state/group')|wash}" title="{'Remove selected states.'|i18n( 'design/admin/state/group' )|wash}" />
              <input class="btn btn-default" type="submit" id="create_state_button" name="CreateButton" value="{'Create new'|i18n('design/admin/state/group')|wash}" title="{'Create a new state.'|i18n( 'design/admin/state/group' )|wash}" />

              {else}
              <input class="btn btn-default" type="submit" id="remove_state_button" name="RemoveButton" value="{'Remove selected'|i18n('design/admin/state/group')|wash}" title="{'Remove selected states.'|i18n( 'design/admin/state/group' )|wash}" disabled="disabled" />
              <input class="btn btn-default" type="submit" id="create_state_button" name="CreateButton" value="{'Create new'|i18n('design/admin/state/group')|wash}" title="{'Create a new state.'|i18n( 'design/admin/state/group' )|wash}" disabled="disabled" />
              {/if}
            </div>

            <div class="button-right">
                {if $group.is_internal|not}
                <input class="btn btn-default" type="submit" name="UpdateOrderButton" value="{'Update ordering'|i18n('design/admin/state/group')|wash}" title="{'Update the order of the content object states in this group.'|i18n( 'design/admin/state/group' )|wash}" />
                {else}
                <input class="btn btn-default" type="submit" name="UpdateOrderButton" value="{'Update ordering'|i18n('design/admin/state/group')|wash}" title="{'Update the order of the content object states in this group.'|i18n( 'design/admin/state/group' )|wash}" disabled="disabled" />
                {/if}
            </div>

            <div class="break"></div>
        </div>

        {* DESIGN: Control bar END *}


    </div>

</form>
