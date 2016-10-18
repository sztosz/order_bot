defmodule PostgresStorage do
  @moduledoc false

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Storage.Worker.start_link(arg1, arg2, arg3)
      # worker(Storage.Worker, [arg1, arg2, arg3]),
      worker(PostgresStorage.Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PostgresStorage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end