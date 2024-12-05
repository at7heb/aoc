defmodule AdventOfCode.Day04 do
  defstruct puzzle: %{}, xlocations: [], count: 0, alocations: []

  @increments [{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}]
  @corners [{1, 1}, {1, -1}, {-1, -1}, {-1, 1}]
  def part1(input) do
    %__MODULE__{}
    |> setup(input)
    |> find_words()
    |> Map.get(:count)
  end

  def setup(%__MODULE__{} = state, input) do
    lines = String.upcase(input) |> String.split("\n")
    n_cols = String.length(hd(lines))
    n_rows = length(lines)
    coords = for row <- 1..n_rows, col <- 1..n_cols, do: {row, col}

    puzzle =
      Enum.reduce(coords, %{}, fn coord, acc ->
        Map.put(acc, coord, puzzle_fetch(lines, coord))
      end)

    xlocs = Enum.filter(coords, fn coord -> Map.get(puzzle, coord) == "X" end)
    alocs = Enum.filter(coords, fn coord -> Map.get(puzzle, coord) == "A" end)
    %{state | puzzle: puzzle, xlocations: xlocs, alocations: alocs, count: 0}
  end

  def puzzle_fetch(lines, {row, col} = _coord) when is_list(lines) do
    Enum.at(lines, row - 1)
    |> String.at(col - 1)
  end

  def find_words(%__MODULE__{} = state) do
    Enum.reduce(state.xlocations, state, fn location, state -> find_words(state, location) end)
  end

  def find_words(%__MODULE__{} = state, {_row, _col} = loc) do
    Enum.reduce(@increments, state, fn incr, state -> try_one_word_direction(state, loc, incr) end)
  end

  def try_one_word_direction(
        %__MODULE__{} = state,
        {row, col} = _location,
        {row_incr, col_incr} = _dir_increment
      ) do
    test_info =
      Enum.zip(for(mult <- 1..3, do: {row + row_incr * mult, col + col_incr * mult}), ~w/M A S/)

    word? =
      Enum.all?(test_info, fn {coord, letter} -> Map.get(state.puzzle, coord, "@") == letter end)

    new_count = state.count + if word?, do: 1, else: 0
    %{state | count: new_count}
  end

  def part2(input) do
    %__MODULE__{}
    |> setup(input)
    |> find_max()
    |> Map.get(:count)
  end

  def find_max(%__MODULE__{} = state) do
    Enum.reduce(state.alocations, state, fn location, state -> find_x_mas(state, location) end)
  end

  def find_x_mas(%__MODULE__{puzzle: puzzle} = state, {row, col} = location) do
    IO.puts("------------------------------------------")
    {location, Map.get(puzzle, location)} |> dbg

    corner_letters =
      Enum.map(@corners, fn {row_inc, col_inc} ->
        Map.get(puzzle, {row + row_inc, col + col_inc}, "@")
      end)
      |> Enum.sort()
      |> dbg

    count_increment =
      if corner_letters != ~w/M M S S/ do
        0
      else
        m_location_increments =
          Enum.filter(@corners, fn {row_inc, col_inc} ->
            Map.get(puzzle, {row + row_inc, col + col_inc}, "@") == "M"
          end)

        if Enum.map(m_location_increments, fn {row_inc, col_inc} -> row_inc + col_inc end)
           |> Enum.sum() == 0,
           do: 0,
           else: 1 |> dbg
      end

    new_count = state.count + count_increment
    %{state | count: new_count}
  end
end
