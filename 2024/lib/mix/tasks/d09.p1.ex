defmodule Mix.Tasks.D09.P1 do
  use Mix.Task

  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 1"
  @day "09"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else: IO.puts("Day #{@day} test result: #{part1(test_input)}")

    IO.puts("Day #{@day} result: #{part1(input)}")
  end
end
