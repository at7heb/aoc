defmodule AdventOfCode.Day10Search do
  # each element of current_path is {coordinate, steps}
  # add new segments at beginning; trailhead is last element
  defstruct current_path: [],
            map: %{},
            trail_head: {},
            # map from trailhead to MapSet with peaks
            peaks_from_trail_heads: %{}

  def new(map) do
    %{%__MODULE__{} | map: map}
  end

  def new_trail_head(%__MODULE__{} = search, {_, _} = trail_head) do
    {_altitude, steps_from_here} = Map.get(search.map, trail_head)
    %{search | current_path: [{trail_head, steps_from_here}], trail_head: trail_head}
  end

  # go to the first step
  def advance(%__MODULE__{} = search) do
    {"advance", search.current_path}
    {_altitude, steps_from_here} = hd(search.current_path)

    cond do
      is_at_peak?(search) ->
        {:at_peak, search}

      steps_from_here == [] &&
          tl(search.current_path) == [] ->
        {:no_hope, search}

      steps_from_here == [] ->
        {:at_end, search}

      true ->
        new_current_place = hd(steps_from_here)
        {_altitude, new_steps} = Map.get(search.map, new_current_place)
        new_path = [{new_current_place, new_steps} | search.current_path]
        new_search = %{search | current_path: new_path}
        {:ok, new_search}
    end
  end

  def is_at_peak?(%__MODULE__{} = search) do
    {current_location, steps} = hd(search.current_path)
    {altitude, _steps} = Map.get(search.map, current_location)
    {"at peak?", current_location, altitude}

    cond do
      altitude == 9 && steps == [] ->
        search.current_path
        true

      altitude == 9 && steps != [] ->
        raise ArgumentError, message: "Peak has Paths"

      true ->
        false
    end
  end

  # need to keep searching. This must work if on a mountain, in which case must
  # remove the current node and also remove the first "next_steps".
  # Following a path always ends with next_steps == [].
  # this is _only_ called when next_steps == [].
  def do_alternative(%__MODULE__{} = search) do
    {"do alternative", search.current_path}
    [{_current_place, next_steps} | head_of_path] = search.current_path
    if next_steps != [], do: raise(ArgumentError, "last location has next steps")
    # backtrack one step, and then remove the first step in that
    [{current_place, next_steps} | head_of_path] = head_of_path
    [_ | next_steps] = next_steps
    new_current_path = [{current_place, next_steps} | head_of_path]
    %{search | current_path: new_current_path}
  end

  def add_current_peak(%__MODULE__{} = search, 1) do
    current_peaks = Map.get(search.peaks_from_trail_heads, search.trail_head, MapSet.new())
    {peak, _} = hd(search.current_path)
    peaks = MapSet.put(current_peaks, peak)

    %{
      search
      | peaks_from_trail_heads: Map.put(search.peaks_from_trail_heads, search.trail_head, peaks)
    }
  end

  def add_current_peak(%__MODULE__{} = search, 2) do
    current_peaks = Map.get(search.peaks_from_trail_heads, search.trail_head, [])
    {peak, _} = hd(search.current_path)
    peaks = MapSet.put(current_peaks, peak)

    %{
      search
      | peaks_from_trail_heads: Map.put(search.peaks_from_trail_heads, search.trail_head, peaks)
    }
  end
end
