# ┌────────────────────────────────────────────────────────────────────┐
# │ Based on the book "Functional Web Development" by Lance Halvorsen. │
# └────────────────────────────────────────────────────────────────────┘
defmodule Islands.Coord do
  @moduledoc """
  A _coord_ struct and functions for the _Game of Islands_.

  The _coord_ struct contains the fields _row_ and _col_ representing the
  coordinates of a square in the _Game of Islands_.

  ##### Based on the book [Functional Web Development](https://pragprog.com/book/lhelph/functional-web-development-with-elixir-otp-and-phoenix) by Lance Halvorsen.
  """

  alias __MODULE__

  @col_range 1..10
  @row_range 1..10
  @square_range 1..100

  @derive [Poison.Encoder]
  @derive Jason.Encoder
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @typedoc "Column number"
  @type col :: 1..10
  @typedoc "Row number"
  @type row :: 1..10
  @typedoc "Square number: (row - 1) * 10 + col"
  @type square :: 1..100
  @typedoc "A coordinates struct for the Game of Islands"
  @type t :: %Coord{row: row, col: col}

  @doc """
  Returns `{:ok, coord}` or `{:error, reason}` if given an invalid `row` or
  `col`.

  ## Examples

      iex> alias Islands.Coord
      iex> Coord.new(10, 10)
      {:ok, %Coord{col: 10, row: 10}}
  """
  @spec new(row, col) :: {:ok, t} | {:error, atom}
  def new(row, col) when row in @row_range and col in @col_range do
    {:ok, %Coord{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinates}

  @doc """
  Returns a _coord_ struct or raises if given an invalid `row` or `col`.

  ## Examples

      iex> alias Islands.Coord
      iex> Coord.new!(10, 10)
      %Coord{row: 10, col: 10}

      iex> alias Islands.Coord
      iex> Coord.new!(0, 1)
      ** (ArgumentError) cannot create coord, reason: :invalid_coordinates
  """
  @spec new!(row, col) :: t
  def new!(row, col) do
    case new(row, col) do
      {:ok, coord} ->
        coord

      {:error, reason} ->
        raise ArgumentError, "cannot create coord, reason: #{inspect(reason)}"
    end
  end

  @doc """
  Returns `{:ok, coord}` or `{:error, reason}` if given an invalid `square`.

  ## Examples

      iex> alias Islands.Coord
      iex> Coord.new(99)
      {:ok, %Coord{row: 10, col: 9}}
  """
  @spec new(square) :: {:ok, t} | {:error, atom}
  def new(square) when square in @square_range,
    do: rem(square, 10) |> coord(square)

  def new(_square), do: {:error, :invalid_square_number}

  @doc """
  Returns a _coord_ struct or raises if given an invalid `square`.

  ## Examples

      iex> alias Islands.Coord
      iex> Coord.new!(99)
      %Coord{row: 10, col: 9}

      iex> alias Islands.Coord
      iex> Coord.new!(101)
      ** (ArgumentError) cannot create coord, reason: :invalid_square_number
  """
  @spec new!(square) :: t
  def new!(square) do
    case new(square) do
      {:ok, coord} ->
        coord

      {:error, reason} ->
        raise ArgumentError, "cannot create coord, reason: #{inspect(reason)}"
    end
  end

  @doc """
  Returns a _square_ number or `{:error, reason}` if given an invalid `coord`.

  ## Examples

      iex> alias Islands.Coord
      iex> {:ok, coord} = Coord.new(2, 9)
      iex> Coord.to_square(coord)
      19
  """
  @spec to_square(Coord.t()) :: square | {:error, atom}
  def to_square(%Coord{row: row, col: col} = _coord), do: (row - 1) * 10 + col
  def to_square(_coord), do: {:error, :invalid_coord_struct}

  @doc """
  Returns "<row> <col>" or `{:error, reason}` if given an invalid `coord`.

  ## Examples

      iex> alias Islands.Coord
      iex> {:ok, coord} = Coord.new(2, 9)
      iex> Coord.to_row_col(coord)
      "2 9"
  """
  @spec to_row_col(Coord.t()) :: String.t() | {:error, atom}
  def to_row_col(%Coord{row: row, col: col} = _coord), do: "#{row} #{col}"
  def to_row_col(_coord), do: {:error, :invalid_coord_struct}

  @doc """
  Compares two _coord_ structs based on their _square_ numbers.

  ## Examples
      iex> alias Islands.Coord
      iex> Coord.compare(Coord.new!(4, 7), Coord.new!(5, 7))
      :lt
  """
  @spec compare(t, t) :: :lt | :eq | :gt
  def compare(%Coord{} = coord1, %Coord{} = coord2) do
    case {to_square(coord1), to_square(coord2)} do
      {square1, square2} when square1 > square2 -> :gt
      {square1, square2} when square1 < square2 -> :lt
      _ -> :eq
    end
  end

  ## Private functions

  @spec coord(rem :: 0..9, square) :: {:ok, t}
  defp coord(0, square), do: Coord.new(div(square, 10), 10)
  defp coord(rem, square), do: Coord.new(div(square, 10) + 1, rem)

  ## Helpers

  defimpl String.Chars, for: Coord do
    @spec to_string(Coord.t()) :: String.t()
    def to_string(%Coord{row: row, col: col} = _coord), do: "(#{row}, #{col})"
  end
end
