defmodule AdventOfCode.Day05 do
  defstruct rules: [], plans: []

  def part1(input) do
    answer =
      %__MODULE__{}
      |> setup(input)
      |> find_violations()

    Enum.sum(answer.products)
  end

  def setup(input), do: setup(%__MODULE__{}, input)

  def setup(%__MODULE__{} = _state, input) do
    [rules, plans] = String.split(input, "\n\n")

    rules =
      String.split(rules, "\n")
      |> Enum.map(fn rule -> String.split(rule, "|") end)
      |> Enum.map(fn [a, b] -> [String.to_integer(a), String.to_integer(b)] end)

    plans =
      String.split(plans, "\n")
      |> Enum.map(fn plan -> String.split(plan, ",") end)
      |> Enum.map(fn page_list -> Enum.map(page_list, fn page -> String.to_integer(page) end) end)

    IO.puts("#{length(rules)} rules read")
    IO.puts("#{length(plans)} plans read")
    IO.puts("#{List.flatten(plans) |> Enum.sum()} pages to be printed")
    # evens = Enum.filter(plans, fn plan -> 0 == rem(length(plan), 2) end)
    # IO.puts("#{length(evens)} plans with even number of pages")
    IO.puts("#{List.flatten(plans) |> Enum.min()} smallest page number")
    IO.puts("#{List.flatten(plans) |> Enum.max()} largest page number")
    # non_unique = Enum.filter(plans, fn plan -> length(Enum.uniq(plan)) != length(plan) end)
    # IO.puts("#{length(non_unique)} plans have non-unique pages")
    nil
  end

  def find_violations(%__MODULE__{} = state) do
    state
  end

  def part2(input) when is_binary(input) do
    nil
  end
end
