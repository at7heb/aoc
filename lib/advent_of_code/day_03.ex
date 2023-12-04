defmodule AdventOfCode.Day03 do
  defstruct schematic: %{},
            numbers: MapSet,
            symbols: MapSet,
            gearsyms: MapSet,
            last: 0,
            parts: [],
            ratio_sum: 0

  # schematic is a map of linenumber -> corresponding line of schematic
  # numbers is a set of {linenumber, loc, length} extents of numbers
  # symbols is a set of {linenumber, loc} symbol locations (just 1 character)

  def part1(input) do
    %__MODULE__{}
    |> setup(input)
    |> make_part_list()
    |> make_answer()
  end

  def make_answer(%__MODULE__{} = state) do
    Enum.sum(state.parts)
  end

  def make_part_list(%__MODULE__{} = state) do
    parts_list =
      Enum.map(state.numbers, &number_if_symbol_adjacent(&1, state))
      |> List.flatten()
      |> Enum.filter(&(&1 > 0))

    %{state | parts: parts_list} |> dbg
  end

  def number_if_symbol_adjacent({index, start, len}, %__MODULE__{} = state) do
    list_to_check = positions_around_number(index, start, len)
    is_part_number = Enum.any?(list_to_check, &MapSet.member?(state.symbols, &1))

    if is_part_number,
      do:
        String.slice(
          Map.get(state.schematic, index),
          start,
          len
        )
        |> String.to_integer(),
      else: 0
  end

  def positions_around_number(index, start, len) do
    left = {index, start - 1}
    right = {index, start + len}
    above = Enum.map((start - 1)..(start + len), &{index - 1, &1})
    below = Enum.map((start - 1)..(start + len), &{index + 1, &1})
    [left, right, above, below] |> List.flatten()
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
    %__MODULE__{}
    |> setup(input)
    |> make_gear_list()
    |> make_answer2()
    |> Map.get(:ratio_sum)
  end

  def make_answer2(%__MODULE__{} = state) do
    state |> dbg

    gsym_adjacent_list =
      Enum.reduce(state.numbers, %{}, fn numloc, map -> adjacent_to_gsym(numloc, map, state) end)
      |> dbg

    adjacent_to_two =
      Enum.filter(Map.keys(gsym_adjacent_list), fn gsymloc ->
        Map.get(gsym_adjacent_list, gsymloc) |> length == 2
      end)
      |> dbg

    ratios =
      Enum.map(adjacent_to_two, &(Map.get(gsym_adjacent_list, &1) |> one_ratio(state)))
      |> dbg
      |> List.flatten()
      |> dbg
      |> Enum.filter(&(&1 > 0))

    ratio_sum = Enum.sum(ratios)
    %{state | ratio_sum: ratio_sum} |> dbg
  end

  def one_ratio(string_extents, %__MODULE__{} = state)
      when is_list(string_extents) and length(string_extents) == 2 do
    Enum.map(string_extents, fn {indx, loc, len} = _xtnt ->
      Map.get(state.schematic, indx) |> String.slice(loc, len) |> String.to_integer()
    end)
    |> Enum.product()
  end

  def make_gear_list(%__MODULE__{} = state) do
    gsymbols =
      Enum.map(
        0..state.last,
        fn index ->
          find_gear_symbols(Map.get(state.schematic, index), index)
        end
      )
      |> List.flatten()
      |> MapSet.new()

    %{state | gearsyms: gsymbols}
  end

  def adjacent_to_gsym({index, start, len} = numloc, map, %__MODULE__{} = state) do
    # see if any gear symbol surrounds this number; several might
    list_to_check = positions_around_number(index, start, len) |> MapSet.new() |> dbg
    all_gear_locations = MapSet.intersection(list_to_check, state.gearsyms) |> dbg

    Enum.reduce(
      all_gear_locations,
      map,
      fn one_location, map ->
        Map.put(map, one_location, [numloc | Map.get(map, one_location, [])])
      end
    )
    |> dbg
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

  def find_gear_symbols(text_line, index) do
    Regex.scan(~r/[*]/, text_line, return: :index)
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
