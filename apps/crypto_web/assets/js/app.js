// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"


// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import {LiveChart} from "../vendor/live_chart.js"


/* hooks can be defined in a different file and imported here to 
 allow for more organization. */


const Hooks = {}
Hooks.usd = {
  mounted() {
    this.el.addEventListener("input", (e) => {
      e.preventDefault()

       pushCoinChangeEvent(this, e.target.value)
      //  this.pushEvent("inc_coin_change", {value: e.target.value})
    })
  }
}

Hooks.btc = {
  mounted() {
    this.el.addEventListener("input", (e) => {
      e.preventDefault()

      pushCoinChangeEvent(this, e.target.value)
      //  this.pushEvent("inc_coin_change", {value: e.target.value})
    })
  }
}

Hooks.usdt = {
  mounted() {
    this.el.addEventListener("input", (e) => {
      e.preventDefault()

      pushCoinChangeEvent(this, e.target.value)
      //  this.pushEvent("inc_coin_change", {value: e.target.value})
    })
  }
}
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


// if we are currently on live chart page, render the live chart
const isLiveChart = document.getElementsByClassName("live-chart").length
if (isLiveChart) {
let selectedType, start, end, currentType, currentChart
window.addEventListener('phx:element-updated', (e) => {

  if (!currentChart) {
    currentChart = LiveChart.createChart([], [])
  } 

  let loadingSpan = document.querySelector("span#loading")
  loadingSpan.classList.add("hide")

  let chartSection = document.querySelector("section.live-chart")
  chartSection.classList.remove("hide")

  let selectElements = document.getElementsByTagName("select")

  currentSymbol = e.detail.selectedSymbol
  start = currentSymbol.length - 3
  end = currentSymbol.length
  selectedType = currentSymbol.substring(start, end)

  if (selectedType !== currentType) {

    currentType = selectedType
    removeSelection(selectElements)
  }

  handleSelectType(selectedType)

  let formattedTimes = e.detail.labels.map((label) => {
    label = new Date(label)
    return label.toLocaleTimeString()
  })

  currentChart.config.data.labels = formattedTimes
  currentChart.config.data.datasets[0].data = e.detail.data
  currentChart.config.data.datasets[0].label = e.detail.selectedSymbol + " Live (updated every 5 seconds with current price)"
  handle_sizing(currentChart)
  currentChart.update()
  })
}

const handle_sizing = (chart) => {
  chart.canvas.parentNode.style.height = '40%';
  chart.canvas.parentNode.style.width = '80%';
  chart.canvas.parentNode.style.marginRight = 'auto';
  chart.canvas.parentNode.style.marginLeft = 'auto';
}
// below can be moved to helper for better oraganization.
const pushCoinChangeEvent = (element, value) => {
  element.pushEvent("inc_coin_change", {value: value})
}

const handleSelectType = (type) => {
  switch(type) {
    case "USD":
      addSelect("usd")
      break
    case "BTC":
      addSelect("btc")
      break
    case "SDT": 
      addSelect('usdt')
      break
  }
}

const addSelect = (id) => {
  currentSelect = document.getElementById(id)
  currentSelect.classList.add("selected")

}

const removeSelection = (selectElements) => {
  Array.from(selectElements).forEach((element) => {
    if (element.className.length) {
      element.className = ""
    }

  })
  return selectElements
} 