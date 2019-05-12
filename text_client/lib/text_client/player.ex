defmodule TextClient.Player do
  alias TextClient.{State, Summary, Prompter, Mover}

  def init(game = %State{}) do
    IO.puts("Welcome to Hangman!")
    continue(game)
  end

  def play(%State{tally: %{game_state: :won}}) do
    exit_with_message("\nYou WON!")
  end

  def play(%State{game_service: %{letters: word}, tally: %{game_state: :lost}}) do
    exit_with_message("\nSorry, the word was \"#{Enum.join(word, "")}\".")
  end

  def play(game = %State{tally: %{game_state: :good_guess}}) do
    game |> continue_with_message("\nGood Guess!")
  end

  def play(game = %State{tally: %{game_state: :bad_guess}}) do
    game |> continue_with_message("\nSorry, that guess isn't in the word.")
  end

  def play(game = %State{}) do
    game |> continue()
  end

  defp continue(game = %State{}) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  defp continue_with_message(game = %State{}, msg) do
    IO.puts(msg)
    continue(game)
  end

  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
