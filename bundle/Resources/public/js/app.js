/* eslint-disable prefer-arrow-callback */

/* modal plugin */
class NlMoveModalGroup {
  constructor(el, data, modal, depth = 0, disabled = false) {
    this.data = data;
    this.modal = modal;
    this.el = el;
    this.id = this.data.id;
    this.depth = depth;

    this.reorderPermission = this.data.permissions.mapping.reorder;

    [this.checkBoxContainer] = this.el.getElementsByClassName('nl-export-checkbox');
    // eslint-disable-next-line prefer-destructuring
    this.selectElement = this.checkBoxContainer.children[0];
    this.selected = this.selectElement && this.selectElement.checked;

    this.disabled = disabled;

    this.disabled = !this.data.permissions.mapping.edit;

    this.apiUrl = `${window.location.origin}${document.querySelector('meta[name=nglayouts-admin-base-path]').getAttribute('content')}`;

    this.modalGroups = {};

    [this.appEl] = document.getElementsByClassName('ng-layouts-app');

    if (this.id === '00000000-0000-0000-0000-000000000000') {
      this.el.classList.add('show-body');
      this.loadContent();
    }

    if (this.depth === 2 && this.modal.hasGroup) {
      this.disabled = true;
    }

    this.selectElement.disabled = this.disabled;


    this.setupEvents();
  }

  loadContent() {
    const url = `${this.apiUrl}/api/mappings/groups/${this.id}/list`;
    [this.groupBody] = this.el.getElementsByClassName('nl-group-body');
    this.groupBody.innerHTML = '';
    this.modalGroups = {};

    fetch(url, {
      method: 'GET',
    }).then((response) => {
      if (!response.ok) throw new Error(`HTTP error, status ${response.status}`);
      return response.text();
    }).then((data) => {
      const parsedData = JSON.parse(data);
      parsedData.groups.forEach((group) => {
        this.addModalGroup(group);
      });
    }).then(() => {
      Object.keys(this.modalGroups).forEach((key) => {
        this.groupBody.appendChild(this.modalGroups[key].el);
      });
    })
      .catch((error) => {
        console.log(error); // eslint-disable-line no-console
      });
  }

  addModalGroup(data) {
    const newModalGroupEl = document.createElement('div');
    newModalGroupEl.className = 'nl-group nl-element';
    newModalGroupEl.innerHTML = this.getGroupHtml(data.id, data.name);
    const newModalGroup = new NlMoveModalGroup(newModalGroupEl, data, this.modal, this.depth + 1, this.moving);
    this.modalGroups[data.id] = newModalGroup;
  }

  // eslint-disable-next-line class-methods-use-this
  getGroupHtml(id, name) {
    return `
      <div class="nl-group-content">
          <div class="nl-group-head">
              <div class="nl-rule-cell">
                  <div class="nl-export-checkbox">
                      <input type="checkbox" id="select${id}" classname="move-modal-group-select">
                      <label for="select${id}"></label>
                  </div>
              </div>
              <div class="nl-rule-cell group-title js-group-title">
                  <span class="icon-group-open">
                  </span>
                  <span class="icon-group">
                  </span>
                  <span class="icon-group-disabled-open">
                      <div class="disabled-tooltip">Group disabled</div>
                  </span>
                  <span class="icon-group-disabled">
                      <div class="disabled-tooltip">Group disabled</div>
                  </span>
                  <p>${name}</p>
              </div>
          </div>

          <div class="nl-group-body">
              <div class="nl-grid">
                  <div class="nl-group-list col-xs12"></div>
              </div>
          </div>
      </div>`;
  }

  handleCheckbox(id) {
    if (id !== this.id) {
      this.checkBoxContainer.style.visibility = '';
      this.selectElement.checked = false;
      this.selected = false;
      this.el.classList.remove('selected');
    } else {
      this.checkBoxContainer.style.visibility = 'visible';
      this.selected = true;
      this.el.classList.add('selected');
      this.modal.selectedGroup = this.data;
    }
    Object.keys(this.modalGroups).forEach(key => this.modalGroups[key].handleCheckbox(id));
  }

