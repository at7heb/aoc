defmodule AdventOfCode.Day07 do
  def part1(input) do
    input
    |> length()
  end

  def part2(input) do
    input
    |> length()
  end

  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end
end
