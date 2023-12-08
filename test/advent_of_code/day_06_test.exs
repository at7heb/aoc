defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  # @tag :skip
  test "part1" do
    input = AdventOfCode.Day06.get("06-1-test")
    result = part1(input)

    assert result == 288
  end

  # @tag :skip
  test "part2" do
    input = AdventOfCode.Day06.get("06-1-test")
    result = part2(input)

    assert result == 71503
  end
end
