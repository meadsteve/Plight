defmodule Plight.Supervisor do
  use Supervisor

  @mock_route_list Plight.MockRoutes

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Plight.MockRoutes, [[name: @mock_route_list]])
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end
