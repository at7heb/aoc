defmodule Mix.Tasks.D01.P2 do
  use Mix.Task

  import AdventOfCode.Day01

  @shortdoc "Day 01 Part 2"
  def run(args) do
    input = AdventOfCode.Day00.get("01")
    test_input = AdventOfCode.Day00.get_test("01")

    IO.puts("Part 2 Test Results #{part2(test_input)}")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
