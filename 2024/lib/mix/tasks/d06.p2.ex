defmodule Mix.Tasks.D06.P2 do
  use Mix.Task

  import AdventOfCode.Day06

  @day "06"
  @shortdoc "Day 06 Part 2"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part2() end}),
      else:
        (
          IO.puts("Day 6 Part 2 test: #{part2(test_input)}")
          IO.puts("Day 6 Part 2: #{part2(input)}")
        )
  end
end
