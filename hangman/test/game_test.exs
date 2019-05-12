defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "second occurence of correct letter used" do
    moves = [
      {"l", :good_guess, 7},
      {"l", :already_used, 7}
    ]

    assert_game_moves("lit", moves)
  end

  test "second occurence of incorrect letter used" do
    moves = [
      {"x", :bad_guess, 6},
      {"x", :already_used, 6}
    ]

    assert_game_moves("lit", moves)
  end

  test "good guess made" do
    moves = [
      {"l", :good_guess, 7}
    ]

    assert_game_moves("lit", moves)
  end

  test "fully guessed word is a :won game" do
    moves = [
      {"l", :good_guess, 7},
      {"i", :good_guess, 7},
      {"t", :won, 7}
    ]

    assert_game_moves("lit", moves)
  end

  test "bad guess made" do
    moves = [
      {"a", :bad_guess, 6}
    ]

    assert_game_moves("lit", moves)
  end

  test "out of turns is :lost game" do
    moves = [
      {"a", :bad_guess, 6},
      {"b", :bad_guess, 5},
      {"c", :bad_guess, 4},
      {"d", :bad_guess, 3},
      {"e", :bad_guess, 2},
      {"f", :bad_guess, 1},
      {"g", :lost, 0}
    ]

    assert_game_moves("lit", moves)
  end

  def assert_game_moves(word, moves) do
    game = Game.new_game(word)

    fun = fn {guess, state, turns}, game ->
      game = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == turns
      game
    end

    Enum.reduce(moves, game, fun)
  end
end
