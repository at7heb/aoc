defmodule AdventOfCode.Day10 do
  defstruct input: "",
            max_row: 0,
            max_col: 0,
            map: %{},
            trail_heads: [],
            peaks: [],
            trails: []

  @day "10"

  def test1(), do: AdventOfCode.Day00.get_test(@day) |> part1()
  def full1(), do: AdventOfCode.Day00.get(@day) |> part1()

  def part1(input) do
    %__MODULE__{}
    |> parse(input)
    |> find_steps()
    |> info()
    |> find_trail_heads()
    |> find_peaks()
    |> find_trails()
    |> sum()
    |> dbg
  end

  def find_steps(%__MODULE__{} = state) do
    new_map =
    Enum.reduce(get_coords(state), state.map, fn coord, map ->
      steps = steps_for_location(state, coord)
      {elevation, _} = Map.get(map, coord)
      Map.put(map, coord, {elevation, steps})
    end)
    %{state| map: new_map}
  end

  def steps_for_location(%__MODULE__{} = state, {_, _} = coord) do
    increments = [{0,1}, {1,0}, {0,-1}, {-1, 0}]
    {elevation, _} = Map.get(state.map, coord)
    Enum.reduce(increments, [], fn incr, steps_so_far ->
      if elem(Map.get(state.map, incremented_coord(coord, incr), {-99, nil}), 0) == elevation + 1, do: [incremented_coord(coord, incr)| steps_so_far], else: steps_so_far
    end)

  end

  def get_coords(%__MODULE__{} = state), do: (for r <- 0..state.max_row, c <- 0..state.max_col do {r, c} end)

  def incremented_coord({r,c}, {ir, ic}), do: {r+ir, c+ic}

  # set a component in state
  def ss(%__MODULE__{} = state, component, value) when is_atom(component), do: Map.put(state, component, value)

  def parse(%__MODULE__{} = state, input) when is_binary(input) do
    lines = String.split(input, "\n")

    map =
      Enum.reduce(0..(length(lines) - 1), %{}, fn line_ndx, map ->
        setup_line(line_ndx, Enum.at(lines, line_ndx), map)
      end)

    %{
      state
      | map: map,
        max_row: length(lines) - 1,
        max_col: String.length(hd(lines)) - 1,
        input:  lines
    }
  end

  def setup_line(line_ndx, line, map) do
    Enum.reduce(0..(String.length(line) - 1), map, fn col, map ->
      elevation = String.at(line, col) |> String.to_integer()
      coord = {line_ndx, col}
      Map.put(map, coord, {elevation, []})
    end)
  end

  def info(%__MODULE__{} = state) do
    IO.puts("#{state.max_col*state.max_row} places on the map")
    map_as_list = Map.to_list(state.map)
    average_altitude = (map_as_list |> Enum.map(fn {_coord, {altitude, _steps}} -> altitude end) |> Enum.sum()) / (state.max_col*state.max_row)
    trailhead_count = (map_as_list |> Enum.map(fn {_coord, {altitude, _steps}} -> altitude end)) |> Enum.filter(fn altitude -> altitude == 0 end) |> length()
    peak_count = (map_as_list |> Enum.map(fn {_coord, {altitude, _steps}} -> altitude end)) |> Enum.filter(fn altitude -> altitude == 0 end) |> length()
    average_steps = (map_as_list |> Enum.map(fn {_coord, {_altitude, steps}} -> length(steps) end) |> Enum.sum()) / (state.max_col*state.max_row)
    IO.puts("#{trailhead_count} trailheads")
    IO.puts("#{peak_count} peaks")
    IO.puts("#{average_altitude} average altitude")
    IO.puts("#{average_steps} steps per point (average)")
    state
  end

  def find_trail_heads(%__MODULE__{} = state) do
    trail_heads = Enum.filter(get_coords(state), fn coord -> Map.get(state.map, coord) == 0 end)
    %{state| trail_heads: trail_heads}
  end
  def find_peaks(%__MODULE__{} = state) do
    peaks = Enum.filter(get_coords(state), fn coord -> Map.get(state.map, coord) == 9 end)
    %{state| peaks: peaks}
  end

  def find_trails(%__MODULE__{} = state) do
    # trails = Enum.reduce(state.trail_heads, [], fn coord, trails -> trails ++ find_trails_from(state, coord) end)
    # %{state| trails: trails}
    state
  end

  # def find_trails_from(state, coord) do
    # {_, steps} = Map.get(state.map, coord)
  # []
  # end

  def sum(%__MODULE__{} = state) do
    state
  end

  def part2(_input) do
  end
end
