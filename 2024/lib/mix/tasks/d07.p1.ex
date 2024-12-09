defmodule Mix.Tasks.D07.P1 do
  use Mix.Task

  import AdventOfCode.Day07

  @shortdoc "Day 07 Part 1"
  @day "07"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        (
          IO.puts("Day 07 part 1 test result #{part1(test_input)}")

          IO.puts("Day 07 part 1 result #{part1(input)}")
        )
  end
end
