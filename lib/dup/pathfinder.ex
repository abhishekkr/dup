defmodule Dup.PathFinder do
  @moduledoc false

  use GenServer
  alias Vasuki.FileSystem.DirWalk

  @me Application.get_env(:dup, :pathfinder)

  ## GenServer impl

  def init(paths), do: {:ok, DirWalk.ls(paths)}

  def handle_call(:next_path, _from, filepath) do
    {:reply, filepath, DirWalk.next}
  end

  def handle_cast(:cleanup, _state), do: {:noreply, DirWalk.reset()}

  ## External API
  def start_link(rootpaths) do
    GenServer.start_link(__MODULE__, rootpaths, name: @me)
  end

  def next_path do
    GenServer.call(@me, :next_path)
  end

  def cleanup do
    GenServer.cast(@me, :cleanup)
  end
end
