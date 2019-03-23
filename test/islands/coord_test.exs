defmodule Islands.CoordTest do
  use ExUnit.Case, async: true

  alias Islands.Coord

  doctest Coord

  describe "Coord.new/2" do
    test "returns {:ok, ...} given valid args" do
      assert Coord.new(1, 10) == {:ok, %Coord{row: 1, col: 10}}
    end

    test "returns {:error, ...} given invalid args" do
      assert Coord.new(0, 10) == {:error, :invalid_coordinate}
      assert Coord.new(-1, 2) == {:error, :invalid_coordinate}
      assert Coord.new("1", "2") == {:error, :invalid_coordinate}
    end

    test "can be encoded by Poison" do
      {:ok, coord} = Coord.new(1, 10)
      assert Poison.encode!(coord) == ~s<{\"row\":1,\"col\":10}>
    end

    test "can be encoded by Jason" do
      {:ok, coord} = Coord.new(1, 10)
      assert Jason.encode!(coord) == ~s<{\"col\":10,\"row\":1}>
    end
  end
end
