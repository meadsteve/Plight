defmodule Plight.Mocks.RouteServer do
  use GenServer

  ## Gen server hooks
  def init(:ok) do
    :erlang.process_flag(:trap_exit, true)
    {:ok, HashDict.new}
  end

  def handle_call({:lookup, route}, _from, routes) do
    if has_route?(routes,route) do
      {:ok, {code, message}} = HashDict.fetch(routes, route)
      {:reply, {code, message}, routes}
    else
      {:reply, {404, "No match for the given route"}, routes}
    end
  end

  def handle_call({:has_route, route}, _from, routes) do
      {:reply, has_route?(routes,route), routes}
  end

  def handle_cast({:add, route, response}, routes) do
    {:noreply, add_route(routes, route, response)}
  end

  def handle_cast({:add, route, response, :remove_in_micros, timeout}, routes) do
    server = self
    spawn_link fn ->
      IO.puts "Queing route #{route} for removal in #{timeout} microseconds"
      :timer.sleep(timeout)
      IO.puts "removing route #{route} as timeout has expired"
      send server, {self, :remove, route}
    end
    {:noreply, add_route(routes, route, response)}
  end

  def handle_cast({:remove, route}, routes) do
    {:noreply, routes |> remove_route route}
  end

  # messages

  def handle_info({_pid, :remove, route}, routes) do
    {:noreply, routes |> remove_route route}
  end

  def handle_info({:EXIT, _pid, why}, routes) when why == :normal do
    {:noreply, routes}
  end
  def handle_info({:EXIT, _pid, why}, routes) do
    IO.puts "Sleep process terminated unexpectedly because #{why}"
    {:noreply, routes}
  end

  def handle_info(msg, routes) do
    IO.puts "unknown message recieved by route_server"
    IO.inspect msg
    {:noreply, routes}
  end

  # Domain logic

  defp has_route?(routes, route) do
    routes |> HashDict.has_key? route
  end

  defp add_route(routes, route, response) do
    routes |> HashDict.put(route, response)
  end

  defp remove_route(routes, route) do
    {_response, updated_routes} = HashDict.pop(routes, route)
    updated_routes
  end

end
