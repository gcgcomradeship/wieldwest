defmodule Wieldwest.Map do
  @max_x 100
  @max_y 100
  @tile_size 100
  def init() do
    :ets.new(:map, [:set, :protected, :named_table])
    generate(@max_x, @max_y)
  end

  def set(data) do
    :ets.insert(:map, data)
  end

  def get(key) do
    extract(:ets.lookup(:map, key))
  end

  def all() do
  end

  defp extract([{_key, data}]), do: data

  defp generate(max_x, max_y) do
    for x <- 0..max_x do
      for y <- 0..max_y do
        set({id(x, y), %{x: x * @tile_size, y: y * @tile_size, t: :rand.uniform(10)}})
      end
    end
  end

  defp id(x, y) do
    "#{x + @max_y * y}"
  end
end
