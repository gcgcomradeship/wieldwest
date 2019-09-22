defmodule Wieldwest.Connection do
  use GenServer
  use Wieldwest, :manager

  alias Wieldwest.Storage.Session

  def handle(port) do
    {:ok, pid} = GenServer.start_link(__MODULE__, %{port: port})
    # GenServer.cast(pid, :acceptance)
    GenServer.cast(pid, :recv)
  end

  def init(%{port: port} = state) do
    Logger.info("New connection detected.")
    session_id = Session.create(port)
    Socket.Stream.send(port, session_id)
    Logger.info("New session: #{session_id}")
    {:ok, %{port: port, session: session_id}}
  end

  # def handle_cast(:acceptance, %{port: port}) do
  #   case Socket.Stream.recv(port) do
  #     {:ok, "new"} ->
  #       session_id = Session.create(port)
  #       Socket.Stream.send(port, session_id)
  #       Logger.info("New session: #{session_id}")
  #       {:noreply, %{port: port, session: session_id}}

  #     {:ok, data} ->
  #       data
  #       |> IO.inspect()
  #       |> Logger.error()

  #       {:stop, :normal, %{error: "Unknown data! Port closed."}}

  #     error ->
  #       {:stop, :error, %{error: error}}
  #   end
  # end

  def handle_cast(:recv, %{port: port, session: session_id} = state) do
    case Socket.Stream.recv(port) do
      {:ok, "gen_map"} ->
        Wieldwest.Controller.call()
        GenServer.cast(self, :recv)
        {:noreply, state}

      {:ok, data} ->
        Wieldwest.Controller.call(data)
        GenServer.cast(self, :recv)
        {:noreply, state}

      {:error, :enotconn} ->
        Session.close(session_id)
        Logger.info("Session closed: #{session_id}")
        {:noreply, state}

      error ->
        {:stop, :error, %{error: error}}
    end
  end

  # def terminate(_reason, %{error: {:error, :enotconn}}) do
  #   Logger.error("Session closed")
  #   :normal
  # end

  def terminate(_reason, %{error: message}) do
    Logger.error(message)
    :normal
  end

  def terminate(_reason, _state), do: :normal

  # def call do
  #   {:ok, pid} = start_link()
  # end

  # def call(pid) do
  #   GenServer.call(pid, :listen)
  # end

  # # def call(pid) do
  # #   GenServer.cast(pid, :listen)
  # # end

  # def start_link do
  #   GenServer.start_link(__MODULE__, %{})
  # end

  # def init(state) do
  #   Logger.info("START...")
  #   {:ok, state}
  # end

  # def handle_call(:listen, _from, state) do
  #   case listen() do
  #     {:ok, port} ->
  #       Logger.info("SUCCESS")
  #       Logger.warn("Current state: #{inspect(state)}")
  #       new_state = %{port: port}
  #       {:reply, new_state, new_state}

  #     {:error, reason} ->
  #       Logger.warn("Socket terminating: #{inspect(reason)}")
  #       {:reply, state, state}
  #   end
  # end

  # # def handle_cast(:listen, state) do
  # #   state =
  # #     case listen() do
  # #       {:ok, port} ->
  # #         Logger.info("SUCCESS")
  # #         Logger.warn("Current state: #{inspect(state)}")
  # #         %{port: port}

  # #       {:error, reason} ->
  # #         Logger.warn("Socket terminating: #{inspect(reason)}")
  # #         state
  # #     end

  # #   Logger.warn("Current state: #{inspect(state)}")
  # #   {:noreply, state}
  # # end

  # def terminate(reason, state) do
  #   Logger.info("closed")
  #   {:stop, :normal}
  # end

  # def listen do
  #   port_number = 5555
  #   # Socket.TCP.listen(port_number, packet: :line)
  #   Socket.TCP.listen(port_number)
  # end

  # def listen(port) do
  #   listen(port, &handler/1)
  # end

  # def listen(port, handler) do
  #   Logger.info("listen")
  #   require IEx
  #   IEx.pry()

  #   socket =
  #     Socket.TCP.listen!(port, packet: :line)
  #     |> accept(handler)
  # end

  # def accept(listening_socket, handler) do
  #   Logger.info("accept")
  #   socket = Socket.TCP.accept!(listening_socket)
  #   spawn(fn -> handle(socket, handler) end)
  #   accept(listening_socket, handler)
  # end

  # def handle(socket, handler) do
  #   Logger.info("handle")
  #   incoming = Socket.Stream.recv!(socket)
  #   socket |> Socket.Stream.send!(handler.(incoming))
  #   handle(socket, handler)
  # end

  # def handler(line) do
  #   String.upcase(line)
  # end
end
