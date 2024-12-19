defmodule AdventOfCode.Day10 do
  defstruct input: "",
            input_copy: ""

  def part1(input) do
    %__MODULE__{}
    |> parse(input)
    |> info()
    |> find_trail_heads()
    |> find_trails()
    |> sum()
    |> dbg
  end

  def parse(%__MODULE__{} = state, input) when is_binary(input) do
    state
  end

  def info(%__MODULE__{} = state) do
    state
  end

  def find_trail_heads(%__MODULE__{} = state) do
    state
  end

  def find_trails(%__MODULE__{} = state) do
    state
  end

  def sum(%__MODULE__{} = state) do
    state
  end

  def part2(_input) do
  end
end
