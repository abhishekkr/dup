defmodule Dup.Gatherer do
  use GenServer

  @me Application.get_env(:dup, :gatherer)

  ## GenServer impl
  def init(state) do
    Process.send_after(self(), :kickoff, 0)
    {:ok, state}
  end

  def handle_info(:kickoff, [cli: _, worker_count: count] = state) do
    1..count
    |> Enum.each(fn _ -> Dup.WorkerSupervisor.add_worker() end)
    {:noreply, state}
  end

  def handle_cast(:done, [cli: pid, worker_count: 1]) do
    send(pid, :done)
  end
  def handle_cast(:done, [cli: pid, worker_count: count]) do
    {:noreply, [cli: pid, worker_count: count - 1]}
  end

  def handle_cast({:result, hash, path}, state) do
    Dup.Results.add_hash_for(hash, path)
    {:noreply, state}
  end

  ## External API
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: @me)
  end

  def done, do: GenServer.cast(@me, :done)

  def result(hash, path), do: GenServer.cast(@me, {:result, hash, path})
end
