defmodule Mix.Tasks.D07.P2 do
  use Mix.Task

  import AdventOfCode.Day07

  @shortdoc "Day 07 Part 2"
  @day "07"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        (
          IO.puts("Day 07 part 2 test result #{part2(test_input)}")

          IO.puts("Day 07 part 2 result #{part2(input)}")
        )
  end
end
