defmodule Wieldwest.Storage do
  def init() do
    :ets.new(:processing, [:set, :protected, :named_table])
  end

  def set(data) when is_map(data) do
    for record <- data do
      :ets.insert(:processing, record)
    end
  end

  def get(key) do
    extract(:ets.lookup(:processing, key))
  end

  defp extract([{_key, data}]), do: data
end
