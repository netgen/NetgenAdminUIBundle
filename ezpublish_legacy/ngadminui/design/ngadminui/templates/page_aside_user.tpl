{def $current_user = fetch(user, current_user)}
<div class="aside-footer">

    {if ezpreference( 'admin_aside_fold_control' )}
        {def $fold_control_href='/user/preferences/set/admin_aside_fold_control/0'}
    {else}
        {def $fold_control_href='/user/preferences/set/admin_aside_fold_control/1'}
    {/if}

    <a href="#" class="user-dropdown-toggle dropdown-toggle" data-toggle="dropdown">
        <span class="user-avatar">
            <img src={'a0.jpg'|ezimage} alt="...">
        </span>
        {* <span class="user-name hidden-folded">{$current_user.contentobject.name|wash}</span> *}
    </a>

    {* <a href={$fold_control_href|ezurl} class="aside-fold-trigger">
        {if ezpreference( 'admin_aside_fold_control' )}
            <i class="fa fa-dedent"></i>
        {else}
            <i class="fa fa-indent"></i>
        {/if}
    </a> *}

    <!-- dropdown -->
    <ul class="dropdown-menu user-dropdown">

        <li>
            <div class="user-avatar">
                <img src={'a0.jpg'|ezimage} alt="...">
            </div>
            <h4 class="user-name">{$current_user.contentobject.name|wash}</h4>
            <p class="user-role">{$current_user.login|wash}</p>
        </li>

        <li class="divider"></li>

        {if and( ne( $ui_context, 'edit' ), ne( $ui_context, 'browse' ) )}
            {def $user_node = $current_user.contentobject.main_node
                $current_user_link = $user_node.url_alias|ezurl}
                {if $user_node.can_read}
                    <li><a href={$current_user_link}>View profile</a></li>
                {/if}
            {undef $current_user_link $user_node}
            {if $current_user.contentobject.can_edit}
                <li>
                    <a href={concat( '/content/edit/',  $current_user.contentobject_id, '/' )|ezurl} title="{'Change name, email, password, etc.'|i18n( 'design/admin/pagelayout' )}">{'Change information'|i18n( 'design/admin/pagelayout' )}</a>
                </li>
            {/if}
            <li>
                <a href={'/user/password/'|ezurl} title="Change password">{'Change password'|i18n( 'design/admin/pagelayout' )}</a>
            </li>
        {else}
            <li><span class="disabled">View profile</span></li>
            <li><span class="disabled">{'Change information'|i18n( 'design/admin/pagelayout' )}</span></li>
            <li><span class="disabled">{'Change password'|i18n( 'design/admin/pagelayout' )}</span></li>
        {/if}

        <li class="divider"></li>

        {* {if and( ne( $ui_context, 'edit' ), ne( $ui_context, 'browse' ))}

            {if ezpreference( 'admin_edit_show_locations' )}
                <li class="hidden-folded">
                    <span>Locations are enabled</span>
                </li>
                <li><a href={'/user/preferences/set/admin_edit_show_locations/0'|ezurl} title="{'Disable location window when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Disable locations</a></li>
            {else}
                <li class="hidden-folded">
                    <span>Locations are disabled</span>
                </li>
                <li><a href={'/user/preferences/set/admin_edit_show_locations/1'|ezurl} title="{'Enable location window when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Enable locations</a></li>
            {/if}


            {if ezpreference( 'admin_edit_show_re_edit' )}
                <li class="hidden-folded">
                    <span>Re-edit is enabled</span>
                </li>
                <li>
                    <a href={'/user/preferences/set/admin_edit_show_re_edit/0'|ezurl} title="{'Disable &quot;Back to edit&quot; checkbox when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Disable Re-edit</a>
                </li>
            {else}
                <li class="hidden-folded">
                    <span>Re-edit is disabled</span>
                </li>
                <li>
                    <a href={'/user/preferences/set/admin_edit_show_re_edit/1'|ezurl} title="{'Enable &quot;Back to edit&quot; checkbox when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Enable Re-edit</a>
                </li>
            {/if}

        {/if} *}

        <li>
            {if $ui_context_edit}
                <span title="{'Logout from the system.'|i18n( 'design/admin/pagelayout' )}" class="disabled">Logout</span>
            {else}
                <a href={'/user/logout'|ezurl} title="{'Logout from the system.'|i18n( 'design/admin/pagelayout' )}">Logout</a>
            {/if}
        </li>

    </ul>
    <!-- / dropdown -->

</div>
