defmodule AdventOfCode.Day07 do
  # list of lists
  # expression_terms; list_of_terms [[1,2,3], [4,5,6]]
  # target_values: [6, 120]
  # current_terms: list of terms we're working on [1,2,3]
  # current_target: 6
  # ones that work: [6, 120] -- the targets that work
  defstruct list_of_terms: [],
            target_values: [],
            current_terms: [],
            current_target: -1,
            ones_that_work: [],
            part: 0

  def part1(input) do
    %__MODULE__{}
    |> setup(input, 1)
    |> find_ones_that_work
    |> get_answer()

    # |> dbg
  end

  def setup(%__MODULE__{} = _state, input, part) do
    # convert AKQJT to EDCBA so the who sequence can be treated as a hex (or base 15) number
    # for sorting to determine the hand strength!
    calibrations = String.split(input, "\n", trim: true)

    pairs = Enum.map(calibrations, fn line -> String.split(line, ": ") end)

    {targets, lists} =
      Enum.reduce(pairs, {[], []}, fn [target, text_list], {targets, lists} ->
        [target, text_list]
        new_targets = targets ++ [String.to_integer(target)]
        term_text_list = String.split(text_list, " ", trim: true)
        term_list = Enum.map(term_text_list, fn term_text -> String.to_integer(term_text) end)

        new_lists =
          lists ++ [term_list]

        {new_targets, new_lists}
      end)

    %__MODULE__{
      list_of_terms: lists,
      target_values: targets,
      current_terms: [],
      current_target: -1,
      ones_that_work: [],
      part: part
    }
  end

  def find_ones_that_work(%__MODULE__{list_of_terms: []} = state), do: state

  def find_ones_that_work(
        %__MODULE__{
          list_of_terms: [current_terms | rest_of_terms],
          target_values: [current_target | rest_of_targets]
        } = state
      ) do
    %{
      state
      | list_of_terms: rest_of_terms,
        target_values: rest_of_targets,
        current_terms: current_terms,
        current_target: current_target
    }
    |> see_if_this_one_works()
    |> find_ones_that_work()
  end

  def see_if_this_one_works(
        %__MODULE__{current_target: target, current_terms: terms, ones_that_work: ones_that_work} =
          state
      ) do
    base = if state.part == 1, do: 2, else: 3
    op_val_lists = get_operator_and_value_lists(terms, base)
    this_one_works = Enum.any?(op_val_lists, fn ovl -> target == eval(ovl) end)
    add_to_ones = if this_one_works, do: [target], else: []
    new_ones_that_work = (ones_that_work ++ add_to_ones) |> List.flatten()
    %{state | ones_that_work: new_ones_that_work}
  end

  def get_operator_and_value_lists(terms, base) when is_list(terms) do
    digit_count = length(terms) - 1
    result_count = base ** digit_count

    Enum.map(0..(result_count - 1), fn ops_in_base ->
      Enum.zip([:load] ++ arith_operator_list(digit_count, ops_in_base, base), terms)
    end)
  end

  def arith_operator_list(digit_count, ops_in_base, base) when base <= 3 do
    {_, op_list} =
      Enum.reduce(1..digit_count, {ops_in_base, []}, fn _count, {ops_in_base, op_list} ->
        new_op = elem({:add, :multiply, :concatenate}, rem(ops_in_base, base))
        {div(ops_in_base, base), [new_op | op_list]}
      end)

    op_list
  end

  def eval(op_and_term_list), do: eval(op_and_term_list, 0)
  def eval([] = _op_and_term_list, accumulator), do: accumulator

  def eval([this_op_and_term | rest_of_op_and_term_list] = _op_and_term_list, accumulator) do
    {op, term} = this_op_and_term

    new_accumulator =
      case op do
        :load ->
          term

        :add ->
          accumulator + term

        :multiply ->
          accumulator * term

        :concatenate ->
          (Integer.to_string(accumulator) <> Integer.to_string(term)) |> String.to_integer()
      end

    eval(rest_of_op_and_term_list, new_accumulator)
  end

  def get_answer(%__MODULE__{} = state) do
    Enum.sum(state.ones_that_work)
  end

  def part2(input) do
    %__MODULE__{}
    |> setup(input, 2)
    |> find_ones_that_work
    |> get_answer()
  end
end
