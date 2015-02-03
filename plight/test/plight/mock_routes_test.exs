defmodule Plight.MockRoutesTest do
    use ExUnit.Case, async: true

  setup do
    {:ok, routes} = Plight.MockRoutes.start_link
    {:ok, routes: routes}
  end

  test "Creates Route", %{routes: routes} do
    test_route = "get:/index.html"

    assert Plight.MockRoutes.has_route?(routes, test_route) == false
    Plight.MockRoutes.add(routes, test_route, {200, "ok"})
    assert {200, "ok"} == Plight.MockRoutes.lookup(routes, test_route)
  end

  test "Removes a Route", %{routes: routes} do
    test_route = "get:/index.html"
    Plight.MockRoutes.add(routes, test_route, {200, "ok"})

    assert Plight.MockRoutes.has_route?(routes, test_route) == true
    Plight.MockRoutes.remove(routes, test_route)
    assert Plight.MockRoutes.has_route?(routes, test_route) == false
  end

  test "Removes a route after specified time", %{routes: routes} do
    test_route = "get:/index.html"
    Plight.MockRoutes.add(routes, test_route, {200, "ok"}, remove_in_micros: 10)
    assert Plight.MockRoutes.has_route?(routes, test_route) == true

    :timer.sleep(20)
    assert Plight.MockRoutes.has_route?(routes, test_route) == false
  end

end
