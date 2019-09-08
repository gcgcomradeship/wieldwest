defmodule Wieldwest do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Wieldwest.Reciever, [])
    ]

    opts = [strategy: :one_for_one, name: Wieldwest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def manager do
    quote do
      require Logger
      alias Wieldwest.Listener
      alias Wieldwest.Connection
      alias Wieldwest.Gate
      alias Wieldwest.Map
      alias Wieldwest.Storage
      alias Wieldwest.Storage.Session
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
