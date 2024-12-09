defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06
  @day "06"
  # @tag :skip
  test "part1" do
    input = AdventOfCode.Day00.get_test(@day)
    result = part1(input)

    assert result == 41
  end

  @tag :skip
  test "part2" do
    input = AdventOfCode.Day00.get_test(@day)
    result = part2(input)

    assert result == 71503
  end
end
