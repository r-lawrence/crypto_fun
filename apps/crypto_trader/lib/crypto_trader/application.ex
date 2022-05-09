defmodule CryptoTrader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CryptoTrader.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CryptoTrader.PubSub}
      # Start a worker by calling: CryptoTrader.Worker.start_link(arg)
      # {CryptoTrader.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: CryptoTrader.Supervisor)
  end
end
