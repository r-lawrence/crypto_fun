defmodule Binance.APIMock do
  use ExUnit.CaseTemplate

  setup do
    Mox.stub_with(
      Binance.APIMock,
      Binance.APIStub
    )

    # more stub_with/2 calls possible
    :ok
  end
end
