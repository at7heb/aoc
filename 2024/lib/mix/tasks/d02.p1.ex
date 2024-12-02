defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode.Day02
  @day "02"
  @shortdoc "Day 02 Part 1"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        (
          input
          |> part1()
          |> IO.inspect(label: "Part 1 Results")

          IO.puts("Part 1 Test Results #{part1(test_input)}")
        )
  end
end
