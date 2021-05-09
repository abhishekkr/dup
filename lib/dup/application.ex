defmodule Dup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Dup.Results,
      {Dup.WorkerSupervisor, :no_args}
      # Starts a worker by calling: Dup.Worker.start_link(arg)
      # {Dup.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Dup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
