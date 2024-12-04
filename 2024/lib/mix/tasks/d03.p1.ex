defmodule Mix.Tasks.D03.P1 do
  use Mix.Task

  import AdventOfCode.Day03

  @shortdoc "Day 03 Part 1"
  @day "03"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        (
          IO.puts("Day #{@day} part 1: #{part1(input)}")
          IO.puts("Day #{@day} part 1 test: #{part1(test_input)}")
        )
  end
end
