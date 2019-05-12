defmodule Hangman.Tally do
  alias Hangman.{Game, Tally}

  defstruct(
    game_state: nil,
    turns_left: nil,
    letters: nil,
    used: nil
  )

  def tally(game = %Game{}) do
    %Tally{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used),
      used: game.used
    }
  end

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _not_in_word), do: "_"
end
