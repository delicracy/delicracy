$(document).on('turbolinks:load', function() {
  // renderAllLaneCharts();
  $('#lanes_list').on('keyup', '[id^=offer_lot]', updateExpectedVolume);
});

function updateExpectedVolume(event) {
  var target_id = $(this).data('target');
  var volume = $(this).val() * ($(this).data('price'))
  $('#' + target_id).text(number_with_delimiter(Math.round(volume)));
}

function renderAllLaneCharts() {
  var num_of_lanes_regular = $('#lanes_regular_list').data('length');
  var num_of_lanes = $('#lanes_list').data('length');

  for (var i = 0; i < num_of_lanes_regular; i++) {
    renderLaneChart('lane_chart_default_' + i);
  }

  for (var i = 0; i < num_of_lanes; i++) {
    renderLaneChart('lane_chart_maximum_' + i);
  }
}

function renderLaneChart(chart_id) {
  var percent = $('#' + chart_id).data('percent');
  CanvasJS.addColorSet("circleColorSet", [
    "#497DFF",
    "#DEDCE5"
  ]);
  var chart = new CanvasJS.Chart(chart_id,
    {
      // backgroundColor: "#F6F9FA",
      colorSet: "circleColorSet",
      interactivityEnabled: false,
      toolTip: {
        enabled: false
      },
      data: [
        {
          type: "pie",
          startAngle: -90,
          dataPoints: [
            { y: percent / 100 },
            { y: 1 - percent / 100 },
          ]
        }
      ]
    }
  );
  chart.render();
}
