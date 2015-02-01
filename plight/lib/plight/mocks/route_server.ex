defmodule Plight.Mocks.RouteServer do
  use GenServer

  ## Gen server hooks
  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:lookup, route}, _from, routes) do
    # TODO: look up routes
    {:reply, {404, "No match for the given route"}, routes}
  end

  def handle_cast({:add, route, response}, routes) do
    #TODO: add route
    {:noreply, routes}
  end

  # Domain logic

end
