defmodule Mix.Tasks.D05.P1 do
  use Mix.Task

  import AdventOfCode.Day05

  @shortdoc "Day 05 Part 1"
  @day "05"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        (
          IO.puts("Part 1  Results: #{part1(input)}")
          IO.puts("Part 1 Test Results: #{part1(test_input)}")
        )
  end
end
