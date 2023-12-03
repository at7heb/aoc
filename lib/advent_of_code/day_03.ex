defmodule AdventOfCode.Day03 do
  defstruct schematic: %{}, numbers: MapSet, symbols: MapSet, last: 0, parts: []
  # schematic is a map of linenumber -> corresponding line of schematic
  # numbers is a set of {linenumber, loc, length} extents of numbers
  # symbols is a set of {linenumber, loc} symbol locations (just 1 character)

  def part1(input) do
    %__MODULE__{}
    |> setup(input)
    |> make_part_list()
  end

  def make_part_list(%__MODULE__{} = state) do
    parts_list =
      Enum.map(state.numbers, &number_if_symbol_adjacent(&1, state))
      |> List.flatten()
      |> Enum.map(&String.to_integer(&1))

    %{state | parts: parts_list}
  end

  def number_if_symbol_adjacent({index, start, len}, %__MODULE__{} = state) do
    left = {index, start - 1}
    right = {index, start + len}
    above = Enum.map((start - 1)..(start + len), &{index - 1, &1})
    below = Enum.map((start - 1)..(start + len), &{index + 1, &1})
    list_to_check = [left, right, above, below] |> List.flatten()
    is_part_number = Enum.any?(list_to_check, &MapSet.member?(state.symbols, &1))

    if is_part_number,
      do:
        String.slice(
          Map.get(state.schematic, index)
          |> String.slice(start, len)
          |> String.to_integer()
        ),
      else: 0
  end

  def setup(%__MODULE__{} = state, input) do
    state
    |> add_schematic(input)
    |> add_numbers_and_symbols()
  end

  def add_schematic(%__MODULE__{} = state, input) do
    {schematic, _} =
      String.split(input, "\n")
      |> Enum.reduce(
        {%{}, 0},
        fn line, {schm, index} ->
          schm1 = Map.put(schm, index, String.trim(line))
          {schm1, index + 1}
        end
      )

    %{state | schematic: schematic, last: map_size(schematic) - 1}
  end

  def add_numbers_and_symbols(%__MODULE__{} = state) do
    add_numbers(state) |> add_symbols()
  end

  def add_numbers(%__MODULE__{} = state) do
    numbers =
      Enum.map(
        0..state.last,
        fn index -> find_numbers(Map.get(state.schematic, index), index) end
      )
      |> List.flatten()
      |> MapSet.new()

    %{state | numbers: numbers}
  end

  def add_symbols(%__MODULE__{} = state) do
    symbols =
      Enum.map(
        0..state.last,
        fn index ->
          find_symbols(Map.get(state.schematic, index), index)
        end
      )
      |> List.flatten()
      |> MapSet.new()

    %{state | symbols: symbols}
  end

  def part2(input) do
    input
    |> length()
  end

  def find_numbers(text_line, index) do
    Regex.scan(~r/\d+/, text_line, return: :index)
    |> Enum.map(fn [{loc, len}] -> {index, loc, len} end)
    |> List.flatten()
  end

  def find_symbols(text_line, index) do
    Regex.scan(~r/[^0-9.]/, text_line, return: :index)
    |> Enum.map(fn [{loc, _len}] -> {index, loc} end)
    |> List.flatten()
  end

  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end
end
