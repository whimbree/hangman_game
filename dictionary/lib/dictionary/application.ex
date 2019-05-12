defmodule Dictionary.Application do
  # Built in application behavior
  use Application

  def start(_type, _args) do
    children = [
      %{id: Dictionary.Wordlist, start: {Dictionary.WordList, :start_link, []}}
    ]

    options = [
      name: Dictionary.Application,
      strategy: :one_for_one
    ]

    # Supervises and creates dictionary state
    Supervisor.start_link(children, options)
  end
end
