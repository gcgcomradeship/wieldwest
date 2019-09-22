defmodule Wieldwest.Reciever do
  use GenServer
  use Wieldwest, :manager

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Storage.init()
    Map.init()
    Session.init()
    Listener.start()
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    try do
      schedule_work()
      {:noreply, state}
    rescue
      exception -> Logger.error("* ERROR -> \n** #{exception}")
    end
  end

  defp schedule_work() do
    # if Mix.env() == :dev do
    #   Gate.accept()
    # end

    Process.send(self(), :work, [])
  end
end
