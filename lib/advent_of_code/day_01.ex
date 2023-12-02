defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> make_list()
    |> find_values()
    |> compute_calibration()
  end

  def make_list(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.filter(fn a -> String.length(a) > 0 end)
  end

  def find_values(input_list) do
    v1 = Enum.map(input_list, fn record -> first_digit(record) end)
    v2 = Enum.map(input_list, fn record -> first_digit(String.reverse(record)) end)
    v12 = Enum.zip([v1, v2])
    Enum.map(v12, fn {a, b} -> String.to_integer(a <> b) end)
  end

  def first_digit(record) do
    pat = ~r/[0-9]/
    [digit] = Regex.run(pat, record, capture: :first)
    digit
  end

  def compute_calibration(input_list) do
    Enum.sum(input_list)
  end

  def part2(input) do
    input
    |> make_list()
    |> find_values2()
    |> compute_calibration()
  end

  def find_values2(input_list) do
    v1 = Enum.map(input_list, fn record -> first_number_forward(record) end)
    v2 = Enum.map(input_list, fn record -> first_number_reverse(String.reverse(record)) end)
    v12 = Enum.zip([v1, v2])
    Enum.map(v12, fn {a, b} -> String.to_integer(a <> b) end)
  end

  def first_number_forward(record) do
    pat = ~r/zero|one|two|three|four|five|six|seven|eight|nine|[0-9]/
    first_number_common(pat, record)
  end

  def first_number_reverse(record) do
    pat = ~r/orez|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|[0-9]/
    first_number_common(pat, record)
  end

  def first_number_common(pat, record) do
    [digit] = Regex.run(pat, record, capture: :first)

    case digit do
      "zero" -> "0"
      "orez" -> "0"
      "one" -> "1"
      "eno" -> "1"
      "two" -> "2"
      "owt" -> "2"
      "three" -> "3"
      "eerht" -> "3"
      "four" -> "4"
      "ruof" -> "4"
      "five" -> "5"
      "evif" -> "5"
      "six" -> "6"
      "xis" -> "6"
      "seven" -> "7"
      "neves" -> "7"
      "eight" -> "8"
      "thgie" -> "8"
      "nine" -> "9"
      "enin" -> "9"
      _ -> digit
    end
  end
end
