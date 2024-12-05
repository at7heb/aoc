defmodule Mix.Tasks.D04.P2 do
  use Mix.Task

  import AdventOfCode.Day04

  @shortdoc "Day 04 Part 2"
  @day "04"
  def run(args) do
    input = AdventOfCode.Day00.get("04")
    test_input = AdventOfCode.Day00.get_test("04")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        (
          IO.puts("Day #{@day} Part 2 Test Result: #{part2(test_input)}")
          IO.puts("Day #{@day} Part 2  Result: #{part2(input)}")
        )
  end
end
