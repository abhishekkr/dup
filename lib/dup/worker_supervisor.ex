defmodule Dup.WorkerSupervisor do
  @moduledoc false

  use DynamicSupervisor

  @me Application.get_env(:dup, :worker_supervisor)

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_worker do
    {:ok, _pid} = DynamicSupervisor.start_child(@me, Dup.Worker)
  end
end
