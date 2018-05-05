defmodule Wieldwest.Reciever do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    try do
      # Wieldwest.Connector.listen()
      schedule_work()
      {:noreply, state}
    rescue
      exception -> Logger.error("* ERROR -> \n** #{exception}")
    end
  end

  defp schedule_work() do
    # seconds
    # interval = 1
    # Process.send_after(self(), :work, 5 * 1000 * interval)
    Process.send(self(), :work, [])
  end
end
