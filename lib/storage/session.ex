defmodule Wieldwest.Storage.Session do
  def init() do
    :ets.new(:session, [:set, :public, :named_table])
  end

  def create(port) do
    id = gen_id()
    :ets.insert(:session, {id, %{out: port}})
    id
  end

  defp gen_id() do
    :crypto.strong_rand_bytes(30)
    |> Base.url_encode64()
    |> binary_part(0, 30)
  end
end
