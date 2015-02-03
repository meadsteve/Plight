defmodule Plight.MockRoutes do

  def start_link(opts \\ []) do
    GenServer.start_link(Plight.Mocks.RouteServer, :ok, opts)
  end

  def add(server, route, response) do
    GenServer.cast(server, {:add, route, response})
    server
  end

  def add(server, route, response, [remove_in_minutes: timeout]) do
    add(server, route, response, [remove_in_micros: timeout * 60 * 1000])
  end

  def add(server, route, response, [remove_in_seconds: timeout]) do
    add(server, route, response, [remove_in_micros: timeout * 1000])
  end

  def add(server, route, response, [remove_in_micros: timeout]) do
    GenServer.cast(server, {:add, route, response})
    spawn fn ->
      IO.puts "Queing route #{route} for removal in #{timeout} seconds"
      :timer.sleep(timeout)
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

  def has_route?(server, route) do
    GenServer.call(server, {:has_route, route})
  end
end
