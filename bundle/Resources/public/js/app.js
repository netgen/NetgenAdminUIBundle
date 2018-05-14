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
  (function() {
    var control = $('.edit-tab-control'),
      trigger = control.find('a'),
      tabs = $('.edit-tabs'),
      tab = tabs.find('.tab'),
      i = 0;
    trigger.eq(0).addClass('active');
    tab.not(tab.eq(0)).hide();
    trigger.on('click', function(e) {
      i = $(this).index();
      trigger.removeClass('active');
      $(this).addClass('active');
      tab.eq(i).fadeIn().siblings().hide();
      e.preventDefault();
    })
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

  /* save current url to local storage when opening bm */
  $(document).on('click', '.js-open-bm', function(e) {
    localStorage.setItem('bm_referrer', window.location.href);
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
    this.$el.on('click', '.js-clear-layout-cache', this.openCacheModal.bind(this));
    this.$el.on('click', '.js-clear-block-caches', this.clearBlockCaches.bind(this));
    this.$layoutCacheModal.on('click', '.js-modal-confirm', this.clearLayoutCache.bind(this));
  };
  LayoutMapped.prototype.openCacheModal = function (e) {
    e.preventDefault();
    this.$layoutCacheModal.find('.errors').remove();
    this.$layoutCacheModal.modal('show');
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
      },
      success: function () {
        self.$layoutCacheModal.modal('hide');
      },
      error: function (xhr) {
        var $resp = $(xhr.responseText);
        self.$layoutCacheModal.find('.modal-body').prepend($resp.find('.errors'));
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
        success: function () {
          self.layouts.$blockCacheModal.modal('show');
        },
        error: function (xhr) {
          $form.html(xhr.responseText);
          afterModalRender($form);
        },
      });
    };
    $.ajax({
      type: 'GET',
      url: this.layouts.basePath + this.id + '/cache/blocks',
      success: (data) => {
        var $form = $(data);
        afterModalRender($form);
        self.layouts.$blockCacheModal.find('.modal-body').html($form);
        self.layouts.$blockCacheModal.modal('show');
        $form.on('submit', formAction.bind(this));
      },
    });
  };

  function LayoutsBox(el) {
    this.$el = $(el);
    this.$content = this.$el.find('.layouts-box-content');
    this.layoutsList = this.$el.find('#layouts-list-wrapper')[0];
    this.$loader = this.$el.find('.layout-loading');
    this.fetchedLayouts = false;
    this.$toggleBtn = $('.js-manage-layouts');
    this.opened = false;
    this.url = el.dataset.url;
    this.csrf = $('meta[name=ngbm-admin-csrf-token]').attr('content');
    this.basePath = $('meta[name=ngbm-admin-base-path]').attr('content') + 'layouts/';
    this.$blockCacheModal = $('#clearBlockCachesModal');
    this.setupEvents();
  }
  LayoutsBox.prototype.setupEvents = function () {
    this.$toggleBtn.on('click', this.toggleBox.bind(this));
  };
  LayoutsBox.prototype.toggleBox = function () {
    return this.opened ? this.closeBox() : this.openBox();
  };
  LayoutsBox.prototype.openBox = function () {
    if (!this.fetchedLayouts) return this.getLayouts();
    this.$content.slideDown(250);
    this.$toggleBtn.addClass('open');
    this.opened = true;
  };
  LayoutsBox.prototype.closeBox = function () {
    this.$content.slideUp(250);
    this.$toggleBtn.removeClass('open');
    this.opened = false;
  };
  LayoutsBox.prototype.showLoader = function () {
    this.$toggleBtn.addClass('loading');
  };
  LayoutsBox.prototype.hideLoader = function () {
    this.$toggleBtn.removeClass('loading');
  };
  LayoutsBox.prototype.getLayouts = function () {
    var self = this;
    $.ajax({
      type: 'GET',
      url: this.url,
      beforeSend: function () {
        self.showLoader();
      },
      success: function (data) {
        self.fetchedLayouts = true;
        self.layoutsList.innerHTML = data;
        self.initLayouts();
        self.hideLoader();
        self.openBox();
      },
    });
  };
  LayoutsBox.prototype.initLayouts = function () {
    var self = this;
    this.$el.find('.layout-list-item').each(function () {
      return new LayoutMapped(this, self);
    });
  };

  $('.mapped-layouts-box').each(function() {
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
