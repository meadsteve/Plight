defmodule Plight.Handlers.MockControlHandler do
  def init(_transport, req, mock_routes) do
    {:ok, req, mock_routes}
  end

  def handle(req, mock_routes) do

    {mock_response_code, mock_response_body} = mock_body_from_request(req)
    mock_id = mock_route_from_request(req)

    IO.puts "mocking route #{mock_id}"

    mock_routes
    |> Plight.MockRoutes.add(mock_id, {mock_response_code, mock_response_body}, remove_in_minutes: 5)

    {:ok, req} = :cowboy_req.reply(200, [], "Mocked #{mock_id}", req)
    {:ok, req, mock_routes}
  end

  def terminate(_reason, _req, _mock_routes) do
    :ok
  end

  defp mock_body_from_request(req) do
    {mock_response_code, _} = :cowboy_req.binding(:code, req)
    {:ok, mock_response_body, _} = :cowboy_req.body(req)

    {mock_response_code, mock_response_body}
  end

  defp mock_route_from_request(req) do
    {method, _} = :cowboy_req.binding(:method, req)
    {path_to_mock, _} = :cowboy_req.path_info(req)
    uppercase_method = String.upcase(method)

    "#{uppercase_method}:/#{path_to_mock}"
  end

end
