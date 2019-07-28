defmodule GallowsWeb.HangmanController do
  use GallowsWeb, :controller

  def new_game(conn, _params) do
    render(conn, "new_game.html")
  end

  def create_game(conn, _params) do
    game_pid = Hangman.new_game()
    tally = Hangman.tally(game_pid)

    conn
    |> put_session(:game, game_pid)
    |> render("game_field.html", tally: tally)
  end

  def make_move(conn, params) do
    guess = params["make_move"]["guess"]

    tally =
      conn
      |> get_session(:game)
      |> Hangman.make_move(guess)

    put_in(conn.params["make_move"]["guess"], "")
    |> render("game_field.html", tally: tally)
  end
end
