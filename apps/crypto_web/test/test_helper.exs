ExUnit.start()
# Ecto.Adapters.SQL.Sandbox.mode(CryptoEngine.Repo, :manual)
Mox.defmock(Binance.APIMock,
  for: Binance.APIBehaviour
)
Application.put_env(:binance, :binance_service, Binance.APIStub)

Mox.defmock(CryptoWeb.LiveChartMock,
  for: CryptoWeb.LiveChartBehaviour
)
Application.put_env(:crypto_web, :genserver_adapter, CryptoWeb.LiveChartStub)
