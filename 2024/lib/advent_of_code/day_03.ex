defmodule AdventOfCode.Day03 do
  defstruct subject: "",
            products: [],
            enabled: true

  # schematic is a map of linenumber -> corresponding line of schematic
  # numbers is a set of {linenumber, loc, length} extents of numbers
  # symbols is a set of {linenumber, loc} symbol locations (just 1 character)

  def part1(input) do
    answer =
      %__MODULE__{}
      |> setup(input)
      |> find_multiplies()

    Enum.sum(answer.products)
  end

  def setup(%__MODULE__{} = state, input) do
    s = String.replace(input, "\n", "")
    %{state | subject: s}
  end

  def find_multiplies(%__MODULE__{subject: s} = state) do
    p = ~r/mul\((?<a>[\d]+),(?<b>[\d]+)\)/U
    c = Regex.named_captures(p, s, return: :index)

    case c do
      nil ->
        state

      _ ->
        a = String.slice(s, elem(c["a"], 0), elem(c["a"], 1)) |> String.to_integer()
        b = String.slice(s, elem(c["b"], 0), elem(c["b"], 1)) |> String.to_integer()
        r = String.slice(s, elem(c["b"], 0) + elem(c["b"], 1) + 1, 999_999_999)
        new_state = %{state | products: [a * b | state.products], subject: r}
        find_multiplies(new_state)
    end
  end

  def part2(input) do
    answer =
      %__MODULE__{}
      |> setup(input)
      |> find_multiplies2()

    Enum.sum(answer.products)
  end

  def find_multiplies2(%__MODULE__{subject: ""} = state), do: state

  def find_multiplies2(%__MODULE__{subject: s} = state) do
    p_mul = ~r/mul\((?<a>[\d]+),(?<b>[\d]+)\)/U
    p_do = ~r/(?<d>do\(\))/
    p_dont = ~r/(?<d>don't\(\))/
    c_mul = Regex.named_captures(p_mul, s, return: :index)
    {start, length} = do_dont_region(c_mul["b"])
    do_dont_search_string = String.slice(s, start, length)
    c_do = Regex.named_captures(p_do, do_dont_search_string, return: :index)
    c_dont = Regex.named_captures(p_dont, do_dont_search_string, return: :index)

    cond do
      # no mul() instruction:
      nil == c_mul -> %{state | subject: ""}
      # neither do() nor don't() instructions before mul()
      nil == c_do and nil == c_dont -> match_multiply(state, c_mul)
      # a do() before the mul(), but no don't()
      nil == c_dont -> match_multiply(%{state | enabled: true}, c_mul)
      # a don't() before the mul(), but no do()
      nil == c_do -> match_multiply(%{state | enabled: false}, c_mul)
      # both do() and don't(). believe the second and scan after it
      true -> handle_do_and_dont(state, c_do, c_dont)
    end
    |> find_multiplies2()
  end

  def match_multiply(%__MODULE__{subject: s} = state, c_mul) do
    a = String.slice(s, elem(c_mul["a"], 0), elem(c_mul["a"], 1)) |> String.to_integer()
    b = String.slice(s, elem(c_mul["b"], 0), elem(c_mul["b"], 1)) |> String.to_integer()
    r = String.slice(s, elem(c_mul["b"], 0) + elem(c_mul["b"], 1) + 1, 999_999_999)

    case state.enabled do
      true -> %{state | products: [a * b | state.products], subject: r}
      false -> %{state | subject: r}
    end
  end

  def handle_do_and_dont(%__MODULE__{subject: s} = state, c_do, c_dont) do
    {enable, position} =
      if elem(c_do["d"], 0) > elem(c_dont["d"], 0) do
        # do() is later; advance past and enable
        {true, elem(c_do["d"], 0) + elem(c_do["d"], 1)}
      else
        # don't() is second, advance past and disable
        {false, elem(c_dont["d"], 0) + elem(c_dont["d"], 1)}
      end

    new_s = String.slice(s, position, 999_999_999)
    %{state | subject: new_s, enable: enable}
  end

  def do_dont_region(nil), do: {0, 1}
  def do_dont_region({ndx, _length}), do: {0, ndx}
end
