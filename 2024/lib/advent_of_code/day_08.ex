defmodule AdventOfCode.Day08 do
  # freq_locations maps a frequency (letter or number)
  #   to all locations where it occurs
  # antinodes is a set with a member for each antinode location
  # max_row, max_col are the limits of the map.
  # freq_list has the frequencies; the hd() get processed & removed
  # combinations_for_one_frequency has all the location combinations
  #   (taken 2 at a time)
  defstruct freq_locations: %{},
            antinodes: MapSet.new([]),
            max_row: 0,
            max_col: 0,
            freq_list: [],
            combinations: []

  def part1(input) do
    %__MODULE__{}
    |> setup(input)
    |> make_frequency_list()
    |> make_combinations()
    |> find_anti_nodes()
    |> count_anti_nodes()
  end

  def count_anti_nodes(%__MODULE__{} = state) do
    MapSet.size(state.antinodes)
  end

  def setup(%__MODULE__{} = state, input) do
    lines = String.split(input, "\n")

    locations =
      Enum.reduce(0..(length(lines) - 1), %{}, fn line_ndx, map ->
        setup_line(line_ndx, Enum.at(lines, line_ndx), map)
      end)

    frequencies = Map.keys(locations)

    %{
      state
      | freq_locations: locations,
        freq_list: frequencies,
        max_row: length(lines) - 1,
        max_col: String.length(hd(lines)) - 1
    }
  end

  def setup_line(line_ndx, line, map) do
    Enum.reduce(0..(String.length(line) - 1), map, fn col, map ->
      char = String.at(line, col)
      coord = {line_ndx, col}
      if char != ".", do: Map.put(map, char, [coord | Map.get(map, char, [])]), else: map
    end)
  end

  def make_frequency_list(%__MODULE__{} = state) do
    frequencies = Map.keys(state.freq_locations)
    %{state | freq_list: frequencies}
  end

  def make_combinations(%__MODULE__{} = state) do
    combinations =
      Enum.reduce(state.freq_list, [], fn freq, combo_list ->
        [{freq, choose2(Map.get(state.freq_locations, freq))} | combo_list]
      end)

    %{state | combinations: combinations}
  end

  def choose2([_only_element]), do: []
  def choose2([element_1, element_2]), do: [{element_1, element_2}]

  def choose2([element_1 | rest_of_elements]) do
    part1 = Enum.map(rest_of_elements, fn element_2 -> {element_1, element_2} end)
    part2 = choose2(rest_of_elements)
    # part1 |> dbg()
    # part2 |> dbg
    [part1 | part2] |> List.flatten()
  end

  def find_anti_nodes(%__MODULE__{} = state) do
    Enum.reduce(state.combinations, state, &anti_nodes_for_one_frequency(&2, &1))
  end

  def anti_nodes_for_one_frequency(%__MODULE__{} = state, {_freq, node_list}) do
    # node_list is a list of {coord1, coord2} tuples.
    # each coord is also a {row, column} tuple

    list_1st_way =
      Enum.map(node_list, fn coord_pair ->
        from_to_delta(coord_pair) |> go_beyond(elem(coord_pair, 1))
      end)

    list_2nd_way =
      Enum.map(node_list, fn coord_pair ->
        reverse_coordinate_pair(coord_pair) |> from_to_delta() |> go_beyond(elem(coord_pair, 0))
      end)

    joint_list = Enum.filter(list_1st_way ++ list_2nd_way, fn coord -> in_map?(state, coord) end)
    additional_anti_nodes = MapSet.new(joint_list)
    current_anti_nodes = state.antinodes
    %{state | antinodes: MapSet.union(current_anti_nodes, additional_anti_nodes)}
  end

  def from_to_delta({r0, c0}, {r1, c1}), do: {r1 - r0, c1 - c0}
  def from_to_delta({{r0, c0}, {r1, c1}}), do: {r1 - r0, c1 - c0}
  def go_beyond({ir0, ic0}, {r0, c0}), do: {r0 + ir0, c0 + ic0}
  def reverse_coordinate_pair({a, b}), do: {b, a}

  def in_map?(%__MODULE__{max_col: max_col, max_row: max_row} = _state, {r, c} = _coord) do
    r >= 0 && r <= max_row && c >= 0 && c <= max_col
  end

  def find_all_anti_nodes(%__MODULE__{} = state) do
    new_state =
      Enum.reduce(state.combinations, state, &anti_all_nodes_for_one_frequency(&2, &1))

    dbg(new_state.antinodes)
    new_state
  end

  def anti_all_nodes_for_one_frequency(%__MODULE__{} = state, {_freq, node_list}) do
    # node_list is a list of {coord1, coord2} tuples.
    # each coord is also a {row, column} tuple

    list_of_antinodes =
      Enum.map(node_list, fn coord_pair ->
        from_to_delta(coord_pair) |> go_way_beyond(state, elem(coord_pair, 1))
      end)

    list_of_antinodes = List.flatten(list_of_antinodes)

    additional_anti_nodes = MapSet.new(list_of_antinodes)
    current_anti_nodes = state.antinodes
    %{state | antinodes: MapSet.union(current_anti_nodes, additional_anti_nodes)}
  end

  def go_way_beyond(increments, %__MODULE__{} = state, base) do
    {base, increments} |> dbg

    list1 =
      Enum.reduce_while(0..100, [], fn mult, nodes ->
        a = beyond(base, increments, mult)
        if in_map?(state, a), do: {:cont, [a | nodes]}, else: {:halt, nodes}
      end)

    list2 =
      Enum.reduce_while(1..100, [], fn mult, nodes ->
        a = beyond(base, increments, -mult)
        if in_map?(state, a), do: {:cont, [a | nodes]}, else: {:halt, nodes}
      end)

    (list1 ++ list2) |> dbg
  end

  def beyond({base_r, base_c} = base, {incr_r, incr_c} = incr, mult) do
    rv = {base_r + mult * incr_r, base_c + mult * incr_c}
    {base, incr, mult, rv} |> dbg
    rv
  end

  def part2(input) do
    %__MODULE__{}
    |> setup(input)
    |> make_frequency_list()
    |> make_combinations()
    |> find_all_anti_nodes()
    |> count_anti_nodes()
  end
end
