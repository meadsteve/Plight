defmodule Plight.CallTracker.Server do
  use GenServer

  ## Gen server hooks
  def init(:ok) do
    {:ok, %{called_paths: HashDict.new}}
  end

  def handle_call({:was_path_called?, path}, _from, %{called_paths: paths} = state) do
    {:reply, Dict.has_key?(paths, path), state}
  end

  def handle_cast({:path_called, path}, %{called_paths: paths} = state) do
    new_called_paths = paths |> add_call_to_path(path)
    new_state = %{state|called_paths: new_called_paths}
    {:noreply, new_state}
  end

  # Domain logic

  def add_call_to_path(paths, path) do
    Dict.update(paths, path, 1, &(&1 + 1))
  end

end
