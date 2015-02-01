defmodule Plight.Handlers.MockHandler do
  def init(_transport, req, state) do
    {:ok, req, state}
  end

  def handle(req, state) do
    {mock_path, _} = :cowboy_req.path(req)
    IO.puts "Serving mocked path: #{mock_path}"
    {:ok, req} = :cowboy_req.reply(200, [], "hello world from #{mock_path}", req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
