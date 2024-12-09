defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01
  @mh AdventOfCode
  @day "01"

  @tag :skip
  test "part1" do
    result = part1(@mh.Day00.get_test(@day))

    assert result == 11
  end

  @tag :skip
  test "part2" do
    result = part2(the_input2())

    assert result == 281
  end

  def the_input do
    """
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
    """
  end

  def the_input2() do
    """
        two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """
  end
end
