defmodule Hangman.Server do
  alias Hangman.{Game, Tally}

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def start_link(word) do
    GenServer.start_link(__MODULE__, word)
  end

  def init(nil) do
    {:ok, Game.new_game()}
  end

  def init(word) do
    {:ok, Game.new_game(word)}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {game, tally} = Game.make_move_w_tally(game, guess)
    {:reply, tally, game}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Tally.tally(game), game}
  end
end
