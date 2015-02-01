defmodule Plight.Handlers.MockControlHandler do
  def init(_transport, req, mock_routes) do
    {:ok, req, mock_routes}
  end

  def handle(req, mock_routes) do
    {method, _} = :cowboy_req.binding(:method, req)
    {path_to_mock, _} = :cowboy_req.path_info(req)

    uppercase_method = String.upcase(method)

    mock_id = "#{uppercase_method}:/#{path_to_mock}"

    IO.puts "mocking route #{mock_id}"

    mock_routes
    |> Plight.MockRoutes.add(mock_id, {200, "this is the mocked"}, remove_in_minutes: 5)

    {:ok, req} = :cowboy_req.reply(200, [], "Mocked #{mock_id}", req)
    {:ok, req, mock_routes}
  end

  def terminate(_reason, _req, _mock_routes) do
    :ok
  end
end
