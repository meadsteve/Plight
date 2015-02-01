defmodule Plight.MockRoutes do

  def start(opts \\ []) do
    {:ok, pid} = GenServer.start_link(Plight.Mocks.RouteServer, :ok, opts)
    pid
  end

  def add(server, route, response) do
    GenServer.cast(server, {:add, route, response})
    server
  end

  def add(server, route, response, [remove_in_minutes: timeout]) do
    add(server, route, response, [remove_in_seconds: timeout * 60])
  end

  def add(server, route, response, [remove_in_seconds: timeout]) do
    GenServer.cast(server, {:add, route, response})
    spawn fn ->
      IO.puts "Queing route #{route} for removal in #{timeout} seconds"
      :timer.sleep(1000 * timeout)
      IO.puts "removing route #{route} as timeout has expired"
      Plight.MockRoutes.remove(server, route)
    end
    server
  end

  def remove(server, route) do
    GenServer.cast(server, {:remove, route})
    server
  end

  def lookup(server, route) do
    GenServer.call(server, {:lookup, route})
  end

end
