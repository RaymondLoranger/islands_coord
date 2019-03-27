defmodule Islands.CoordTest do
  use ExUnit.Case, async: true

  alias Islands.Coord

  doctest Coord

  setup_all do
    {:ok, coord} = Coord.new(1, 10)
    poison = ~s<{\"row\":1,\"col\":10}>
    jason = ~s<{\"col\":10,\"row\":1}>
    decoded = %{"col" => 10, "row" => 1}
    {:ok, json: %{poison: poison, jason: jason, decoded: decoded}, coord: coord}
  end

  describe "A coord struct" do
    test "can be encoded/decoded by Poison", %{coord: coord, json: json} do
      assert Poison.encode!(coord) == json.poison
      assert Poison.decode!(json.poison) == json.decoded
    end

    test "can be encoded/decoded by Jason", %{coord: coord, json: json} do
      assert Jason.encode!(coord) == json.jason
      assert Jason.decode!(json.jason) == json.decoded
    end
  end

  describe "Coord.new/2" do
    test "returns {:ok, ...} given valid args" do
      assert Coord.new(1, 10) == {:ok, %Coord{row: 1, col: 10}}
    end

    test "returns {:error, ...} given invalid args" do
      assert Coord.new(0, 10) == {:error, :invalid_coordinate}
      assert Coord.new(-1, 2) == {:error, :invalid_coordinate}
      assert Coord.new("1", "2") == {:error, :invalid_coordinate}
    end
  end
end
