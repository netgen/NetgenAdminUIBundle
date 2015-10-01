(function(){
  'use strict';

  $.DetectLayout = {
    config: {
      480: 'xxs',
      481: 'xs',
      768: 'sm',
      992: 'md',
      1200: 'lg'
    },
    extend: function(config){
      $.extend(this.config, config);
    },
    current: null
  };

  var
    $window = $(window),
    $layout_element = $('html').css({position: 'relative'}),
    supportsOrientationChange = 'onorientationchange' in window,
    orientationEvent = supportsOrientationChange ? 'orientationchange' : 'resize',
    last = null,
    resize_end_to;

  var detect_layout = function(){
    var size = parseInt($layout_element.css('zIndex'), 10);
    var name = $.DetectLayout.config[size];
    return {
      name: name || 'unset',
      size: name ? size : 0
    };
  };

  var detect = function(e, opts){
    var layout = $.extend({}, opts, detect_layout());
    if(layout.size !== (last && last.size)){
      $.DetectLayout.current = last = layout;
      $window.trigger('responsive', layout);
      $window.trigger('responsive:' + layout.name, layout);
    }
  };

  // Defer to the end so we can attach events in app.js before triggering them
  setTimeout(function(){
    detect(null, {initial: true});
    $window.on(orientationEvent, detect);
  }, 0);

  $(window).on(orientationEvent, function(){
    clearTimeout(resize_end_to);
    resize_end_to = setTimeout(function(){
        $(window).trigger('resize:end');
    }, 100);
  });

})();
