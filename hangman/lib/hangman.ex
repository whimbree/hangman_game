defmodule Hangman do
  def new_game() do
    {:ok, game_pid} = Supervisor.start_child(Hangman.Supervisor, [])
    game_pid
  end

  def new_game(word) do
    {:ok, game_pid} = Supervisor.start_child(Hangman.Supervisor, [word])
    game_pid
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end

  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end
end
