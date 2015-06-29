{if or( $hide_right_menu, $collapse_right_menu )}
    <a id="rightmenu-showhide" class="show-hide-control" title="{'Show / Hide rightmenu'|i18n( 'design/admin/pagelayout/rightmenu' )}" href={'/user/preferences/set/admin_right_menu_show/1'|ezurl}></a>
    <div id="rightmenu-design"></div>
{else}
    <a id="rightmenu-showhide" class="show-hide-control" title="{'Hide / Show rightmenu'|i18n( 'design/admin/pagelayout/rightmenu' )}" href={'/user/preferences/set/admin_right_menu_show/0'|ezurl}></a>
    <div id="rightmenu-design">
        {tool_bar name='admin_right' view='full'}
        {tool_bar name='admin_developer' view='full'}
    </div>

    {literal}
    <script type="text/javascript">
        YUI(YUI3_config).use('ezcollapsiblemenu', 'event', 'io-ez', 'node', function (Y) {

            Y.on('domready', function () {
                var rightmenu = new Y.eZ.CollapsibleMenu({
                    link: '#rightmenu-showhide',
                    content: ['', ''],
                    collapsed: 0,
                    elements:[{
                        selector: '#rightmenu',
                        duration: 0.4,
                        fullStyle: {width: '201px'},
                        collapsedStyle: {width: '18px'}
                    },{
                        selector: '#maincolumn',
                        duration: 0.4,
                        fullStyle: {marginRight: '210px'},
                        collapsedStyle: {marginRight: '27px'}
                    },{
                        selector: '#right-panels-separator',
                        duration: 0.4,
                        fullStyle: {right:'181px'},
                        collapsedStyle: {right: '-2px'}
                    }],
                    callback: function () {
                        var p = 1;
                        if ( this.conf.collapsed )
                            p = 0;
                        Y.io.ez.setPreference('admin_right_menu_show', p);
                    }
                });
            });
        });
    </script>
    {/literal}
{/if}
