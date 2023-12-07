defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  @tag :skip
  test "part1" do
    input = AdventOfCode.Day02.get("02-1-test")
    result = part1(input)

    assert result == 8
  end

  @tag :skip
  test "part2" do
    input = AdventOfCode.Day02.get("02-1-test")
    result = part2(input)

    assert result == 2286
  end
end
