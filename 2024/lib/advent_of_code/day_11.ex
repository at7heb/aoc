defmodule AdventOfCode.Day11 do
  defstruct stones: [],
            current_stone: 0,
            stone_count: 0

  def part1(input) do
    %__MODULE__{}
    |> parse(input)
    |> blink1(25)
    |> answer1()
  end

  def part1b(input, times \\ 25) do
    %__MODULE__{}
    |> parse(input)
    |> blink2(times)
    |> answer2()
  end

  def parse(%__MODULE__{} = state, input) do
    stones = input |> String.split(" ", trim: true)
    %{state | stones: stones, stone_count: length(stones)}
  end

  def transform_all_stones(%__MODULE__{} = state) do
    new_stones =
      Enum.reduce(state.stones, [], fn stone, stone_list ->
        [transform_one_stone(stone) | stone_list]
      end)
      |> List.flatten()
      |> Enum.reverse()

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

  def blink1(%__MODULE__{} = state, number_of_times) do
    Enum.reduce(1..number_of_times, state, fn index, state ->
      IO.puts("iteration #{index} length = #{length(state.stones)}")
      transform_all_stones(state)
    end)
  end

  def blink2(%__MODULE__{} = state, number_of_times) do
    cond do
      length(state.stones) == 0 ->
        state

      true ->
        [stone | rest_of_stones] = state.stones
        new_state = %{state | stones: rest_of_stones}
        {stone, length(rest_of_stones)} |> dbg

        blink_one_stone(new_state, stone, number_of_times)
        # |> dbg
        |> blink2(number_of_times)
    end
  end

  def blink_one_stone(%__MODULE__{} = state, _stone, 0), do: state

  def blink_one_stone(%__MODULE__{} = state, stone, number_of_times) when is_binary(stone) do
    {stone, number_of_times, state.stones, state.stone_count} |> dbg
    new = transform_one_stone(stone)

    {state, new_stone} =
      cond do
        length(new) == 2 -> {push(state, new |> tl() |> hd()), hd(new)}
        true -> {state, hd(new)}
      end

    blink_one_stone(state, new_stone, number_of_times - 1)
  end

  def push(%__MODULE__{} = state, stone) when is_binary(stone) do
    new_stones = [stone | state.stones]
    {stone, new_stones} |> dbg
    if state.stone_count > 50, do: raise(ArgumentError, message: "")
    %{state | stones: new_stones, stone_count: state.stone_count + 1}
  end

  def answer1(%__MODULE__{} = state) do
    length(state.stones)
  end

  def answer2(%__MODULE__{} = state), do: state.stone_count

  def part2(input) do
    %__MODULE__{}
    |> parse(input)
    |> dbg
    |> blink2(75)
    |> answer2()
  end

  def test1(), do: part1("125 17")
  def test2(), do: part2("125 17")
  def full1(), do: part1("41078 18 7 0 4785508 535256 8154 447")
  def full2(), do: part2("41078 18 7 0 4785508 535256 8154 447")
end
