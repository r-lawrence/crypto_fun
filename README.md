# CryptoTrader.Umbrella
[![CircleCI](https://circleci.com/gh/rlawrence9/crypto_fun/tree/main.svg?style=svg)](https://circleci.com/gh/rlawrence9/crypto_fun/tree/main)
[![codecov](https://codecov.io/gh/rlawrence9/crypto_fun/branch/main/graph/badge.svg?token=hZJnEHI7AS)](https://codecov.io/gh/rlawrence9/crypto_fun)

## whatsss up - this is a simple app I created using binance API, elixir/phoenix, sprinkled with some chart js.  I picked up elixir about 6 months ago, this app was built in like month actual working time... so it might not be perfect =) - but eyyyy, you can use it to buy and sell some of your currency with the right price algo and new API endpoint functionality 🤙

## throughought the app, im going to try leave solid documentation on whats going on and why.  Im also going to drop the current problems the app has, possible modifications, and yeah idk - take it and run.

## in future this repo will be close to 100% test coverage and will be set up with circle CI.  Im one man dev team so im trying 💻


## this app functions as an umbrella app (a series of apps that function as a whole).  Some important things to note:
  ## currently the app consists of three parts, one of which is not really being used.
    ## Binance 
      - Binance is a custom application made that handles getting data from the binance API and passes it to the live view template to be rended
    ## crypto_trader
      - this was a standard postgres DB setup that came when generatin the crypto_trader app
      using `mix phx.new`  ---> check the docs for more info 🙃 https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html

      - the idea of having it is at some point storing data, may seem like a good idea.
        > thought: starting links for all crypto curriencies on binance for 24hrs, saving the data to local state, at 24 hour mark dropping data in database, reset local state.  
          > question can elixir gen server handle that kind of state? without crashing?
          > how can you set up a cache with live data lol?
  
    ## crypto_trader_web
      - this application currently only is using a liveview page to render life chart data with chart js.  Essentially when loading http://localhost:4000/live-chart, it starts the Binance.Client GenServer with a default coin of BTC.  Pricing data is being fetched every 5 seconds, so its send around that long as well.  How often the price can be fetched can all be updated in the functionality.

## to get started grooving with this app....  Your first gonna have to open open up spotify or any other music platform of choice, throw on the headset, volume ⬆️, and crank your favorite tunes 🎧

## if you are new to elixir/phoenix thats ok! its pretty fun, its functional, and you might not go back to JS for back end related things.  check out the docs for getting elixir/phoenix set up on your local here https://hexdocs.pm/phoenix/installation.html 👈 this will give you instructions to every package that needs to be installed in order for the app to run locally.  


## after you have followed the above install instructions, to get the app running locally. run
  ## `mix deps.get`
  ## `mix ecto.create`
  ## `mix deps.compile`
  ## `mix phx.server`

## navigate to localhost:4000/livechart - assuming no terminal errors have been thrown a graph defualting to current BTC price should appear and start updating.

## last thing, this app was built as to showcase my ability to learn a completely new language/framework and build a custom web application that uses a socket connection to display realtime pricing data from the Binance API, using chart.js. Additionally, when finished this app will be configured with complete test coverage and CI automation to demonstrate understanding of fullstack application development. 


## CURRENT STATE OF APPLICATION - MVP IN PROGRESS 
  ## beware - downloading this application at this time is not recommended as it only contains basic display functionality for a few currencies, non-dry code, is not well tested
      ## current MVP goals
        - 90%+ test coverage throughout app, including chart.js functionality
        - ability to access a live graph of any crypto currency currently offered by Binance.US
        - an additional display that appears under the crypto currency selection area - showing the current price of coin (updated with graph but just here for eye candy), 24 hour price change statistics, and a rotating average price (updating every 1min)

      ## current refactor goals
        - get tests up and CI up - CI should be able to build the app and run the tests from each application file.  This should include tests for chart js
          - test coverage should be 90% + for all files
        - refactor non dry code - currently there is a ton of it in this repo.  When building I was rolling on the fly, so getting things working was a priority.

      ## reach goals
        - add css to make app look nice
        - add the coinbase API endpoint functionality as another application and allow for users to not only view binance pricing information but also coin base 
          - this can probably be expanded to all current crypto exchanges
        - add DB sav functionality, so that the current pricing data be gathered by app is saved every 24 hours.
          - later functionality could allow for the display of previous days live price by 5 second incriments or data could be used in some sort of pricing algo
        - configure app to allow for actual trading based on two price points.