  setupEvents() {
    this.el.addEventListener('click', (e) => {
      if (e.target.closest('.js-group-title')) {
        e.stopPropagation();
        if (this.depth !== 2 && this.data.has_children) {
          this.el.classList.toggle('show-body');
          if (this.el.classList.contains('show-body')) {
            this.loadContent();
          }
        } else {
          // this.clearCheckboxes();
        }
      }
    });

    this.selectElement.addEventListener('change', () => {
      this.selectElement.checked ? this.modal.handleCheckbox(this.id) : this.modal.handleCheckbox(null);
    });
  }
}

/* modal plugin */
class NlModal {
  constructor(opt, parentModal = null) {
    this.options = Object.assign({
      preload: false,
      cancelDisabled: false,
      autoClose: true,
      body: '<p>Empty modal</p>',
      title: '',
      cancelText: 'Cancel',
      applyText: 'OK',
    }, opt);
    [this.appEl] = document.getElementsByClassName('layout-column');
    this.el = document.createElement('div');
    this.el.className = 'nl-modal-mask';
    if (this.options.className) this.el.classList.add(this.options.className);
    this.container = document.createElement('div');
    this.container.className = 'nl-modal-container';
    this.loader = document.createElement('div');
    this.loader.className = 'nl-modal-loader';
    this.loader.innerHTML = '<span></span>';

    // move modal extras
    this.modalGroups = {};
    this.parentModal = parentModal;
    this.selectedGroup = null;
    [this.chosenGroup] = document.getElementsByClassName('chosen-group');
    this.hiddenInput = document.getElementById('layout_wizard_rule_group');

    this.onKeyDown = (e) => {
      e.keyCode === 27 && this.close();
      e.keyCode === 13 && e.preventDefault();
    };

    this.onKeyDown = this.onKeyDown.bind(this);

    this.parentModal === null ? this.loadModal() : this.loadGroupModal();
    this.setupEvents();
  }

  deleteValidation() {
    const regex = new RegExp(this.deleteInput.pattern);
    if (regex.test(this.deleteInputValue)) {
      this.applyElement.disabled = false;
    } else {
      this.applyElement.disabled = true;
    }
  }

  loadModal() {
    this.options.preload ? this.loadingStart() : this.container.innerHTML = this.getHtml();
    this.el.appendChild(this.loader);
    this.el.appendChild(this.container);
    this.appEl.appendChild(this.el);
    window.addEventListener('keydown', this.onKeyDown);
  }

  handleCheckbox(id) {
    Object.keys(this.modalGroups).forEach(key => this.modalGroups[key].handleCheckbox(id));
    // id === null ? this.moveButton.disabled = true : this.moveButton.disabled = false;
  }

  loadContent() {
    const basePath = document.querySelector('[name="ngadminui-base-path"]').getAttribute('content');
    const apiUrl = `${window.location.origin}${basePath}`;
    const url = `${apiUrl}nglayouts/admin/api/mappings/groups/root`;
    [this.modalBody] = this.container.getElementsByClassName('nl-modal-body');
    // this.addModalGroup({ id: '00000000-0000-0000-0000-000000000000', name: 'root' });

    fetch(url, {
      method: 'GET',
    }).then((response) => {
      if (!response.ok) throw new Error(`HTTP error, status ${response.status}`);
      return response.text();
    }).then((data) => {
      const parsedData = JSON.parse(data);
      this.addModalGroup(parsedData.group);
    }).then(() => {
      this.modalBody.appendChild(this.modalGroups[Object.keys(this.modalGroups)[0]].el);
    })
      .catch((error) => {
        console.log(error); // eslint-disable-line no-console
      });
  }

  loadGroupModal() {
    this.container.innerHTML = this.getHtml();
    this.loadContent();
    this.el.appendChild(this.loader);
    this.el.appendChild(this.container);
    this.appEl.appendChild(this.el);
    window.addEventListener('keydown', this.onKeyDown);
    [this.moveButton] = this.container.getElementsByClassName('action-apply');
    [this.actions] = this.container.getElementsByClassName('nl-modal-actions');
    [this.modalWrapperEl] = this.container.getElementsByClassName('nl-modal');
    this.modalWrapperEl.style.display = 'flex';
    // this.group.moveId === null ? this.moveButton.disabled = true : null;
  }

