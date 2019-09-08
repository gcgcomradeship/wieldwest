defmodule Wieldwest.Gate do
  use Wieldwest, :manager

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
end
