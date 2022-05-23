ExUnit.start()

Application.put_env(:binance, :binance_service, Binance.APIStub)

Mox.defmock(Binance.APIMock,
  for: Binance.APIBehaviour
)
