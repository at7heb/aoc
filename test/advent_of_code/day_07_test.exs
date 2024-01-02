defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  @tag :skip
  test "part1" do
    input = AdventOfCode.Day00.get("07-1-test")
    result = part1(input)
    result |> dbg
    assert result
  end

  # @tag :skip
  test "part2" do
    input = AdventOfCode.Day00.get("07-1-test")
    IO.puts("Day 7 Part 2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    result = part2(input)

    assert result
  end
end
