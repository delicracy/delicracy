$(document).on('turbolinks:load', function() {
  renderAllLaneCharts(); // in lane.js
  adjustChatHeight();  
  injectSrcToChatFrame();
  bindToggleWigetPages();
  toggleCollapseButtons();
  closeChatMembers();
  renderLaneChartsInIndexPage();
  // toggleLaneDetails();

  $('#widget_large').hide(); // HACK
  
  var race_id = $('#chartContainer').data('race');
  if (race_id) {
    var url = "/races/" + race_id + "/data_series";
    $.getJSON(url)
      .done(function(data) {
        renderChart(data);
      })
      .fail(function() {
        console.log("Rendering Chart Error.");
      });
  }
});

function bindToggleWigetPages() {
  $('#widget_small').bind('click', function(event) {
    $(this).hide();
    $('#widget_regular').show();
  });

  $('#widget_regular').bind('click', function(event) {
    $(this).hide();
    $('#chat_section').hide();
    $('header.navbar').hide();
    $('#widget_large').show();
  });

  $('#close_large').bind('click', function(event) {
    event.preventDefault();
    $('#widget_large').hide();
    $('header.navbar').show();
    $('#chat_section').show();
    $('#widget_small').show();
  });

  $('#widget_regular').hide();
}

function toggleLaneDetails() {
  var lane_titles = $("[id^=lane_title_]");
  var lane_details = $("[id^=lane_detail_]");

  lane_details.hide();
  lane_titles.bind('click', function(event){
    event.preventDefault();
    lane_details.hide();
    $(this).parent().find("[id^=lane_detail_]").show();
  });

}

function renderChart(data) {
  var chart = new CanvasJS.Chart("chartContainer", {
    backgroundColor: "#F6F9FA",
    toolTip: {
      shared: true
    },
    axisX:{
      title: "timeline",
    },
    axisY: {
      title: "Price",
      gridThickness: 0
    },
    data: data
  });
  chart.render();

  $('#widget_large').hide();
}

function injectSrcToChatFrame() {
  var chat_frame = $('#chat_frame');
  var src = chat_frame.data('src');
  chat_frame.attr('src', src); 
}

function toggleCollapseButtons() {
  $('#widget_large div.panel-collapse').each(function () {
    $(this).on('shown.bs.collapse', function () {
      $(this).prev().find('i.glyphicon-menu-down')
        .removeClass('glyphicon-menu-down text-muted').addClass('glyphicon-menu-up');
    });

    $(this).on('hidden.bs.collapse', function () {
      $(this).prev().find('i.glyphicon-menu-up')
        .removeClass('glyphicon-menu-up').addClass('glyphicon-menu-down text-muted');
    });
  });
}

function closeChatMembers() {
  $('#chat_members_list a#close_button').bind('click', function (event) {
    event.preventDefault();
    $('#chat_members_list').hide();
  })
}

function adjustChatHeight() {
  $('#chat_frame').height($(window).height() - $('header.navbar').height() - 35);
}

function renderLaneChartsInIndexPage() {
  $('#races .list-group').find("[id^='lane_chart']").each(function (index, element) {
    renderLaneChart($(this).attr('id'));
  });
}
