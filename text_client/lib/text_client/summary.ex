defmodule TextClient.Summary do
  alias TextClient.State

  def display(game = %State{tally: tally}) do
    IO.puts([
      "\n",
      "Word so far: #{Enum.join(tally.letters, " ")}\n",
      "Guesses left: #{tally.turns_left}\n",
      "Guesses made: #{Enum.join(tally.used, " ")}\n"
    ])

    game
  end
end
