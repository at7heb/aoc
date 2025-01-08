defmodule AdventOfCode.Day12 do
  defstruct layout: %{},
            regions: %{},
            borders: %{},
            areas: %{},
            current_region_places: [],
            current_region_ndx: -1,
            # current_region_plant: "_",
            current_row: 0,
            current_col: 0,
            rc_count: 0,
            continue: false,
            call_count: 0

  @day "12"
  @first {1, 1}

  def part1(input) do
    state =
      %__MODULE__{}
      |> setup(input)
      |> find_regions()
      |> find_borders()

    state |> answer()
  end

  def find_borders(%__MODULE__{} = state) do
    {area_map, border_map} =
      for region_ndx <- 0..(map_size(state.regions) - 1) do
        region = Map.get(state.regions, region_ndx)
        area = length(region)
        border = Enum.reduce(region, 0, fn coord, sum -> sum + borders(state.layout, coord) end)
        {region_ndx, area, border}
      end
      |> Enum.filter(fn {_ndx, area, _border} -> area != [] end)
      |> Enum.reduce({%{}, %{}}, fn {region_ndx, area, border}, {area_map, border_map} ->
        {Map.put(area_map, region_ndx, area), Map.put(border_map, region_ndx, border)}
      end)

    %{state | areas: area_map, borders: border_map}
  end

  def borders(%{} = layout, {r0, c0} = coord) do
    plant = Map.get(layout, coord)

    for {r_delta, c_delta} <- [{-1, 0}, {1, 0}, {0, -1}, {0, 1}] do
      r1 = r0 + r_delta
      c1 = c0 + c_delta
      if plant == Map.get(layout, {r1, c1}), do: 0, else: 1
    end
    |> Enum.sum()
  end

  def setup(%__MODULE__{} = state, input) when is_binary(input) do
    input_list = String.split(input, "\n", trim: true)
    setup(state, input_list)
  end

  def setup(%__MODULE__{} = state, input_list) when is_list(input_list) do
    rc_count = length(input_list)
    col_count = String.length(hd(input_list))
    if rc_count != col_count, do: raise(ArgumentError, message: "Input Not Square")

    layout =
      for r <- 0..(rc_count + 1), c <- 0..(rc_count + 1) do
        cond do
          r == 0 -> {{r, c}, "@"}
          r == rc_count + 1 -> {{r, c}, "@"}
          c == 0 -> {{r, c}, "@"}
          c == rc_count + 1 -> {{r, c}, "@"}
          true -> {{r, c}, Enum.at(input_list, r - 1) |> String.at(c - 1)}
        end
      end
      |> Enum.reduce(%{}, fn {coord, val}, map -> Map.put(map, coord, val) end)

    %{
      state
      | layout: layout,
        current_region_ndx: 0,
        current_region_places: [@first],
        # current_region_plant: Map.get(layout, @first),
        current_row: 1,
        current_col: 2,
        rc_count: rc_count,
        continue: true
    }
  end

  def find_regions(%__MODULE__{continue: false} = state), do: state

  def find_regions(%__MODULE__{} = state) do
    state = %{state | call_count: state.call_count + 1}

    {state.rc_count, state.current_row, state.current_col, state.continue, state.call_count}

    # if state.call_count > 1000, do: raise(ArgumentError, "call count")

    cond do
      state.current_col > state.rc_count ->
        new_state = finalize_region(state)
        %{new_state | current_col: 1, current_row: state.current_row + 1}

      state.current_row > state.rc_count ->
        %{state | continue: false}

      true ->
        %{find_region_match(state) | current_col: state.current_col + 1}
    end
    |> find_regions()
  end

  def finalize_region(%__MODULE__{current_region_ndx: -1} = state), do: state

  def finalize_region(%__MODULE__{} = state) do
    # regions: %{},
    # current_region_places: [],
    # current_region_ndx: 0,
    # current_region_plant: "_",
    # plant = "_"
    saved_region = Map.get(state.regions, state.current_region_ndx, [])
    new_region = (saved_region ++ state.current_region_places) |> Enum.uniq()
    new_regions = Map.put(state.regions, state.current_region_ndx, new_region)
    %{state | regions: new_regions, current_region_ndx: -1, current_region_places: []}
  end

  def find_region_match(%__MODULE__{} = state) do
    this = Map.get(state.layout, {state.current_row, state.current_col})
    left_of_this = Map.get(state.layout, {state.current_row, state.current_col - 1})
    above_this = Map.get(state.layout, {state.current_row - 1, state.current_col})

    cond do
      this == left_of_this and this == above_this -> add_to_left_and_above(state)
      this == left_of_this -> add_to_left(state)
      this == above_this -> finalize_region(state) |> add_to_above()
      true -> finalize_region(state) |> start_new_region()
    end
  end

  def start_new_region(%__MODULE__{} = state) do
    %{
      state
      | current_region_places: [{state.current_row, state.current_col}],
        current_region_ndx: map_size(state.regions)
    }
  end

  def add_to_above(%__MODULE__{} = state) do
    if state.current_region_ndx != -1, do: raise(ArgumentError, "add_to_above: open region")

    %{
      state
      | current_region_places: [
          {state.current_row, state.current_col} | state.current_region_places
        ],
        current_region_ndx: find_region_index(state, {state.current_row - 1, state.current_col})
    }
  end

  def add_to_left(%__MODULE__{} = state) do
    if state.current_region_ndx == -1, do: raise(ArgumentError, "add_to_left: closed region")

    %{
      state
      | current_region_places: [
          {state.current_row, state.current_col} | state.current_region_places
        ]
    }
  end

  def add_to_left_and_above(%__MODULE__{} = state) do
    if state.current_region_ndx == -1,
      do: raise(ArgumentError, "add_to_left_and_above: closed region")

    new_state =
      if state.current_region_ndx !=
           find_region_index(state, {state.current_row - 1, state.current_col}),
         do: merge_regions(state),
         else: state

    %{
      new_state
      | current_region_places: [
          {state.current_row, state.current_col} | state.current_region_places
        ]
    }
  end

  def merge_regions(%__MODULE__{} = state) do
    region_above_ndx = find_region_index(state, {state.current_row - 1, state.current_col})

    if region_above_ndx == state.current_region_ndx,
      do: raise(ArgumentError, "Merging same reason!")

    above_region_places = Map.get(state.regions, region_above_ndx, [{:up}])

    new_current_region =
      (Map.get(state.regions, state.current_region_ndx, []) ++
         state.current_region_places ++
         above_region_places)
      |> Enum.uniq()

    new_regions =
      Map.put(state.regions, region_above_ndx, [])
      |> Map.put(state.current_region_ndx, new_current_region)

    new_current_region_places = []
    %{state | regions: new_regions, current_region_places: new_current_region_places}
    # now update state for
  end

  def find_region_index(%__MODULE__{} = state, coord) do
    rv =
      Enum.reduce_while(state.regions, -1, fn {index, region}, _acc ->
        if coord in region, do: {:halt, index}, else: {:cont, -1}
      end)

    if rv == -1, do: raise(ArgumentError, "no region for #{coord}"), else: rv
  end

  def answer(%__MODULE__{} = state) do
    for key <- Map.keys(state.areas) do
      Map.get(state.areas, key, :a) * Map.get(state.borders, key, :b)
    end
    |> Enum.sum()
  end

  def part2(_args) do
  end

  def test1a(), do: part1(AdventOfCode.Day00.get_test(@day, 1))
  def test1b(), do: part1(AdventOfCode.Day00.get_test(@day, 2))
  def test1c(), do: part1(AdventOfCode.Day00.get_test(@day, 3))
  def full1(), do: part1(AdventOfCode.Day00.get(@day))
end
