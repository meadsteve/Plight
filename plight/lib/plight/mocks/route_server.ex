defmodule Plight.Mocks.RouteServer do
  use GenServer

  ## Gen server hooks
  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_call({:lookup, route}, _from, routes) do
    if (routes |> HashDict.has_key? route) do
      {:ok, {code, message}} = HashDict.fetch(routes, route)
      {:reply, {code, message}, routes}
    else
      {:reply, {404, "No match for the given route"}, routes}
    end
  end

  def handle_cast({:add, route, response}, routes) do
    {:noreply, routes |> HashDict.put(route, response)}
  end

  def handle_cast({:remove, route}, routes) do
    {_response, updated_routes} = routes |> HashDict.pop(route)
    {:noreply, updated_routes}
  end

end
