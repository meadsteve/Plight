defmodule Plight.Supervisor do
  use Supervisor

  @mock_route_list Plight.MockRoutes

  def start_link (opts \\ []) do
    :supervisor.start_link(__MODULE__, opts)
  end

  def init(http_servers) do
    children = get_default_children
    |> add_servers(http_servers)

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end


  defp get_default_children() do
    [
      worker(Plight.MockRoutes, [[name: @mock_route_list]])
    ]
  end

  defp add_servers(current_children, [http_servers: [server_args|remaining]]) do
    add_servers(
      [get_server_worker(server_args) | current_children],
      [http_servers: remaining]
    )
  end
  defp add_servers(current_children, [http_servers: []]) do
    current_children
  end

  defp get_server_worker(server_args) do
    [server_id | _tail] = server_args
    worker(:cowboy, server_args, function: :start_http, id: server_id)
  end

end
