defmodule AdventOfCode.Day09 do
  defstruct input: "",
  file_map: %{},
  free_map: %{},
  current_sector: 0,
  current_file: 0,
  current_free: 0,
  file_count: 0,
  free_count: 0


  def part1(input) do
    %__MODULE__{}
    |> parse(input)
    0

  end

  def parse(%__MODULE__{} = state, ""), do: state
  def parse(%__MODULE__{} = state, input) do
    parse_file(state, input)
    parse_free(state, input)
    parse(state, input)
  end

  def parse_file(%__MODULE__{} = state, ""), do: state
  def parse_file(%__MODULE__{} = state, input) do
    {length, sectors, rest} = parse_head_of_input(state, input)
    new_state = state
    new_state
  end

  def parse_free(%__MODULE__{} = state, ""), do: state
  def parse_free(%__MODULE__{} = state, input) do
    {length, sectors, rest} = parse_head_of_input(state, input)
    length = String.to_integer(first)
    new_state = state
    new_state
  end

  def parse_head_of_input(%__MODULE__{} = state, input) do
    length = String.first(input) |> String.to_integer
    rest = String.slice(1, 999_999)}
    sectors = current_sector..current_sector+length-1 |> Enum.to_list()
    {length, sectors, rest}
  end

  def part2(input) do
    # TODO -- fix
    String.length(input)
  end
end
