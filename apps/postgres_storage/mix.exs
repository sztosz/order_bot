defmodule PostgresStorage.Mixfile do
  use Mix.Project

  def project do
    [app: :postgres_storage,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :ecto, :postgrex],
     mod: {PostgresStorage, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.12"}
    ]
  end

  defp aliases do
      ["ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
       "ecto.seed": ["run priv/repo/seeds.exs"],
       "ecto.reset": ["ecto.drop", "ecto.setup"],
       "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
    end
end
