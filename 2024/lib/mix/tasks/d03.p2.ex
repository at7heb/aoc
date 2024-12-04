defmodule Mix.Tasks.D03.P2 do
  use Mix.Task

  import AdventOfCode.Day03

  @shortdoc "Day 03 Part 2"
  @day "03"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        (
          IO.puts("Day #{@day} part 2: #{part1(input)}")
          IO.puts("Day #{@day} part 2 test: #{part2(test_input)}")
        )
  end
end
