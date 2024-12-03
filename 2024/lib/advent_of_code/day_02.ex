defmodule AdventOfCode.Day02 do
  def part1(input) do
    %{input: input}
    |> parse_lines()
    |> make_diffs()
    |> only_positive_1_to_3()
    |> only_negative_1_to_3()
    |> sum_only_lengths()
  end

  def parse_lines(%{input: input} = state) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ") |> Enum.map(&String.to_integer(&1)) end)
    |> update_state(:parsed_lines, state)
  end

  def make_diffs(%{parsed_lines: lines} = state) do
    lines
    |> Enum.map(fn line ->
      Enum.reduce(tl(line), {[], hd(line)}, fn next_in_line, {acc_list, prev_in_line} ->
        {[next_in_line - prev_in_line | acc_list], next_in_line}
      end)
    end)
    |> Enum.map(&elem(&1, 0))
    |> update_state(:diffed_lines, state)
  end

  def only_positive_1_to_3(%{diffed_lines: lines} = state) do
    lines
    |> Enum.filter(&Enum.all?(&1, fn v -> v > 0 and v <= 3 end))
    |> update_state(:only_positive_1_to_3, state)
  end

  def only_negative_1_to_3(%{diffed_lines: lines} = state) do
    lines
    |> Enum.filter(&Enum.all?(&1, fn v -> v < 0 and v >= -3 end))
    |> update_state(:only_negative_1_to_3, state)
  end

  def sum_only_lengths(%{only_positive_1_to_3: op, only_negative_1_to_3: on} = _state) do
    length(op) + length(on)
  end

  def update_state(value, key, %{} = state) when is_atom(key) do
    Map.put(state, key, value)
  end

  def part2(input) do
    %{input: input}
    |> parse_lines()
    |> try_each_line()
    |> count_okay_lines()
  end

  def try_each_line(%{parsed_lines: parsed} = state) do
    parsed
    |> Enum.map(&add_without_one(&1))
    |> Enum.map(&if_any_okay_then_1(&1))
    |> update_state(:okay_lines, state)
  end

  def add_without_one(l) when is_list(l) do
    0..(length(l) - 1)
    |> Enum.shuffle()
    |> Enum.reduce([l], fn index, acc -> acc ++ [List.delete_at(l, index)] end)
  end

  def if_any_okay_then_1(lofls) when is_list(lofls) do
    lofls
    |> Enum.any?(fn a_list -> if_this_okay_then_true(a_list) end)
    |> case do
      1 -> 1
      true -> 1
      _ -> 0
    end
  end

  def if_this_okay_then_true(l) when is_list(l) do
    diffs = diffs_of_list(l)

    cond do
      is_ascending(diffs) -> true
      is_descending(diffs) -> true
      true -> false
    end
  end

  def diffs_of_list(l) when is_list(l) do
    Enum.reduce(tl(l), {[], hd(l)}, fn next_in_line, {acc_list, prev_in_line} ->
      {[next_in_line - prev_in_line | acc_list], next_in_line}
    end)
    |> elem(0)
  end

  def is_ascending(diffs) when is_list(diffs) do
    Enum.all?(diffs, &(&1 > 0 && &1 <= 3))
  end

  def is_descending(diffs) when is_list(diffs) do
    Enum.all?(diffs, &(&1 < 0 && &1 >= -3))
  end

  def count_okay_lines(%{okay_lines: okl}), do: Enum.sum(okl)
end
