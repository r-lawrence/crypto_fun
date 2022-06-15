# Crypto_fun 

[![CircleCI](https://circleci.com/gh/rlawrence9/crypto_fun/tree/main.svg?style=svg)](https://circleci.com/gh/rlawrence9/crypto_fun/tree/main)
[![codecov](https://codecov.io/gh/rlawrence9/crypto_fun/branch/main/graph/badge.svg?token=hZJnEHI7AS)](https://codecov.io/gh/rlawrence9/crypto_fun)

## About this App
> I started working for a company that contracts out devs in Oct 2021.  Because im not sure what information I can share about the work ive done for my current client, I created this app to demonstrate my fullstack web development knowledge using elixir/phoenix.

_**Crypto_fun is a phoenix umbrella application that consists of three apps:**_

**binance:**
- _controls the fetching, formating, and saving of currency inforamtion from the binance api to crypto_engine database. The app fetches all pricing data availible for Binance.us_

**crypto_engine**
- _is the database responsible for handling queries from both binance and crypto_web_

**crypto_web**
- _is the front end component that is running off a phoenix live view page, chart js, and custom js.  It allows the user to view a live graph of a selected crypto currency_


## Installation:
> in order to run this app locally you will have to have all the requirements installed for running a phoenix app on your pc or mac.  If you do not have these requirements please visit the [phoenix installation hex docs](https://hexdocs.pm/phoenix/installation.html)

1) ensure postgres is running locally: _i use a mac with homebrew, so for me the command is `brew services start postgresql`_
2) download the crypto_fun repo to your local. 
3) navigate into crypto_fun directory using `cd crypto_fun`
4) setup the repo and all its dependancies with `mix setup`
5) start your local server using `mix phx.server`
7) navigate to http://localhost:4000/ to view the app


## Notes:

> this app can use alot of modifications, but for MVP sake... it was it is.

> additional modifications to app may come over time, but nothing is promised

> App uses the Binance.us API for communication.  Additional logic can be ended to use the Binance API endpoints to buy/sell crypto currency.  Given the right price points for a currency, logic can be created to buy/sell the currency between the price point.  This would require alot of additional logic but hey, might be worth it 🙃.


