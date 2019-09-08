defmodule Wieldwest.Listener do
  use Wieldwest, :manager

  @port 5555

  def start() do
    case Socket.TCP.listen(@port) do
      {:ok, listener} ->
        Logger.info("Listener started...")
        Storage.set(%{listener: listener})
        :ok

      {:error, :eaddrinuse} ->
        Logger.error("Listener already started.")
        :error
    end
  end
end
