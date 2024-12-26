defmodule AdventOfCode.Day11 do
  defstruct stones: [],
            current_stone: 0

  def part1(input) do
    %__MODULE__{}
    |> parse(input)
    |> dbg
    |> blink(25)
    |> answer()
  end

  def parse(%__MODULE__{} = state, input) do
    stones = input |> String.split(" ", trim: true)
    %{state | stones: stones}
  end

  def transform_all_stones(%__MODULE__{} = state) do
    new_stones =
      Enum.reduce(state.stones, [], fn stone, new_stones ->
        new_stones ++ [transform_one_stone(stone)]
      end)

    %{state | stones: new_stones}
  end

  def transform_one_stone(stone) do
    stone_length = String.length(stone)

    cond do
      stone == "0" -> ["1"]
      rem(stone_length, 2) == 0 -> split_the_stone(stone)
      true -> [(2024 * String.to_integer(stone)) |> Integer.to_string()]
    end
  end

  def split_the_stone(stone) do
    half_len = div(String.length(stone), 2)
    new_stone_1 = String.slice(stone, 0..(half_len - 1))

    new_stone_2 =
      String.slice(stone, half_len..(2 * half_len)) |> String.to_integer() |> Integer.to_string()

    [new_stone_1, new_stone_2]
  end

  def blink(%__MODULE__{} = state, number_of_times) do
    Enum.reduce(1..number_of_times, state.stones, fn _index, stones ->
      transform_all_stones(stones)
    end)
  end

  def answer(%__MODULE__{} = state) do
    length(state.stones)
  end

  def part2(input) do
    %__MODULE__{}
    |> parse(input)
  end

  def test1(), do: part1("125 17")
  def test2(), do: part2("125 17")
  def full1(), do: part1("41078 18 7 0 4785508 535256 8154 447")
  def full2(), do: part2("41078 18 7 0 4785508 535256 8154 447")
end
