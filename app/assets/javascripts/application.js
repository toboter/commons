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
//= require jquery.filer
//= require turbolinks
//= require turbolinks-compatibility
//= require_tree .

$(document).ready(function() {
  $("#tag_names").select2({
    tags: true,
    tokenSeparators: [','],
    theme: "bootstrap"
  });
  $("#tag_search").select2({
    placeholder: "Select tags (separate by comma, search by enter)",
    tokenSeparators: [','],
    theme: "bootstrap"
  });
  $('.select2-selection').on('keyup', function (e) {
    if (e.keyCode === 13) {
      $(this).closest('form').submit();
    }
  });
});