defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = Day02.get("02-1-test")
    result = part1(input)

    assert result
  end

  @tag :skip
  test "part2" do
    input = Day02.get("02-2-test")
    result = part2(input)

    assert result
  end
end
