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
    |> words_to_digits()
    |> make_list()
    |> find_values2()
    |> compute_calibration()
  end

  def words_to_digits(text) do
    text
    |> String.replace("zero", "z0o", global: true)
    |> String.replace("one", "o1e", global: true)
    |> String.replace("two", "t2o", global: true)
    |> String.replace("three", "t3e", global: true)
    |> String.replace("four", "f4r", global: true)
    |> String.replace("five", "f5e", global: true)
    |> String.replace("six", "s6x", global: true)
    |> String.replace("seven", "s7n", global: true)
    |> String.replace("eight", "e8t", global: true)
    |> String.replace("nine", "n9e", global: true)
  end

  def find_values2(input_list) do
    v1 = Enum.map(input_list, fn record -> first_number(record) end)
    v2 = Enum.map(input_list, fn record -> first_number(String.reverse(record)) end)
    v12 = Enum.zip([v1, v2])
    Enum.map(v12, fn {a, b} -> String.to_integer(a <> b) end)
  end

  def first_number(record) do
    pat = ~r/[0-9]/
    [digit] = Regex.run(pat, record, capture: :first)
    digit
  end
end
