defmodule Islands.CoordTest do
  use ExUnit.Case, async: true

  alias Islands.Coord

  doctest Coord

  setup_all do
    {:ok, sq_1_1} = Coord.new(1, 1)
    {:ok, sq_4_7} = Coord.new(4, 7)
    {:ok, sq_10_10} = Coord.new(10, 10)

    {:ok, coord} = Coord.new(1, 10)
    poison = ~s<{"row":1,"col":10}>
    jason = ~s<{"col":10,"row":1}>
    decoded = %{"col" => 10, "row" => 1}

    {:ok,
     coord: coord,
     json: %{poison: poison, jason: jason, decoded: decoded},
     squares: %{sq_1_1: sq_1_1, sq_4_7: sq_4_7, sq_10_10: sq_10_10}}
  end

  describe "A coord struct" do
    test "can be encoded by Poison", %{coord: coord, json: json} do
      assert Poison.encode!(coord) == json.poison
      assert Poison.decode!(json.poison) == json.decoded
    end

    test "can be encoded by Jason", %{coord: coord, json: json} do
      assert Jason.encode!(coord) == json.jason
      assert Jason.decode!(json.jason) == json.decoded
    end
  end

  describe "Coord.new/2" do
    test "returns {:ok, ...} given valid args" do
      assert Coord.new(1, 10) == {:ok, %Coord{row: 1, col: 10}}
    end

    test "returns {:error, ...} given invalid args" do
      assert Coord.new(0, 10) == {:error, :invalid_coordinates}
      assert Coord.new(-1, 2) == {:error, :invalid_coordinates}
      assert Coord.new("1", "2") == {:error, :invalid_coordinates}
    end
  end

  describe "Coord.to_square/1" do
    test "returns a 'square' number given valid args", %{squares: squares} do
      assert Coord.to_square(squares.sq_1_1) == 1
      assert Coord.to_square(squares.sq_4_7) == 37
      assert Coord.to_square(squares.sq_10_10) == 100
    end

    test "returns {:error, ...} given invalid args" do
      assert Coord.to_square({1, 1}) == {:error, :invalid_coordinates}
      assert Coord.to_square([4, 7]) == {:error, :invalid_coordinates}
      assert Coord.to_square("10, 10") == {:error, :invalid_coordinates}
    end
  end

  describe "Coord.to_row_col/1" do
    test "returns a 'row col' string given valid args", %{squares: squares} do
      assert Coord.to_row_col(squares.sq_1_1) == "1 1"
      assert Coord.to_row_col(squares.sq_4_7) == "4 7"
      assert Coord.to_row_col(squares.sq_10_10) == "10 10"
    end

    test "returns {:error, ...} given invalid args" do
      assert Coord.to_row_col({1, 1}) == {:error, :invalid_coordinates}
      assert Coord.to_row_col([4, 7]) == {:error, :invalid_coordinates}
      assert Coord.to_row_col("10, 10") == {:error, :invalid_coordinates}
    end
  end
end
