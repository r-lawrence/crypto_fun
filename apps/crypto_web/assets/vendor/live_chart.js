const Chart = require("chart.js");

//A Canvas dom element with ID "lineChart" is where our chart will display


export const LiveChart = {
createChart: (labels, data, symbol) => {

  var ctx = document.getElementById("live-chart").getContext("2d");
  return new Chart(ctx, {
    type: "line",
    data: {
      //we make sure of the following variable to available in the template that uses this JS file and it act as X-Axis
      labels: labels,
      datasets: [
        {
          label: symbol + " live",

          // Adjust the colors and Background here if you need
          backgroundColor: "rgba(155, 89, 182,0.2)",
          borderColor: "rgba(142, 68, 173,1.0)",
          pointBackgroundColor: "rgba(142, 68, 173,1.0)",

          //we make sure of the following variable to available in the template that uses this JS
          data: data,
        },

      ],
    },

  })
 }
}
