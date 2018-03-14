$(document).on('turbolinks:load', function() {
  $('#main_menu').bind('click', function() {
    openMainNav();
  });

  $('a#close').bind('click', function(){
    closeMainNav();
  });

  if ($('.alert')) {
    autoDismissAlert($('.alert'), 3000);
  }
});

function openMainNav() {
  $('#side_nav').show();
  $('#tracing_contents').show();
  $('#tracing_contents').bind('click', function() {
    closeMainNav();
  });
}

function closeMainNav() {
  $('#side_nav').hide();
  $('#tracing_contents').hide();
  $('#tracing_contents').unbind('click');
}

function number_with_delimiter(number) {
  return String(number).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function autoDismissAlert(selector, duration) {
  setTimeout(function () {
    selector.fadeOut();
  }, duration);
}

function newWindow(url) {
  window.open(url, '_blank');
  return false;
}
