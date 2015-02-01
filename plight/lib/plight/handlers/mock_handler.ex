defmodule Plight.Handlers.MockHandler do
  def init(_transport, req, mock_handler) do
    {:ok, req, mock_handler}
  end

  def handle(req, mock_handler) do
    IO.inspect mock_handler
    {mock_path, _} = :cowboy_req.path(req)
    IO.puts "Looking up mock for path: #{mock_path}"

    {response_code, response_message} = mock_handler |> Plight.MockRoutes.lookup mock_path

    {:ok, req} = :cowboy_req.reply(response_code, [], response_message, req)
    {:ok, req, mock_handler}
  end

  def terminate(_reason, _req, _mock_handler) do
    :ok
  end
end
