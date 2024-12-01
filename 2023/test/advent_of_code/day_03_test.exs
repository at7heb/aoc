defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  @tag :skip
  test "part1" do
    input = AdventOfCode.Day03.get("03-1-test")
    result = part1(input)

    assert result == 4361
  end

  @tag :skip
  test "part2" do
    input = AdventOfCode.Day03.get("03-1-test")
    result = part2(input)

    assert result == 467_835
  end
end
