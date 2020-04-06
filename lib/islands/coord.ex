# ┌────────────────────────────────────────────────────────────────────┐
# │ Based on the book "Functional Web Development" by Lance Halvorsen. │
# └────────────────────────────────────────────────────────────────────┘
defmodule Islands.Coord do
  use PersistConfig

  @book_ref Application.get_env(@app, :book_ref)

  @moduledoc """
  Creates a `coord` struct for the _Game of Islands_.
  \n##### #{@book_ref}
  """

  alias __MODULE__

  @coord_range 1..10

  @derive [Poison.Encoder]
  @derive Jason.Encoder
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @type col :: 1..10
  @type row :: 1..10
  @type square :: 1..100
  @type t :: %Coord{row: row, col: col}

  @spec new(row, col) :: {:ok, t} | {:error, atom}
  def new(row, col) when row in @coord_range and col in @coord_range do
    {:ok, %Coord{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinates}

  @spec new(square) :: {:ok, t} | {:error, atom}
  def new(square) when square in 1..100, do: rem(square, 10) |> coord(square)
  def new(_square), do: {:error, :invalid_square_number}

  @spec to_square(Coord.t()) :: square | {:error, atom}
  def to_square(%Coord{row: row, col: col} = _coord), do: (row - 1) * 10 + col
  def to_square(_coord), do: {:error, :invalid_coordinates}

  @spec to_row_col(Coord.t()) :: String.t() | {:error, atom}
  def to_row_col(%Coord{row: row, col: col} = _coord), do: "#{row} #{col}"
  def to_row_col(_coord), do: {:error, :invalid_coordinates}

  # Private functions

  @spec coord(rem :: 0..9, square) :: {:ok, t}
  defp coord(0, square), do: Coord.new(div(square, 10), 10)
  defp coord(rem, square), do: Coord.new(div(square, 10) + 1, rem)
end
