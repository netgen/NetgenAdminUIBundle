<div class="app-aside-footer dk">
  <div class="dropdown dropup" dropdown="">


    {if ezpreference( 'admin_aside_fold_control' )}
        {def $fold_control_href='/user/preferences/set/admin_aside_fold_control/0'}
    {else}
        {def $fold_control_href='/user/preferences/set/admin_aside_fold_control/1'}
    {/if}

    <a href={$fold_control_href|ezurl} class="pull-right wrapper m-r-xs">{*ui-toggle="app-aside-folded" target=".app"*}
      <i class="fa fa-dedent fa-fw text"></i>
      <i class="fa fa-indent fa-fw text-active"></i>
    </a>



    <a href="#" data-toggle="dropdown" class="dropdown-toggle clear hidden-folded wrapper-sm padder">
      <span class="thumb-xxs avatar pull-left m-r-sm">
        <img src={'a0.jpg'|ezimage} alt="...">
      </span>
      <span class="hidden-sm hidden-md m-t-xs text-ellipsis">{$current_user.contentobject.name|wash}</span>
    </a>

    <!-- dropdown -->
    <ul class="dropdown-menu animated fadeInLeft w hidden-folded">


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
            <a href={'/user/password/'|ezurl} title="{'Change password for <%username>.'|i18n( 'design/admin/pagelayout',, hash( '%username', $current_user.contentobject.name ) )|wash}">{'Change password'|i18n( 'design/admin/pagelayout' )}</a>
          </li>
      {else}
          <ul>
            <li><span class="disabled">{'Change user info'|i18n( 'design/admin/pagelayout' )}</span></li>
            <li><span class="disabled">{'Change password'|i18n( 'design/admin/pagelayout' )}</span></li>
          </ul>
      {/if}


      <li class="divider"></li>


      {if and( ne( $ui_context, 'edit' ), ne( $ui_context, 'browse' ))}

        {if ezpreference( 'admin_edit_show_locations' )}
          <li class="hidden-folded padder m-t m-b-sm text-muted text-xs">
            Locations are enabled
          </li>
          <li><a href={'/user/preferences/set/admin_edit_show_locations/0'|ezurl} title="{'Disable location window when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Disable locations</a></li>
        {else}
          <li class="hidden-folded padder m-t m-b-sm text-muted text-xs">
            Locations are disabled
          </li>
          <li><a href={'/user/preferences/set/admin_edit_show_locations/1'|ezurl} title="{'Enable location window when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Enable locations</a></li>
        {/if}


        {if ezpreference( 'admin_edit_show_re_edit' )}
            <li class="hidden-folded padder m-t m-b-sm text-muted text-xs">
              Re-edit is enabled
            </li>
            <li>
              <a href={'/user/preferences/set/admin_edit_show_re_edit/0'|ezurl} title="{'Disable &quot;Back to edit&quot; checkbox when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Disable Re-edit</a>
            </li>
        {else}
            <li class="hidden-folded padder m-t m-b-sm text-muted text-xs">
              Re-edit is disabled
            </li>
            <li>
              <a href={'/user/preferences/set/admin_edit_show_re_edit/1'|ezurl} title="{'Enable &quot;Back to edit&quot; checkbox when editing content.'|i18n( 'design/admin/parts/my/menu' )}">Enable Re-edit</a>
            </li>
        {/if}

      {/if}


    </ul>
    <!-- / dropdown -->


  </div>
</div>
