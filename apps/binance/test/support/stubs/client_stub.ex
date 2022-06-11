defmodule Binance.ClientStub do
  @behaviour Binance.ClientBehavior
  @spec handle_call(atom(), pid(), map()) :: tuple()
  def handle_call(:get, _from, state) do
    {:noreply, state, state}
  end
end
