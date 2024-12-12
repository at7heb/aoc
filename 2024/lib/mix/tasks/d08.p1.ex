defmodule Mix.Tasks.D08.P1 do
  use Mix.Task

  import AdventOfCode.Day08
  @day "08"
  @shortdoc "Day 08 Part 1"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        (
          IO.puts("Part 1 test result: #{part1(test_input)}")
          IO.puts("Part 1 results: #{part1(input)}")
        )
  end
end
