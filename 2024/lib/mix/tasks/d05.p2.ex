defmodule Mix.Tasks.D05.P2 do
  use Mix.Task

  import AdventOfCode.Day05

  @day "05"
  def run(args) do
    input = AdventOfCode.Day00.get(@day)
    test_input = AdventOfCode.Day00.get_test(@day)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        (
          IO.puts("Part 2  Results: #{part2(input)}")
          IO.puts("Part 2 Test Results: #{part2(test_input)}")
        )
  end
end
