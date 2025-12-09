defmodule A02 do
  @moduledoc """
  Documentation for `A02`.
  """
  def solve(input) do
    input
    |> String.split("\n")
    |> dbg
    |> Enum.join("")
    |> String.trim()
    |> String.split(",")
    |> dbg()
    |> Enum.map(fn pair -> String.split(pair, "-") |> List.to_tuple() end)
    |> Enum.map(fn {f, l} -> {String.to_integer(f), String.to_integer(l)} end)
    |> part1()
    |> part2()

    nil
  end

  # answer 21139440284
  def part1(input) do
    part(input, 0, :first_part) |> answer()
    input
  end

  def part([], sum, _), do: sum

  def part([first | rest] = _input, sum, which_part) do
    {low, high} = first
    new_sum = part(low, high, sum, which_part)
    part(rest, new_sum, which_part)
  end

  def part(low, high, sum, which_part) do
    invalids =
      Enum.filter(low..high, fn stock_number -> is_invalid?(stock_number, which_part) end)

    sum + Enum.sum(invalids)
  end

  def is_invalid?(value, :first_part) when is_integer(value) do
    string_value = Integer.to_string(value)

    cond do
      rem(String.length(string_value), 2) == 1 -> false
      true -> is_invalid?(string_value, :first_part)
    end
  end

  def is_invalid?(string_value, :first_part) when is_binary(string_value) do
    len = div(String.length(string_value), 2)
    first = String.slice(string_value, 0..(len - 1))
    second = String.slice(string_value, len..-1//1)
    first == second
  end

  @pairs [{1, 10}, {2, 5}, {3, 4}, {4, 3}, {5, 2}]
  def is_invalid?(value, :second_part) when is_integer(value) do
    string_value = Integer.to_string(value)

    rv =
      Enum.reduce_while(@pairs, false, fn {len, count}, _acc ->
        if invalid_helper(string_value, len, count) do
          IO.puts("part2: true for #{string_value} len #{len} count #{count}")
          {:halt, true}
        else
          {:cont, false}
        end
      end)

    rv
  end

  def invalid_helper(s, len, count) do
    s_len = String.length(s)

    if rem(s_len, len) == 0 and s_len > len do
      initial = String.slice(s, 0..(len - 1))
      match = String.duplicate(initial, count)
      trimmed_match = String.slice(match, 0..(s_len - 1))
      s == trimmed_match
    else
      false
    end
  end

  def answer(sum) do
    sum |> dbg
  end

  def part2(input) do
    part(input, 0, :second_part) |> answer()
    input
  end

  def test do
    """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
    1698522-1698528,446443-446449,38593856-38593862,565653-565659,
    824824821-824824827,2121212118-2121212124
    """
  end

  def prod do
    """
    9191906840-9191941337,7671-13230,2669677096-2669816099,2-12,229599-392092,48403409-48523311,96763-229430,1919163519-1919240770,74928-96389,638049-668065,34781-73835,736781-819688,831765539-831907263,5615884-5749554,14101091-14196519,7134383-7169141,413340-625418,849755289-849920418,7745350-7815119,16717-26267,4396832-4549887,87161544-87241541,4747436629-4747494891,335-549,867623-929630,53-77,1414-3089,940604-1043283,3444659-3500714,3629-7368,79-129,5488908-5597446,97922755-98097602,182-281,8336644992-8336729448,24-47,613-1077
    """
  end
end
