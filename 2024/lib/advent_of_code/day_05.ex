defmodule AdventOfCode.Day05 do
  defstruct rules: [], plans: [], good_plans: [], rule_breakers: [], repairs: []

  # @max_iterations 100
  def part1(input) do
    answer =
      %__MODULE__{}
      |> setup(input)
      |> get_plans_sorted()

    answer.good_plans |> find_middles |> Enum.sum()
  end

  def setup(input), do: setup(%__MODULE__{}, input)

  def setup(%__MODULE__{} = state, input) do
    [rules, plans] = String.split(input, "\n\n")

    rules =
      String.split(rules, "\n")
      |> Enum.map(fn rule -> String.split(rule, "|") end)
      |> Enum.map(fn [a, b] -> [String.to_integer(a), String.to_integer(b)] end)

    plans =
      String.split(plans, "\n")
      |> Enum.map(fn plan -> String.split(plan, ",") end)
      |> Enum.map(fn page_list -> Enum.map(page_list, fn page -> String.to_integer(page) end) end)

    # IO.puts("#{length(rules)} rules read")
    # IO.puts("#{length(plans)} plans read")
    # IO.puts("#{List.flatten(plans) |> Enum.sum()} pages to be printed")
    # # evens = Enum.filter(plans, fn plan -> 0 == rem(length(plan), 2) end)
    # # IO.puts("#{length(evens)} plans with even number of pages")
    # IO.puts("#{List.flatten(plans) |> Enum.min()} smallest page number")
    # IO.puts("#{List.flatten(plans) |> Enum.max()} largest page number")
    # IO.puts("#{List.flatten(rules) |> Enum.min()} rules' smallest page number")
    # IO.puts("#{List.flatten(rules) |> Enum.max()} rules' largest page number")
    # non_unique = Enum.filter(plans, fn plan -> length(Enum.uniq(plan)) != length(plan) end)
    # IO.puts("#{length(non_unique)} plans have non-unique pages")
    %{state | rules: rules, plans: plans, repairs: []}
  end

  def get_plans_sorted(%__MODULE__{plans: plans, rules: rules} = state) do
    good_bad_lists =
      Enum.reduce(plans, {[], []}, fn plan, good_bad_lists ->
        check_plan(plan, rules, good_bad_lists)
      end)

    %{state | good_plans: elem(good_bad_lists, 0), rule_breakers: elem(good_bad_lists, 1)}
  end

  def check_plan(plan, rules, good_bad_lists) do
    case Enum.any?(rules, fn [_early, _late] = rule -> breaks_rule?(plan, rule) end) do
      true -> {elem(good_bad_lists, 0), elem(good_bad_lists, 1) ++ [plan]}
      false -> {elem(good_bad_lists, 0) ++ [plan], elem(good_bad_lists, 1)}
      _ -> {[], []}
    end
  end

  def find_middles(plans) when is_list(plans) do
    Enum.map(plans, fn plan ->
      l2 = div(length(plan), 2)
      Enum.at(plan, l2)
    end)
  end

  def part2(input) when is_binary(input) do
    answer =
      %__MODULE__{}
      |> setup(input)
      |> get_plans_sorted()
      |> fix_rule_breakers()

    answer.good_plans |> dbg()
    answer.rule_breakers |> dbg
    answer.repairs |> dbg
    answer.repairs |> find_middles |> Enum.sum()
  end

  def fix_rule_breakers(%__MODULE__{} = state) do
    Enum.reduce(state.rule_breakers, state, fn plan, state -> fix_rule_breaker(state, plan, 0) end)
  end

  # def fix_rule_breaker(%__MODULE__{} = state, plan) when is_list(plan) do
  #   new_plan = fix_rule_breaker(state.rules, plan, 0)

  #   case new_plan != plan do
  #     true -> %{state | repairs: [new_plan | state.repairs]} |> dbg
  #     _ -> state |> dbg
  #   end
  # end

  def fix_rule_breaker(state, _plan, count) when count > 30, do: state

  def fix_rule_breaker(state, plan, count) do
    new_plan = Enum.reduce(state.rules, plan, fn rule, plan -> apply_rule_to_plan(rule, plan) end)

    cond do
      new_plan == plan -> %{state | repairs: [new_plan | state.repairs]}
      true -> fix_rule_breaker(state, new_plan, count + 1)
    end
  end

  def breaks_rule?(plan, [early, late] = _rule) do
    early_location = Enum.find_index(plan, fn element -> element == early end)
    late_location = Enum.find_index(plan, fn element -> element == late end)

    cond do
      early_location == nil -> false
      late_location == nil -> false
      early_location < late_location -> false
      true -> true
    end
  end

  def apply_rule_to_plan(rule, plan), do: fix_plan(plan, rule, 0)

  def fix_plan(plan, [early, late] = _rule, _count) do
    early_location = Enum.find_index(plan, fn element -> element == early end)
    late_location = Enum.find_index(plan, fn element -> element == late end)

    cond do
      early_location == nil ->
        plan

      late_location == nil ->
        plan

      # this should never happen!
      early_location < late_location ->
        plan

      true ->
        {early_location, late_location} = {late_location, early_location}

        new_plan =
          plan |> List.replace_at(early_location, early) |> List.replace_at(late_location, late)

        # {plan, new_plan} |> dbg
        new_plan
        # if plan == new_plan, do: div(1, 0), else: new_plan)
    end
  end

  # def detect_violations(%__MODULE__{} = state, plan) when is_list(plan) do
  #   broken_rule_vector =
  #     Enum.map(state.rules, fn rule -> broken_rules(plan, rule) end)
  #     |> Enum.filter(fn elt -> elt != nil end)

  #   if broken_rule_vector != [], do: broken_rule_vector
  #   state
  # end

  # # return 1 if rule is broken, zero if not
  # def broken_rules(plan, [early, late] = rule) when is_list(plan) do
  #   early_location = Enum.find_index(plan, fn element -> element == early end)
  #   late_location = Enum.find_index(plan, fn element -> element == late end)

  #   cond do
  #     early_location == nil -> nil
  #     late_location == nil -> nil
  #     early_location < late_location -> nil
  #     true -> {plan, rule}
  #   end
  # end

  # def fix_violations(%__MODULE__{} = state) do
  #   state
  # end
end
