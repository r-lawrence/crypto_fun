ExUnit.start()
# Ecto.Adapters.SQL.Sandbox.mode(CryptoEngine.Repo, :manual)
Application.put_env(:binance, :binance_service, Binance.APIStub)
Application.put_env(:binance, :binance_client, Binance.ClientStub)

Mox.defmock(Binance.APIMock,
  for: Binance.APIBehaviour
)
# Mox.defmock(Binance.APIMock,
#   for: Binance.APIBehaviour
# )