  // eslint-disable-next-line class-methods-use-this
  getGroupHtml(id, name) {
    return `
    <div class="nl-group-content">
        <div class="nl-group-head">
            <div class="nl-rule-cell">
                <div class="nl-export-checkbox">
                    <input type="checkbox" id="select${id}" classname="move-modal-group-select">
                    <label for="select${id}"></label>
                </div>
            </div>
            <div class="nl-rule-cell group-title js-group-title">
                <span class="icon-group-open">
                </span>
                <span class="icon-group">
                </span>
                <span class="icon-group-disabled-open">
                    <div class="disabled-tooltip">Group disabled</div>
                </span>
                <span class="icon-group-disabled">
                    <div class="disabled-tooltip">Group disabled</div>
                </span>
                <p>${name}</p>
            </div>
        </div>

        <div class="nl-group-body">
            <div class="nl-grid">
                <div class="nl-group-list col-xs12"></div>
            </div>
        </div>
    </div>`;
  }

  addModalGroup(data) {
    const newModalGroupEl = document.createElement('div');
    newModalGroupEl.className = 'nl-group nl-element';
    newModalGroupEl.innerHTML = this.getGroupHtml(data.id, data.name);
    const newModalGroup = new NlMoveModalGroup(newModalGroupEl, data, this);
    this.modalGroups[data.id] = newModalGroup;
  }

  getHtml() {
    return `<div class="nl-modal">
                      <button class="close-modal"></button>
                      <div class="nl-modal-head">${this.options.title}</div>
                      <div class="nl-modal-body">${this.parentModal === null ? this.options.body : ''}</div>
                      <div class="nl-modal-actions">
                          <button type="button" class="nl-btn nl-btn-default action-cancel">${this.options.cancelText}</button>
                          <button type="button" class="nl-btn nl-btn-primary action-apply">${this.options.applyText}</button>
                      </div>
                  </div>`;
  }

  disableForm() {
    this.el.querySelector('#layout_wizard_layout').style.display = 'none';
    this.el.querySelector('#layout_wizard_layout').previousElementSibling.style.display = 'none';
    this.el.querySelector('#layout_wizard_layout_type').style.display = 'flex';
    this.el.querySelector('#layout_wizard_layout_type').previousElementSibling.style.display = 'block';
    // eslint-disable-next-line no-return-assign
    // document.getElementsByName('layout_wizard[layout_type]').forEach(el => el.disabled = false);
  }

  enableForm() {
    this.el.querySelector('#layout_wizard_layout').style.display = 'block';
    this.el.querySelector('#layout_wizard_layout').previousElementSibling.style.display = 'block';
    this.el.querySelector('#layout_wizard_layout_type').style.display = 'none';
    this.el.querySelector('#layout_wizard_layout_type').previousElementSibling.style.display = 'none';
    // eslint-disable-next-line no-return-assign
    // document.getElementsByName('layout_wizard[layout_type]').forEach(el => el.disabled = true);
  }

  checkForm() {
    this.el.querySelector('#layout_wizard_action_0').checked ? this.disableForm() : this.enableForm();
  }

  setupEvents() {
    this.el.addEventListener('click', (e) => {
      if (e.target.closest('.close-modal')) {
        this.close(e);
      } else if (e.target.closest('.action-apply')) {
        this.parentModal === null ? this.apply(e) : this.setChosenGroup();
      } else if (e.target.closest('.action-cancel')) {
        this.cancel(e);
      } else if (e.target.closest('.choose-group')) {
        e.preventDefault();
        window.removeEventListener('keydown', this.onKeyDown);
        const modal = new NlModal({
          preload: true,
          autoClose: false,
        }, this);
      } else if (e.target.closest('#layout_wizard_action_0') || e.target.closest('#layout_wizard_action_1')) {
        e.target.value === 'new_layout' ? this.disableForm() : this.enableForm();
      }
    });
  }

  setChosenGroup(e) {
    e && e.preventDefault();
    this.chosenGroup.innerHTML = this.selectedGroup.name;
    this.hiddenInput.value = this.selectedGroup.id;
    this.close();
  }

