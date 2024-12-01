defmodule AdventOfCode.Day01 do
  def part1(input) do
    {l1, l2} = make_list(input)
    l1 = Enum.sort(l1)
    l2 = Enum.sort(l2)

    Enum.zip(l1, l2)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def make_list(input) do
    input
    |> String.trim()
    |> String.split(["\n", " "], trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.reduce({[], []}, fn v, {l1, l2} -> {l2, l1 ++ [v]} end)
  end

  def part2(input) do
    {l1, l2} = make_list(input)

    Enum.map(l1, fn v -> v * count_in(v, l2) end)
    |> Enum.sum()
  end

  def count_in(val, list) do
    Enum.filter(list, &(&1 == val))
    |> length()
  end
end
