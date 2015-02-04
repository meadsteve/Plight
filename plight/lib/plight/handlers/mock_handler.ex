defmodule Plight.Handlers.MockHandler do
  def init(_transport, req, state) do
    {:ok, req, state}
  end

  def handle(req, state = {mock_handler, call_tracker}) do
    {mock_path, _} = :cowboy_req.path(req)
    {mock_method, _} = :cowboy_req.method(req)

    mock_id = "#{mock_method |> String.upcase}:#{mock_path}"

    IO.puts "Looking up mock for --> #{mock_id}"

    {response_code, response_message} = mock_handler |> Plight.MockRoutes.lookup mock_id
    call_tracker |> Plight.CallTracker.path_called(mock_id)

    {:ok, req} = :cowboy_req.reply(response_code, [], response_message, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _mock_handler) do
    :ok
  end
end
