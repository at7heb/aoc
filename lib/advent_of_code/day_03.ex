defmodule AdventOfCode.Day03 do
  # struct text: "", numbers_locations: [], symbol_locations: []
  defstruct schematic: %{}, numbers: %{}, symbols: %{}, last: 0, sum: 0
  # schematic is a map of linenumber -> corresponding line of schematic
  # numbers is a map of linenumber -> list of {loc, length} extents of number
  # symbols is a map of linenumber -> list of loc giving symbol locations

  def part1(input) do
    %__MODULE__{}
    |> setup(input)
  end

  def setup(%__MODULE__{} = state, input) do
    state
    |> add_schematic(input)
    |> add_numbers_and_symbols()
    |> dbg
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
    add_numbers(state) |> dbg |> add_symbols() |> dbg
  end

  def add_numbers(%__MODULE__{} = state) do
    numbers =
      Enum.reduce(
        0..state.last,
        %{},
        fn index, acc -> Map.put(acc, index, find_numbers(Map.get(state.schematic, index))) end
      )

    %{state | numbers: numbers}
  end

  def add_symbols(%__MODULE__{} = state) do
    symbols =
      Enum.reduce(
        0..state.last,
        %{},
        fn index, acc -> Map.put(acc, index, find_symbols(Map.get(state.schematic, index))) end
      )

    %{state | symbols: symbols}
  end

  def part2(input) do
    input
    |> length()
  end

  def find_numbers(text_line) do
    Regex.scan(~r/\d+/, text_line, return: :index)
    |> List.flatten()
  end

  def find_symbols(text_line) do
    Regex.scan(~r/[^0-9.]/, text_line, return: :index)
    |> Enum.map(fn [{loc, _len}] -> loc end)
  end

  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end
end
