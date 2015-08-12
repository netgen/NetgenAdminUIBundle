$(document).ready(function(){
	/* left column resize */
	(function(){
		var colw = sessionStorage.getItem('lcw'),
			leftColumn = $('#left-column');
		leftColumn.width(colw);
		leftColumn.resizable({
			handles: 'e'
		});
		$('.ui-resizable-e').on('mouseup', function(){
			colw = leftColumn.width();
			sessionStorage.setItem('lcw', colw);
		});
	})();
	/* */

	/* aside fold */
	(function(){
		var page = $('#page'),
			foldedClass = 'aside-folded',
			settingsLink = '',
			trigger = $('.aside-fold-trigger'),
			icon = trigger.find('i.fa');
	    trigger.on('click', function(e){
	    	e.preventDefault();
	    	if (page.hasClass(foldedClass)) {
	    		page.removeClass(foldedClass);
	    		settingsLink = '/user/preferences/set/admin_aside_fold_control/1';
	    	} else {
	    		page.addClass(foldedClass);
	    		settingsLink = '/user/preferences/set/admin_aside_fold_control/0';
	    	};
    		icon.toggleClass('fa-dedent fa-indent');
	    	$.ajax({
			  method: 'POST',
			  url: settingsLink
			})
	    });
	})();
	/* */

	/* aside dropdown */
	(function(){
		var trigger = $('.navi-wrap .dropdown'),
			duration = 200;
		trigger.on('show.bs.dropdown', function(e){
			var y = $(this).offset().top + ($(this).outerHeight() / 2),
				menu = $(this).find('.dropdown-menu').first(),
				menuH = menu.outerHeight(),
				menuTop = y - (menuH / 2),
				menuBottom = window.innerHeight - menuH - menuTop;
			if (menuH > (window.innerHeight - 10)) {
				menu.css({'top': 10, 'bottom': 10});
			} else if (menuTop < 5) {
				menu.css({'top': 10, 'bottom': 'auto'});
			} else if (menuBottom < 5) {
				menu.css({'bottom': 10, 'top': 'auto'});
			} else {
			    menu.css({'top': y - (menuH / 2), 'bottom': 'auto'});
			};
		    menu.stop(true, true).fadeIn({queue:false, duration:duration}).animate({marginLeft:'+=50'}, duration);
		});
		trigger.on('hide.bs.dropdown', function(e){
		    $(this).find('.dropdown-menu').first().stop(true, true).fadeOut({queue:false, duration:duration}).animate({marginLeft:'-=50'}, duration);
		});
		$('.dropdown-menu').on('click', function(e){
			e.stopPropagation();
		})
	})();
	/* */

	/* aside folded tooltips */
	(function(){
		$('.aside-folded .aside-nav').on('mouseover', 'a', function(){
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
			i = 0;
		trigger.eq(0).addClass('active');
		tab.not(tab.eq(0)).hide();
		trigger.on('click', function(e){
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
        if( input.length ) {
            input.val(log);
        } else {
            if( log ) alert(log);
        }
    });
    /* */

    $('#page-datatype-container').on( 'click', 'a.show-hide-advanced-attributes', function(e){
        e.preventDefault();
        var blockId = $(this).data('block-id');

        if(localStorage.getItem('NgMoreAdvancedAttributesShown-' + blockId) !== null) {
            $('#id_' + blockId + ' .advanced').hide();
            localStorage.removeItem('NgMoreAdvancedAttributesShown-' + blockId);
            $(this).text($(this).data('show-text'));
        }
        else {
            $('#id_' + blockId + ' .advanced').show();
            localStorage.setItem('NgMoreAdvancedAttributesShown-' + blockId, '1');
            $(this).text($(this).data('hide-text'));
        }
    });
});

var initBlockAttributesState = function(){
    $('.block-container').each(function(){
        var blockId = $(this).prop('id').replace('id_', '');
        var toggler = $('#id_' + blockId + ' .show-hide-advanced-attributes');

        if(localStorage.getItem('NgMoreAdvancedAttributesShown-' + blockId) !== null) {
            $('#id_' + blockId + ' .advanced').show();
            toggler.text(toggler.data('hide-text'));
        }
    });
};
