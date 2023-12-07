defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "part1" do
    input = AdventOfCode.Day05.get("05-1-test")
    result = part1(input) |> dbg

    assert result == 35
  end

  # @tag :skip
  test "part2" do
    input = AdventOfCode.Day05.get("05-1-test")
    result = part2(input) |> dbg

    assert result
  end
end
