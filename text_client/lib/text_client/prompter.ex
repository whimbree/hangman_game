defmodule TextClient.Prompter do
  alias TextClient.State

  def accept_move(game = %State{}) do
    input =
      IO.gets("Your guess: ")
      |> check_input(game)
  end

  defp check_input({:error, reason}, _) do
    IO.puts("Game ended: #{reason}")
    exit(:normal)
  end

  defp check_input(:eof, _) do
    IO.puts("Looks like you gave up...")
    exit(:normal)
  end

  defp check_input(input, game = %State{tally: tally}) do
    input = String.trim(input)

    cond do
      MapSet.member?(tally.used, input) ->
        IO.puts("Please enter a letter that wasn't already used.")
        accept_move(game)

      input =~ ~r/\A[a-z]\z/ ->
        Map.put(game, :guess, input)

      true ->
        IO.puts("Please enter a single lowercase letter.")
        accept_move(game)
    end
  end
end
