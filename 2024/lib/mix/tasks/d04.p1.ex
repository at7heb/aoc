defmodule Mix.Tasks.D04.P1 do
  use Mix.Task

  import AdventOfCode.Day04

  @shortdoc "Day 04 Part 1"
  @day "04"
  def run(args) do
    input = AdventOfCode.Day00.get("04")
    test_input = AdventOfCode.Day00.get_test("04")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        (
          IO.puts("Day #{@day} Part 1 Test Result: #{part1(test_input)}")
          IO.puts("Day #{@day} Part 1  Result: #{part1(input)}")
        )
  end
end
