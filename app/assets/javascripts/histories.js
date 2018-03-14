$(document).on('turbolinks:load', function() {
  var tabs = $('#transaction_tabs li');
  tabs.bind('click', function(event) {
    tabs.removeClass('active');
    $(event.target).parent().addClass('active');
  });
});
