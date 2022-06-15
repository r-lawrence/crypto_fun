defmodule Crypto.Fun.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp deps do
    []
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      setup: ["cmd mix deps.get", "cmd mix deps.compile"],
      "test:coveralls": ["cmd --app binance mix coveralls.json", "cmd --app crypto_engine mix coveralls.json", "cmd --app crypto_web mix coveralls.json"],
      test: ["cmd --app binance mix test --color", "cmd --app crypto_engine mix test --color", "cmd --app crypto_web mix test --color"],
      "test:binance": "cmd --app binance mix test --color",
      "test:crypto_engine": "cmd --app crypto_engine mix test --color",
      "test:crypto_web": "cmd --app crypto_web mix test --color"

    ]
  end
end
