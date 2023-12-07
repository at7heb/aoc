defmodule AdventOfCode.Day05 do
  defstruct seeds: [],
            seed_soil: [],
            soil_fertilizer: [],
            fertilizer_water: [],
            water_light: [],
            light_temperature: [],
            temperature_humidity: [],
            humidity_location: [],
            inhalt: []

  def part1(input) do
    state = parse(%__MODULE__{}, input) |> make_seed_stream_1()
    locations = Stream.map(state.seeds, fn seed -> find_location(seed, state) end)
    Enum.min(locations)
  end

  def find_location(seed, %__MODULE{} = state) do
    if rem(seed, 5_000_000) == 0, do: dbg({"periodic", seed, :os.system_time(:seconds)})

    seed
    |> map_with(:seed_soil, state)
    |> map_with(:soil_fertilizer, state)
    |> map_with(:fertilizer_water, state)
    |> map_with(:water_light, state)
    |> map_with(:light_temperature, state)
    |> map_with(:temperature_humidity, state)
    |> map_with(:humidity_location, state)
  end

  def map_with(value, map, state) when is_integer(value) do
    params = Map.get(state, map)
    transformed = Enum.map(params, fn param -> map_value_through_param(value, param) end)

    if Enum.any?(transformed) do
      Enum.filter(transformed, fn val -> val != nil end) |> hd
    else
      value
    end
  end

  def map_value_through_param(val, [dest_start, source_start, count] = _param) do
    # {val, dest_start, source_start, count} |> dbg

    if(val >= source_start and val < source_start + count) do
      dest_start + (val - source_start)
    else
      nil
    end
  end

  def parse(%__MODULE__{} = state, text) do
    parts = String.split(text, "\n\n")

    %{state | inhalt: parts}
    |> grab_seeds()
    |> grab_maps()
  end

  def grab_seeds(%__MODULE__{} = state) do
    [seeds_line | maps] = state.inhalt
    # {seeds_line, maps} |> dbg
    [_ | [seed_numbers]] = String.split(seeds_line, ": ")

    seed_list =
      String.split(seed_numbers, " ") |> Enum.map(fn number -> String.to_integer(number) end)

    %{state | seeds: seed_list, inhalt: maps}
  end

  def grab_maps(%__MODULE__{inhalt: []} = state), do: state

  def grab_maps(%__MODULE__{inhalt: [first | rest]} = state) do
    [type | [maps]] = String.split(first, ":\n")

    map_lists =
      String.split(maps, "\n")
      |> Enum.map(fn one_map ->
        String.split(one_map, " ") |> Enum.map(fn one_param -> String.to_integer(one_param) end)
      end)

    new_state =
      cond do
        String.starts_with?(type, "seed") -> %{state | seed_soil: map_lists}
        String.starts_with?(type, "soil") -> %{state | soil_fertilizer: map_lists}
        String.starts_with?(type, "fertilizer") -> %{state | fertilizer_water: map_lists}
        String.starts_with?(type, "water") -> %{state | water_light: map_lists}
        String.starts_with?(type, "light") -> %{state | light_temperature: map_lists}
        String.starts_with?(type, "temperature") -> %{state | temperature_humidity: map_lists}
        String.starts_with?(type, "humidity") -> %{state | humidity_location: map_lists}
        true -> {:error, "Unrecognized map type"}
      end

    grab_maps(%{new_state | inhalt: rest})
  end

  def make_seed_stream_1(%__MODULE__{} = state) do
    new_seeds = Enum.map(state.seeds, fn seed -> seed..seed end)
    %{state | seeds: Stream.concat(new_seeds)}
  end

  def make_seed_stream_2(%__MODULE__{} = state) do
    new_seeds =
      Enum.chunk_every(state.seeds, 2)
      |> Enum.map(fn [start, count] -> start..(start + count - 1) end)

    %{state | seeds: Stream.concat(new_seeds)}
  end

  # full sees
  # seeds: 1848591090 462385043 2611025720 154883670 1508373603 11536371 3692308424 16905163 1203540561 280364121 3755585679 337861951 93589727 738327409 3421539474 257441906 3119409201 243224070 50985980 7961058

  def part2(input) do
    state = parse(%__MODULE__{}, input) |> make_seed_stream_2()
    locations = Stream.map(state.seeds, fn seed -> find_location(seed, state) end)
    Enum.min(locations)
  end

  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end
end
