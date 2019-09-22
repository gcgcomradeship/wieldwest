defmodule Wieldwest.Gate do
  use Wieldwest, :manager
  alias Wieldwest.Storage.Session

  def accept() do
    Storage.get(:listener)
    |> Socket.TCP.accept()
    |> case do
      {:ok, port} ->
        Connection.handle(port)

      error ->
        Logger.error("Something was wrong when accept.")
        error
    end
  end

  def send(data) do
    case Session.all() do
      [] ->
        Logger.error("Session does not exist.")

      [{_session_id, %{out: port}} | _] ->
        Socket.Stream.send(port, data)

      _ ->
        Logger.error("GATE SENDING: Unkown scenario")
    end
  end
end
