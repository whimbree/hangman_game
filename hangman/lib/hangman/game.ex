defmodule Hangman.Game do
  alias Hangman.{Game, Tally}

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game() do
    %Game{letters: Dictionary.random_word() |> String.codepoints()}
  end

  def new_game(word) do
    %Game{letters: word |> String.codepoints()}
  end

  def make_move_w_tally(game, guess) do
    game = make_move(game, guess)
    {game, Tally.tally(game)}
  end

  # Do not change state if game won or lost
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
  end

  # Else change state by making a move.
  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  ### PRIVATE FUNCTIONS BELOW###

  defp accept_move(game, _guess, _already_guessed = true) do
    %{game | game_state: :already_used}
  end

  defp accept_move(game, guess, _not_already_guessed) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won()

    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _not_good_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(game = %{turns_left: turns_left}, _not_good_guess) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess
end
