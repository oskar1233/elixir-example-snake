defmodule Sample.Controls do
  use Agent

  @initial %{
    current_direction: :left
  }

  @name __MODULE__

  def start_link(_) do
    Agent.start_link(fn -> @initial end, name: @name)
  end

  def current_direction do
    Agent.get(@name, fn state -> state.current_direction end)
  end

  def change_direction(dir) do
    Agent.update(@name, fn state -> Map.put(state, :current_direction, dir) end)
  end
end
