defmodule Plight.MockRoutes do

  def start(opts \\ []) do
    {:ok, pid} = GenServer.start_link(Plight.Mocks.RouteServer, :ok, opts)
    pid
  end

  def add(server, route, response) do
    GenServer.cast(server, {:add, route, response})
  end

  def lookup(server, route) do
    GenServer.call(server, {:lookup, route})
  end

end