  apply(e) {
    e && e.preventDefault();
    this.el.dispatchEvent(new Event('apply'));
    this.options.autoClose && this.close();
  }

  cancel(e) {
    e && e.preventDefault();
    this.el.dispatchEvent(new Event('cancel'));
    this.close();
  }

  close(e) {
    e && e.preventDefault();
    this.el.dispatchEvent(new Event('cancel'));
    this.destroy();
    window.removeEventListener('keydown', this.onKeyDown);
    this.parentModal && this.parentModal.childClosed();
  }

  childClosed() {
    window.addEventListener('keydown', this.onKeyDown);
  }

  deleteSetup() {
    this.deleteInput = document.getElementById('delete-verification');
    [this.applyElement] = this.el.getElementsByClassName('action-apply');
    this.deleteInputValue = '';
    if (this.deleteInput) {
      this.applyElement.disabled = true;
    }

    if (this.deleteInput) {
      this.deleteInput.addEventListener('keyup', (e) => {
        this.deleteInputValue = e.target.value;
        this.deleteValidation();
      });
    }
  }

  insertModalHtml(html) {
    this.container.innerHTML = html;
    this.loadingStop();
    this.deleteSetup();
  }

  loadingStart() {
    this.el.classList.add('modal-loading');
  }

  loadingStop() {
    this.el.classList.remove('modal-loading');
  }

  destroy() {
    this.el.dispatchEvent(new Event('close'));
    this.el.parentElement && this.el.parentElement.removeChild(this.el);
  }
}


const submitModal = (url, modal, method, csrf, body, afterSuccess, afterError) => {
  fetch(url, {
    method,
    credentials: 'same-origin',
    headers: {
      'X-CSRF-Token': csrf,
    },
    body,
  }).then((response) => {
    if (!response.ok) {
      return response.text().then((data) => {
        modal.insertModalHtml(data);
        modal.checkForm();
        if (afterError) afterError();
        throw new Error(`HTTP error, status ${response.status}`);
      });
    }
    return response.text();
  }).then((data) => {
    // eslint-disable-next-line dot-notation
    const layoutUrl = JSON.parse(data)['layout_url'];
    // eslint-disable-next-line dot-notation
    const returnUrl = JSON.parse(data)['return_url'];
    window.localStorage.setItem('ngl_referrer', returnUrl);
    window.location.replace(layoutUrl);
    modal.close();
    // if (afterSuccess) afterSuccess(data);
    return true;
  }).catch((error) => {
    console.log(error); // eslint-disable-line no-console
  });
};


