ExUnit.start()

Mox.defmock(Binance.APIMock,
  for: Binance.APIBehaviour
)
Application.put_env(:binance, :binance_service, Binance.APIStub)
