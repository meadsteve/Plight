defmodule Plight.CallTrackerTest do
    use ExUnit.Case, async: true

  setup do
    {:ok, tracker} = Plight.CallTracker.start_link
    {:ok, tracker: tracker}
  end

  test "Tracks if a path was called", %{tracker: tracker} do
    path_called = "testone"
    method_was_called = tracker
    |> Plight.CallTracker.path_called(path_called)
    |> Plight.CallTracker.was_path_called?(path_called)

    assert method_was_called == true
  end

  test "Tracks if a path was not called", %{tracker: tracker} do
    path_called = "testone"
    path_questioned = "test_two"
    method_was_called = tracker
    |> Plight.CallTracker.path_called(path_called)
    |> Plight.CallTracker.was_path_called?(path_questioned)

    assert method_was_called == false
  end

end
