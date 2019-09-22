defmodule Wieldwest.Controller do
  use Wieldwest, :manager
  alias Wieldwest.Gate

  def call() do
    for x <- -10..10 do
      for y <- -10..10 do
        cmd = %{pos: %{x: x, y: y, z: 0}, type: Enum.random(0..1)} |> Jason.encode!()
        # cmd = %{pos: %{x: x, y: y, z: 0}, type: 0} |> Jason.encode!()
        Gate.send("&#{cmd}")
      end
    end

    :ok
  end

  def call("pos" <> data) do
    [x, y] = data |> String.split("|") |> Enum.map(&Decimal.new(&1))
    ax = x |> Decimal.round(0, :down) |> Decimal.to_integer()
    ay = y |> Decimal.mult(2) |> Decimal.round(0, :down) |> Decimal.to_integer()

    for x <- -10..10 do
      for y <- -10..10 do
        cmd = %{pos: %{x: ax + x, y: ay + y, z: 0}, type: Enum.random(0..1)} |> Jason.encode!()
        # cmd = %{pos: %{x: x, y: y, z: 0}, type: 0} |> Jason.encode!()
        Gate.send("&#{cmd}")
      end
    end
  end

  def call(_), do: :ok
end