$(document).ready(function () {
  const $loginform = $('form[name="loginform"]');
  $loginform.attr('action', $loginform.attr('action') + window.location.hash);

  /* left column resize */
  (function () {
    if ($(window).width() > 800) {
      let colw = sessionStorage.getItem('lcw');
      const leftColumn = $('#left-column');
      // leftColumn.width(colw);
      // $('.search-form').width(colw);
      leftColumn.resizable({
        handles: 'e',
        alsoResize: '.search-form',
      });
      $('.ui-resizable-e').on('mouseup', function () {
        colw = leftColumn.width();
        sessionStorage.setItem('lcw', colw);
      });
    }
  }());
  /* */

  /* aside fold */
  (function () {
    const page = $('#page');
    const foldedClass = 'aside-folded';
    let settingsLink = '';
    const trigger = $('.aside-fold-trigger');
    const icon = trigger.find('i.fa');
    trigger.on('click', function (e) {
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
        url: settingsLink,
      });
    });
  }());
  /* */

  /* aside dropdown */
  (function () {
    $('.navi-wrap .aside-dropdown-toggle').dropdown();
    $('.user-dropdown-toggle').dropdown();
    const parent = $('.navi-wrap .aside-dropdown');
    const duration = 200;
    parent.on('show.bs.dropdown', function (e) {
      const y = $(this).offset().top + ($(this).outerHeight() / 2);
      const menu = $(this).find('.dropdown-menu').first();
      const menuH = menu.outerHeight();
      const menuTop = y - (menuH / 2);
      const menuBottom = window.innerHeight - menuH - menuTop;
      if (menuH > (window.innerHeight - 10)) {
        menu.css({ top: 10, bottom: 10 });
      } else if (menuTop < 5) {
        menu.css({ top: 10, bottom: 'auto' });
      } else if (menuBottom < 5) {
        menu.css({ bottom: 10, top: 'auto' });
      } else {
        menu.css({ top: y - (menuH / 2), bottom: 'auto' });
      }
      menu.stop(true, true).fadeIn({ queue: false, duration }).animate({ marginLeft: '+=50' }, duration);
    });
    parent.on('hide.bs.dropdown', function (e) {
      $(this).find('.dropdown-menu').first().stop(true, true)
        .fadeOut({ queue: false, duration })
        .animate({ marginLeft: '-=50' }, duration);
    });
    $('.dropdown-menu').on('click', function (e) {
      e.stopPropagation();
    });
  }());
  /* */

  /* aside folded tooltips */
  (function () {
    $('.aside-folded .aside-nav').on('mouseover', 'a', function () {
      const y = $(this).offset().top + ($(this).outerHeight() / 2);
      $(this).find('.tt').css('top', y);
    });
  }());
  /* */

  /* edit tabs */
  (function () {
    const control = $('.edit-tab-control');
    const trigger = control.find('a');
    const tabs = $('.edit-tabs');
    const tab = tabs.find('.tab');
    let groupId = false;
    let preferences = {};
    const preferenceStr = sessionStorage.getItem('netgen/ngadminui/preferences');

    if (preferenceStr) {
      preferences = JSON.parse(preferenceStr);
    }
    groupId = preferences.activeEditTab || false;

    trigger.on('click', function (e) {
      i = $(this).index();
      trigger.removeClass('active');
      $(this).addClass('active');
      tab.eq(i).fadeIn().siblings().hide();
      sessionStorage.setItem('netgen/ngadminui/preferences',
        JSON.stringify({ activeEditTab: $(this).attr('data-field-group') }));
      e.preventDefault();
    });

    if (groupId) {
      const selected = trigger.filter(`[data-field-group="${groupId}"]`);

      if (selected.length) {
        selected.click();
      } else {
        trigger.eq(0).click();
      }
    } else {
      trigger.eq(0).click();
    }
  }());
  /* */

  /* file upload */
  $('.btn-file').on('change', ':file', function () {
    const input = $(this);
    const numFiles = input.get(0).files ? input.get(0).files.length : 1;
    const label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
  });
  $('.btn-file :file').on('fileselect', function (event, numFiles, label) {
    const input = $(this).parents('.input-group').find(':text');
    const log = numFiles > 1 ? `${numFiles} files selected` : label;
    if (input.length) {
      input.val(log);
    } else if (log) alert(log);
  });
  /* */

  $('#page-datatype-container').on('click', 'a.show-hide-advanced-attributes', function (e) {
    e.preventDefault();
    const blockId = $(this).data('block-id');

    if (localStorage.getItem(`NgAdminUIAdvancedAttributesShown-${blockId}`) !== null) {
      $(`#id_${blockId} .advanced`).hide();
      localStorage.removeItem(`NgAdminUIAdvancedAttributesShown-${blockId}`);
      $(this).text($(this).data('show-text'));
    } else {
      $(`#id_${blockId} .advanced`).show();
      localStorage.setItem(`NgAdminUIAdvancedAttributesShown-${blockId}`, '1');
      $(this).text($(this).data('hide-text'));
    }
  });

  $('.form-siteaccess').on('change', 'select', function () {
    $(this).closest('form').submit();
  });

  /* edit path move */
  const breadcrumbDiv = $('#path');
  if (breadcrumbDiv.hasClass('path-edit')) {
    breadcrumbDiv.appendTo('.path-edit-container').fadeIn('fast');
  }

  $('.removeNodeConfirm').on('click', function () {
    $('#removePrompt').modal('show');
  });

  /* save current location ID to local storage when opening Netgen Layouts edit interface */
  $(document).on('click', '.js-open-ngl', function (e) {
    localStorage.setItem('ngl_referrer', window.location.href);
    e.currentTarget.dataset.valueId !== undefined && localStorage.setItem('ngl_referrer_value_id', e.currentTarget.dataset.valueId);
    e.currentTarget.dataset.valueType !== undefined && localStorage.setItem('ngl_referrer_value_type', e.currentTarget.dataset.valueType);
  });

  $(document).on('click', '.js-direct-mapping', (e) => {
    e.preventDefault();
    const locationId = document.querySelector('.mapped-layouts-box').dataset.url.split('/').pop();
    const basePath = document.querySelector('[name="ngadminui-base-path"]').getAttribute('content');
    const apiUrl = `${window.location.origin}${basePath}`;
    const slash = apiUrl.endsWith('/') ? '' : '/';
    const baseUrl = `${apiUrl}${slash}ngadmin/layouts`;
    const url = `${baseUrl}/${locationId}/wizard`;
    const modal = new NlModal({
      preload: true,
      autoClose: false,
    });
    const formAction = (ev) => {
      ev.preventDefault();
      modal.loadingStart();
      const formEl = modal.el.getElementsByTagName('FORM')[0];
      const afterSuccess = () => {};
      submitModal(url, modal, 'POST', this.csrf, new URLSearchParams(new FormData(formEl)), afterSuccess);
    };
    fetch(url, {
      method: 'GET',
    }).then((response) => {
      if (!response.ok) throw new Error(`HTTP error, status ${response.status}`);
      return response.text();
    }).then((data) => {
      modal.insertModalHtml(data);
      modal.disableForm();
      modal.el.addEventListener('apply', formAction);
    }).catch((error) => {
      console.log(error); // eslint-disable-line no-console
    });
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
  (function () {
    let toggleClassName = 'menu-visible';
    if ($('#left-column').length === 0) toggleClassName += ' without-left-menu';
    $('#menu-toggle').on('click', function () {
      $('body').toggleClass(toggleClassName);
    });
  }());

  /* edit layout box */
  function LayoutMapped(el, layouts) {
    this.$el = $(el);
    this.layouts = layouts;
    this.id = el.dataset.layoutId;
    this.ruleId = el.dataset.ruleId;
    this.$layoutCacheModal = this.$el.find('.layout-cache-modal');
    this.$layoutDeleteModal = this.$el.find('.layout-delete-modal');
    this.setupEvents();
  }
  LayoutMapped.prototype.setupEvents = function () {
    this.$el.find('.js-clear-layout-cache').on('click', this.openCacheModal.bind(this));
    this.$el.find('.js-clear-block-caches').on('click', this.clearBlockCaches.bind(this));
    this.$el.find('.js-rule-delete').on('click', this.openDeleteModal.bind(this));
    this.$layoutCacheModal.on('click', '.js-modal-confirm', this.clearLayoutCache.bind(this));
    this.$layoutDeleteModal.on('click', '.js-modal-confirm', this.deleteRule.bind(this));
  };
  LayoutMapped.prototype.openCacheModal = function (e) {
    e.preventDefault();
    this.$layoutCacheModal.find('.errors').remove();
    this.cacheModalStopLoading();
    this.$layoutCacheModal.modal('show');
  };
  LayoutMapped.prototype.openDeleteModal = function (e) {
    e.preventDefault();
    this.$layoutDeleteModal.find('.errors').remove();
    this.deleteModalStopLoading();
    this.$layoutDeleteModal.modal('show');
  };
  LayoutMapped.prototype.cacheModalStartLoading = function () {
    if (!this.$layoutCacheModal.find('.modal-loading').length) this.$layoutCacheModal.find('.modal-body').append('<div class="modal-loading"><i class="loading-ng-icon"></i></div>');
  };
  LayoutMapped.prototype.cacheModalStopLoading = function () {
    this.$layoutCacheModal.find('.modal-loading').remove();
  };
  LayoutMapped.prototype.deleteModalStartLoading = function () {
    if (!this.$layoutDeleteModal.find('.modal-loading').length) this.$layoutDeleteModal.find('.modal-body').append('<div class="modal-loading"><i class="loading-ng-icon"></i></div>');
  };
  LayoutMapped.prototype.deleteModalStopLoading = function () {
    this.$layoutDeleteModal.find('.modal-loading').remove();
  };
  LayoutMapped.prototype.clearLayoutCache = function (e) {
    e.preventDefault();
    const self = this;
    $.ajax({
      type: 'POST',
      url: `${this.layouts.basePath + this.id}/cache`,
      headers: {
        'X-CSRF-Token': this.layouts.csrf,
      },
      beforeSend() {
        self.$layoutCacheModal.find('.errors').remove();
        self.cacheModalStartLoading();
      },
      success() {
        self.$layoutCacheModal.modal('hide');
      },
      error(xhr) {
        const $resp = $(xhr.responseText);
        self.$layoutCacheModal.find('.modal-body').prepend($resp.find('.errors'));
        self.cacheModalStopLoading();
        console.log(xhr, 'Error clearing caches:', xhr.statusText);
      },
    });
  };
  LayoutMapped.prototype.indeterminateCheckboxes = function ($form) {
    const $checkboxes = [];
    const $submit = $form.find('button[type="submit"]');
    const changeState = function (arr) {
      let checkedNr = 0;
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
    const self = this;
    const afterModalRender = function ($form) {
      $form.find('.nl-btn').addClass('btn btn-primary');
      self.layouts.$blockCacheModal.find('.modal-title').html($form.find('.nl-modal-head'));
      self.indeterminateCheckboxes($form);
    };
    const formAction = function (el) {
      el.preventDefault();
      const $form = $(el.currentTarget);
      $.ajax({
        type: $form.attr('method'),
        url: $form.attr('action'),
        data: $form.serialize(),
        headers: {
          'X-CSRF-Token': this.layouts.csrf,
        },
        beforeSend() {
          self.layouts.cacheModalStartLoading();
        },
        success() {
          self.layouts.$blockCacheModal.modal('hide');
        },
        error(xhr) {
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
      url: `${this.layouts.basePath + this.id}/cache/blocks`,
      success: (data) => {
        const $form = $(data);
        afterModalRender($form);
        self.layouts.$blockCacheModal.find('.modal-body').html($form);
        $form.on('submit', formAction.bind(this));
      },
      error(xhr) {
        self.layouts.$blockCacheModal.find('.modal-body').html(xhr.responseText);
        self.layouts.cacheModalStopLoading();
      },
    });
  };
  LayoutMapped.prototype.deleteRule = function (e) {
    e.preventDefault();
    const self = this;
    $.ajax({
      type: 'DELETE',
      url: `/ngadmin/layouts/rules/${this.ruleId}/delete`,
      headers: {
        'X-CSRF-Token': this.layouts.csrf,
      },
      beforeSend() {
        self.$layoutDeleteModal.find('.errors').remove();
        self.deleteModalStartLoading();
      },
      success() {
        self.$layoutDeleteModal.modal('hide');
        self.$el.remove();
        $('.modal-backdrop').remove();
      },
      error(xhr) {
        const $resp = $(xhr.responseText);
        self.$layoutDeleteModal.find('.modal-body').prepend($resp.find('.errors'));
        self.deleteModalStopLoading();
        console.log(xhr, 'Error deleting:', xhr.statusText);
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
    const self = this;
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
    const self = this;
    $.ajax({
      type: 'GET',
      url: this.url,
      beforeSend() {
        self.showLoader();
      },
      success(data) {
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

const initBlockAttributesState = function () {
  $('.block-container').each(function () {
    const blockId = $(this).prop('id').replace('id_', '');
    const toggler = $(`#id_${blockId} .show-hide-advanced-attributes`);

    if (localStorage.getItem(`NgAdminUIAdvancedAttributesShown-${blockId}`) !== null) {
      $(`#id_${blockId} .advanced`).show();
      toggler.text(toggler.data('hide-text'));
    } else {
      $(`#id_${blockId} .advanced`).hide();
      toggler.text(toggler.data('show-text'));
    }
  });
};

ace.config.set('basePath', '/bundles/netgenadminui/bower/ace-builds/src-min-noconflict');
ace.require('ace/ext/language_tools');
