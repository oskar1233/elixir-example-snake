defmodule Sample.MainLoop do
  use GenServer

  @name __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    Process.send(self(), :loop, [])

    {:ok,
     %{
       x: 5,
       y: 5
     }}
  end

  def handle_info(:loop, state) do
    Process.send_after(self(), :loop, 1_000, [])

    {:noreply,
     state
     |> move()
     |> check_alive()
     |> print()}
  end

  defp move(state) do
    Sample.Controls.current_direction()
    |> case do
      :left -> Map.update!(state, :x, &(&1 - 1))
      :right -> Map.update!(state, :x, &(&1 + 1))
      :up -> Map.update!(state, :y, &(&1 - 1))
      :down -> Map.update!(state, :y, &(&1 + 1))
    end
  end

  defp print(state) do
    IO.puts(inspect(state))

    state
  end

  defp check_alive(%{x: x, y: y}) when x < 0 or y < 0 do
    raise "Dead"
  end

  defp check_alive(state), do: state
end
