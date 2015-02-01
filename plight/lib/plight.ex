defmodule Plight do
  use Application

  def start(_type, _args) do

    mock_port = 9091
    control_port = 9092

    mock_routes = Plight.MockRoutes.start
    |> Plight.MockRoutes.add("/index.html", {200, "this is the mocked index"}, remove_in_minutes: 1)
    |> Plight.MockRoutes.add("/foo", {200, "bar"})

    assert_dispatch = :cowboy_router.compile([
      {:_, [{"/mock/[...]", Plight.Handlers.MockControlHandler, []}]},
      {:_, [{"/assert/[...]", Plight.Handlers.AssertHandler, []}]}
    ])

    mock_dispatch = :cowboy_router.compile([
      {:_, [{"/[...]", Plight.Handlers.MockHandler, mock_routes}]}
    ])

    {:ok, _} = :cowboy.start_http(:http_control, 100, [port: control_port], [env: [dispatch: assert_dispatch]])
    IO.puts "Asserting and control running at http://localhost:#{control_port}"


    {:ok, _} = :cowboy.start_http(:http_mock, 100, [port: mock_port], [env: [dispatch: mock_dispatch]])
    IO.puts "Mocking running at http://localhost:#{mock_port}"

    Plight.Supervisor.start_link
  end
end
