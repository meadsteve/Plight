defmodule Plight.CallTracker do

  def start_link(opts \\ []) do
    GenServer.start_link(Plight.CallTracker.Server, :ok, opts)
  end

  def path_called(server, path) do
    GenServer.cast(server, {:path_called, path})
    server
  end

  def was_path_called?(server, path) do
    GenServer.call(server, {:was_path_called?, path})
  end

end
