defmodule Plight.Handlers.AssertHandler do
  def init(_transport, req, state) do
    {:ok, req, state}
  end

  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply(200, [], "hello world from assertion", req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
