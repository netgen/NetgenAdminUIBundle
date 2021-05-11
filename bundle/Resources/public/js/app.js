/* eslint-disable prefer-arrow-callback */
$(document).ready(function () {
  var $loginform = $('form[name="loginform"]');
  $loginform.attr('action', $loginform.attr('action') + window.location.hash);

  /* left column resize */
  (function() {
    if ($(window).width() > 800) {
      var colw = sessionStorage.getItem('lcw'),
        leftColumn = $('#left-column');
      //leftColumn.width(colw);
      //$('.search-form').width(colw);
      leftColumn.resizable({
        handles: 'e',
        alsoResize: '.search-form'
      });
      $('.ui-resizable-e').on('mouseup', function() {
        colw = leftColumn.width();
        sessionStorage.setItem('lcw', colw);
      });
    }
  })();
  /* */

  /* aside fold */
  (function() {
    var page = $('#page'),
      foldedClass = 'aside-folded',
      settingsLink = '',
      trigger = $('.aside-fold-trigger'),
      icon = trigger.find('i.fa');
    trigger.on('click', function(e) {
      e.preventDefault();
      if (page.hasClass(foldedClass)) {
        page.removeClass(foldedClass);
        settingsLink = '/user/preferences/set/admin_aside_fold_control/1';
      } else {
        page.addClass(foldedClass);
        settingsLink = '/user/preferences/set/admin_aside_fold_control/0';
      }
      icon.toggleClass('fa-dedent fa-indent');
      $.ajax({
        method: 'POST',
        url: settingsLink
      })
    });
  })();
  /* */

  /* aside dropdown */
  (function() {
    $('.navi-wrap .aside-dropdown-toggle').dropdown();
    $('.user-dropdown-toggle').dropdown();
    var parent = $('.navi-wrap .aside-dropdown'),
      duration = 200;
    parent.on('show.bs.dropdown', function(e) {
      var y = $(this).offset().top + ($(this).outerHeight() / 2),
        menu = $(this).find('.dropdown-menu').first(),
        menuH = menu.outerHeight(),
        menuTop = y - (menuH / 2),
        menuBottom = window.innerHeight - menuH - menuTop;
      if (menuH > (window.innerHeight - 10)) {
        menu.css({ 'top': 10, 'bottom': 10 });
      } else if (menuTop < 5) {
        menu.css({ 'top': 10, 'bottom': 'auto' });
      } else if (menuBottom < 5) {
        menu.css({ 'bottom': 10, 'top': 'auto' });
      } else {
        menu.css({ 'top': y - (menuH / 2), 'bottom': 'auto' });
      };
      menu.stop(true, true).fadeIn({ queue: false, duration: duration }).animate({ marginLeft: '+=50' }, duration);
    });
    parent.on('hide.bs.dropdown', function(e) {
      $(this).find('.dropdown-menu').first().stop(true, true).fadeOut({ queue: false, duration: duration }).animate({ marginLeft: '-=50' }, duration);
    });
    $('.dropdown-menu').on('click', function(e) {
      e.stopPropagation();
    });
  })();
  /* */

  /* aside folded tooltips */
  (function() {
    $('.aside-folded .aside-nav').on('mouseover', 'a', function() {
      var y = $(this).offset().top + ($(this).outerHeight() / 2);
      $(this).find('.tt').css('top', y);
    });
  })();
  /* */

  /* edit tabs */
  (function(){
    var control = $('.edit-tab-control'),
      trigger = control.find('a'),
      tabs = $('.edit-tabs'),
      tab = tabs.find('.tab'),
      groupId = false,
      preferences = {},
      preferenceStr = sessionStorage.getItem('netgen/ngadminui/preferences');

    if(preferenceStr){
      preferences = JSON.parse(preferenceStr);
    }
    groupId = preferences.activeEditTab || false;

    trigger.on('click', function(e){
      i = $(this).index();
      trigger.removeClass('active');
      $(this).addClass('active');
      tab.eq(i).fadeIn().siblings().hide();
      sessionStorage.setItem('netgen/ngadminui/preferences',
        JSON.stringify({activeEditTab: $(this).attr('data-field-group')})
      );
      e.preventDefault();
    });

    if(groupId){
      var selected = trigger.filter('[data-field-group="'+groupId+'"]');

      if(selected.length){
        selected.click();
      }
      else{
        trigger.eq(0).click();
      }
    }
    else{
      trigger.eq(0).click();
    }
  })();
  /* */

  /* file upload */
  $('.btn-file').on('change', ':file', function() {
    var input = $(this),
      numFiles = input.get(0).files ? input.get(0).files.length : 1,
      label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
  });
  $('.btn-file :file').on('fileselect', function(event, numFiles, label) {
    var input = $(this).parents('.input-group').find(':text'),
      log = numFiles > 1 ? numFiles + ' files selected' : label;
    if (input.length) {
      input.val(log);
    } else {
      if (log) alert(log);
    }
  });
  /* */

  $('#page-datatype-container').on('click', 'a.show-hide-advanced-attributes', function(e) {
    e.preventDefault();
    var blockId = $(this).data('block-id');

    if (localStorage.getItem('NgAdminUIAdvancedAttributesShown-' + blockId) !== null) {
      $('#id_' + blockId + ' .advanced').hide();
      localStorage.removeItem('NgAdminUIAdvancedAttributesShown-' + blockId);
      $(this).text($(this).data('show-text'));
    } else {
      $('#id_' + blockId + ' .advanced').show();
      localStorage.setItem('NgAdminUIAdvancedAttributesShown-' + blockId, '1');
      $(this).text($(this).data('hide-text'));
    }
  });

  $('.form-siteaccess').on('change', 'select', function() {
    $(this).closest('form').submit();
  });

  /* edit path move */
  var breadcrumbDiv = $('#path');
  if (breadcrumbDiv.hasClass('path-edit')) {
    breadcrumbDiv.appendTo('.path-edit-container').fadeIn('fast');
  }

  $('.removeNodeConfirm').on('click', function() {
    $('#removePrompt').modal('show');
  });

  /* save current location ID to local storage when opening Netgen Layouts edit interface */
  $(document).on('click', '.js-open-ngl', function(e) {
    localStorage.setItem('ngl_referrer', window.location.href);
    e.currentTarget.dataset.valueId !== undefined && localStorage.setItem('ngl_referrer_value_id', e.currentTarget.dataset.valueId);
    e.currentTarget.dataset.valueType !== undefined && localStorage.setItem('ngl_referrer_value_type', e.currentTarget.dataset.valueType);
  });

    /* checkbox */
    $(document).on('change', '.rules-checkbox', function () {
      if (this.checked) {
        $('.rule-non-direct').show();

        $('.title-direct-rules').hide();
        $('.title-all-rules').show();
      } else {
        $('.rule-non-direct').hide();

        $('.title-direct-rules').show();
        $('.title-all-rules').hide();
      }
    });

  /* toggle menu on small screens */
  (function() {
    var toggleClassName = 'menu-visible';
    if ($('#left-column').length === 0) toggleClassName += ' without-left-menu';
    $('#menu-toggle').on('click', function() {
      $('body').toggleClass(toggleClassName);
    });
  })();

  /* edit layout box */
  function LayoutMapped(el, layouts) {
    this.$el = $(el);
    this.layouts = layouts;
    this.id = el.dataset.layoutId;
    this.$layoutCacheModal = this.$el.find('.layout-cache-modal');
    this.setupEvents();
  }
  LayoutMapped.prototype.setupEvents = function () {
    this.$el.find('.js-clear-layout-cache').on('click', this.openCacheModal.bind(this));
    this.$el.find('.js-clear-block-caches').on('click', this.clearBlockCaches.bind(this));
    this.$layoutCacheModal.on('click', '.js-modal-confirm', this.clearLayoutCache.bind(this));
  };
  LayoutMapped.prototype.openCacheModal = function (e) {
    e.preventDefault();
    this.$layoutCacheModal.find('.errors').remove();
    this.cacheModalStopLoading();
    this.$layoutCacheModal.modal('show');
  };
  LayoutMapped.prototype.cacheModalStartLoading = function () {
    if (!this.$layoutCacheModal.find('.modal-loading').length) this.$layoutCacheModal.find('.modal-body').append('<div class="modal-loading"><i class="loading-ng-icon"></i></div>');
  };
  LayoutMapped.prototype.cacheModalStopLoading = function () {
    this.$layoutCacheModal.find('.modal-loading').remove();
  };
  LayoutMapped.prototype.clearLayoutCache = function (e) {
    e.preventDefault();
    var self = this;
    $.ajax({
      type: 'POST',
      url: this.layouts.basePath + this.id + '/cache',
      headers: {
        'X-CSRF-Token': this.layouts.csrf,
      },
      beforeSend: function () {
        self.$layoutCacheModal.find('.errors').remove();
        self.cacheModalStartLoading();
      },
      success: function () {
        self.$layoutCacheModal.modal('hide');
      },
      error: function (xhr) {
        var $resp = $(xhr.responseText);
        self.$layoutCacheModal.find('.modal-body').prepend($resp.find('.errors'));
        self.cacheModalStopLoading();
        console.log(xhr, 'Error clearing caches:', xhr.statusText);
      },
    });
  };
  LayoutMapped.prototype.indeterminateCheckboxes = function ($form) {
    var $checkboxes = [];
    var $submit = $form.find('button[type="submit"]');
    var changeState = function (arr) {
      var checkedNr = 0;
      arr.forEach(function (el) {
        return el.checked && checkedNr++;
      });
      $('input[type="checkbox"]#toggle-all-cache').prop({
        indeterminate: checkedNr > 0 && checkedNr < arr.length,
        checked: checkedNr === arr.length,
      });
      $submit.prop('disabled', checkedNr === 0);
    };
    $form.find('input[type="checkbox"]').each(function (i, el) {
      el.id !== 'toggle-all-cache' && $checkboxes.push(el);
    });
    changeState($checkboxes);
    $form.on('change', 'input[type="checkbox"]', function (e) {
      if (e.currentTarget.id === 'toggle-all-cache') {
        $checkboxes.forEach(function (el) {
          $(el).prop('checked', e.currentTarget.checked);
        });
        $submit.prop('disabled', !e.currentTarget.checked);
      } else {
        changeState($checkboxes);
      }
    });
  };
  LayoutMapped.prototype.clearBlockCaches = function (e) {
    e.preventDefault();
    var self = this;
    var afterModalRender = function ($form) {
      $form.find('.nl-btn').addClass('btn btn-primary');
      self.layouts.$blockCacheModal.find('.modal-title').html($form.find('.nl-modal-head'));
      self.indeterminateCheckboxes($form);
    };
    var formAction = function (el) {
      el.preventDefault();
      var $form = $(el.currentTarget);
      $.ajax({
        type: $form.attr('method'),
        url: $form.attr('action'),
        data: $form.serialize(),
        headers: {
          'X-CSRF-Token': this.layouts.csrf,
        },
        beforeSend: function () {
          self.layouts.cacheModalStartLoading();
        },
        success: function () {
          self.layouts.$blockCacheModal.modal('hide');
        },
        error: function (xhr) {
          self.layouts.cacheModalStopLoading();
          $form.html(xhr.responseText);
          afterModalRender($form);
        },
      });
    };
    this.layouts.cacheModalStartLoading();
    this.layouts.$blockCacheModal.modal('show');
    $.ajax({
      type: 'GET',
      url: this.layouts.basePath + this.id + '/cache/blocks',
      success: (data) => {
        var $form = $(data);
        afterModalRender($form);
        self.layouts.$blockCacheModal.find('.modal-body').html($form);
        $form.on('submit', formAction.bind(this));
      },
      error: function (xhr) {
        self.layouts.$blockCacheModal.find('.modal-body').html(xhr.responseText);
        self.layouts.cacheModalStopLoading();
      },
    });
  };

  function LayoutsBox(el) {
    this.$el = $(el);
    this.csrf = $('meta[name=nglayouts-admin-csrf-token]').attr('content');
    this.basePath = $('meta[name=nglayouts-admin-base-path]').attr('content');
    this.basePath += this.basePath.charAt(this.basePath.length - 1) !== '/' ? '/layouts/' : 'layouts/';
    this.$content = this.$el.find('.layouts-box-content');
    this.$loader = this.$el.find('.layout-loading');
    this.fetchedLayouts = false;
    this.$toggleBtn = $('#node-tab-nglayouts').find('a');
    this.url = el.dataset.url;
    this.setupEvents();
    this.$el.is(':visible') && this.getLayouts();
  }
  LayoutsBox.prototype.setupEvents = function () {
    this.$toggleBtn.on('click', this.getLayouts.bind(this));
  };
  LayoutsBox.prototype.initLayouts = function () {
    var self = this;
    this.$el.find('.layout-list-item').each(function () {
      return new LayoutMapped(this, self);
    });
  };
  LayoutsBox.prototype.cacheModalStartLoading = function () {
    if (!this.$blockCacheModal.find('.modal-loading').length) {
      this.$blockCacheModal.find('.modal-title').html('&nbsp;');
      this.$blockCacheModal.find('.modal-body').append('<div class="modal-loading"><i class="loading-ng-icon"></i></div>');
    }
  };
  LayoutsBox.prototype.cacheModalStopLoading = function () {
    this.$blockCacheModal.find('.modal-loading').remove();
  };
  LayoutsBox.prototype.showLoader = function () {
    this.$el.addClass('loading');
  };
  LayoutsBox.prototype.hideLoader = function () {
    this.$el.removeClass('loading');
  };
  LayoutsBox.prototype.getLayouts = function () {
    if (this.fetchedLayouts) return;
    var self = this;
    $.ajax({
      type: 'GET',
      url: this.url,
      beforeSend: function () {
        self.showLoader();
      },
      success: function (data) {
        self.fetchedLayouts = true;
        self.$content.html(data);
        self.$blockCacheModal = $('#clearBlockCachesModal');
        self.initLayouts();
        self.hideLoader();
      },
    });
  };

  $('.mapped-layouts-box').each(function () {
    return new LayoutsBox(this);
  });
});

var initBlockAttributesState = function() {
  $('.block-container').each(function() {
    var blockId = $(this).prop('id').replace('id_', '');
    var toggler = $('#id_' + blockId + ' .show-hide-advanced-attributes');

    if (localStorage.getItem('NgAdminUIAdvancedAttributesShown-' + blockId) !== null) {
      $('#id_' + blockId + ' .advanced').show();
      toggler.text(toggler.data('hide-text'));
    } else {
      $('#id_' + blockId + ' .advanced').hide();
      toggler.text(toggler.data('show-text'));
    }
  });
};

ace.config.set('basePath', '/bundles/netgenadminui/bower/ace-builds/src-min-noconflict');
ace.require("ace/ext/language_tools");
