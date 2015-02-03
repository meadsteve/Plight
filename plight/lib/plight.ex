defmodule Plight do
  use Application

  @mock_route_list Plight.MockRoutes

  def start(_type, _args) do

    mock_port = 9091
    control_port = 9092

    assert_dispatch = :cowboy_router.compile([
      {:_, [
        {"/mock/:method/:code/[...]", Plight.Handlers.MockControlHandler, @mock_route_list},
        {"/assert/[...]", Plight.Handlers.AssertHandler, []}
        ]
      }
    ])

    mock_dispatch = :cowboy_router.compile([
      {:_, [{"/[...]", Plight.Handlers.MockHandler, @mock_route_list}]}
    ])

    # Everything here will be called with :cowboy.start_http and supverised
    cowboy_http_servers = [
      [:http_control, 100, [port: control_port], [env: [dispatch: assert_dispatch]]],
      [:http_mock, 100, [port: mock_port], [env: [dispatch: mock_dispatch]]]
    ]

    IO.puts "Asserting and control running at http://localhost:#{control_port}"
    IO.puts "Mocking running at http://localhost:#{mock_port}"

    Plight.Supervisor.start_link http_servers: cowboy_http_servers

  end
end
