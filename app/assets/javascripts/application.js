// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require select2-full
//= require cocoon
//= require filterrific/filterrific-jquery
//= require bootstrap-markdown-bundle
//= require jquery-fileupload
//= require clipboard
//= require best_in_place
//= require magnific-popup
//= require turbolinks
//= require turbolinks-compatibility
//= require_tree .

$(document).ready(function() {

  $('.lightbox-link').magnificPopup({
    type: 'image',
    mainClass: 'mfp-with-zoom',
    
    zoom: {
      enabled: true, // By default it's false, so don't forget to enable it

      duration: 300, // duration of the effect, in milliseconds
      easing: 'ease-in-out', // CSS transition easing function

      // The "opener" function should return the element from which popup will be zoomed in
      // and to which popup will be scaled down
      // By defailt it looks for an image tag:
      opener: function(openerElement) {
        // openerElement is the element on which popup was initialized, in this case its <a> tag
        // you don't need to add "opener" option if this code matches your needs, it's defailt one.
        return openerElement.is('img') ? openerElement : openerElement.find('img');
      }
    }

  });

  // Activating Best In Place
  jQuery(".best_in_place").best_in_place();

  // Tooltip
  $('.clipboard-btn').tooltip({
    trigger: 'click',
    placement: 'left'
  });

  function setTooltip(btn, message) {
    $(btn).tooltip('hide')
      .attr('data-original-title', message)
      .tooltip('show');
  }

  function hideTooltip(btn) {
    setTimeout(function() {
      $(btn).tooltip('hide');
    }, 1000);
  }

  // Clipboard
  var clipboard = new Clipboard('.clipboard-btn');

  clipboard.on('success', function(e) {
    setTooltip(e.trigger, 'URL Copied!');
    hideTooltip(e.trigger);
  });

  clipboard.on('error', function(e) {
    setTooltip(e.trigger, 'Failed!');
    hideTooltip(e.trigger);
  });


  // Select2
  $("#tag_names").select2({
    tags: true,
    tokenSeparators: [','],
    theme: "bootstrap"
  });

  $("select").on("select2:select", function(evt) {
      var element = evt.params.data.element;
      var $element = $(element);
      $element.detach();
      $(this).append($element);
      $(this).trigger("change");
  });

});