defmodule AdventOfCode.Day06 do
  defstruct layout: %{},
            current: {-1, -1},
            next: {-1, -1},
            direction: :north,
            visited: %MapSet{},
            max_row: -1,
            max_col: -1,
            count: 0

  def part2(input) do
    state =
      %__MODULE__{}
      |> setup(input)

    # update since visited has direction and location
    state = %{state | visited: MapSet.new([{:north, state.current}])}
    search_space = Map.keys(state.layout)
    IO.puts("Must search #{length(search_space)} things")

    loop_locations =
      Enum.filter(Enum.zip(1..length(search_space), search_space), fn {iteration, coordinate} ->
        guard_loops?(state, iteration, coordinate)
      end)

    length(loop_locations)
  end

  def guard_loops?(%__MODULE__{} = state, iteration, coordinate) do
    current_item = Map.get(state.layout, coordinate)
    if rem(iteration, 5000) == 1, do: IO.puts("iteration: #{iteration}")

    cond do
      # can't put something where guard is
      current_item == "^" -> false
      # if already blocked, no use trying this
      current_item == "#" -> false
      true -> guard_loops?(%{state | layout: Map.put(state.layout, coordinate, "#")})
    end
  end

  def guard_loops?(%__MODULE__{} = state) do
    new_state = advance1(state)
    # will be nil, ".", or "#"
    case Map.get(new_state.layout, new_state.next) do
      # we're done
      nil ->
        false

      "#" ->
        update_direction(new_state) |> guard_loops?()

      "." ->
        if MapSet.member?(new_state.visited, {new_state.direction, new_state.next}),
          do: true,
          else: accept_advance2(new_state) |> guard_loops?()

      "^" ->
        if MapSet.member?(new_state.visited, {new_state.direction, new_state.next}),
          do: true,
          else: accept_advance2(new_state) |> guard_loops?()
    end
  end

  def accept_advance2(%__MODULE__{} = state) do
    %{
      state
      | current: state.next,
        next: {:r, :c},
        visited: MapSet.put(state.visited, {state.direction, state.next})
    }
  end

  def part1(input) do
    answer =
      %__MODULE__{}
      |> setup(input)
      |> patrol1()
      |> count_patrolled()

    answer
  end

  def setup(%__MODULE__{} = state, input) when is_binary(input) do
    input_list = String.split(input, "\n", trim: true)

    state =
      Enum.reduce(0..(length(input_list) - 1), state, fn index, state ->
        setup(state, index, Enum.at(input_list, index))
      end)

    # Enum.filter returns a list; use the first in case of several
    start_point =
      Map.keys(state.layout)
      |> Enum.filter(fn coords -> Map.get(state.layout, coords) == "^" end)
      |> hd()

    %{
      state
      | max_row: length(input_list) - 1,
        max_col: String.length(hd(input_list)) - 1,
        current: start_point,
        visited: MapSet.new([start_point])
    }
  end

  # def setup(%__MODULE__{layout: layout} = state, input) do
  def setup(%__MODULE__{layout: layout} = state, row_index, line) when is_binary(line) do
    line_positions = String.split(line, "", trim: true)

    new_layout =
      Enum.reduce(0..(length(line_positions) - 1), layout, fn column_index, layout ->
        Map.put(layout, {row_index, column_index}, Enum.at(line_positions, column_index))
      end)

    %{state | layout: new_layout}
  end

  def patrol1(%__MODULE__{layout: _layout} = state) do
    new_state = advance1(state)
    # will be nil, ".", or "#"

    case Map.get(new_state.layout, new_state.next) do
      # we're done
      nil -> new_state
      "#" -> update_direction(new_state) |> patrol1()
      "." -> accept_advance(new_state) |> patrol1()
      "^" -> accept_advance(new_state) |> patrol1()
    end

    # cond do
    #   !next_in_the_lab(new_state) -> new_state
    #   blocked?(new_state) -> update_direction(state) |> patrol1()
    #   true -> accept_advance(new_state) |> patrol1()
    # end
  end

  def count_patrolled(%__MODULE__{visited: visited} = _state) do
    MapSet.size(visited)
  end

  def blocked?(%__MODULE__{} = state), do: Map.get(state.layout, state.next) == "#"

  def next_in_the_lab(%__MODULE__{next: {r, c}, max_row: max_row, max_col: max_col}) do
    r >= 0 && r <= max_row && c >= 0 && c <= max_col
  end

  def update_direction(%__MODULE__{} = state) do
    new_dir =
      case state.direction do
        :north -> :east
        :east -> :south
        :south -> :west
        :west -> :north
      end

    %{state | direction: new_dir}
  end

  def increments_from_direction(%__MODULE__{} = state) do
    case state.direction do
      :north -> {-1, 0}
      :east -> {0, 1}
      :south -> {1, 0}
      :west -> {0, -1}
    end
  end

  def advance1(%__MODULE__{current: {cur_row, cur_col}} = state) do
    {inc_row, inc_col} = increments_from_direction(state)
    next = {cur_row + inc_row, cur_col + inc_col}
    %{state | next: next}
  end

  def accept_advance(%__MODULE__{} = state) do
    %{state | current: state.next, next: {:r, :c}, visited: MapSet.put(state.visited, state.next)}
  end
end
