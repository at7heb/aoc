defmodule AdventOfCode.Day09 do
  defstruct input: "",
            file_map: %{},
            free_map: %{},
            free_sizes: %{},
            current_sector: 0,
            current_file: 0,
            current_free: 0,
            file_sectors: 0,
            free_sectors: 0,
            file_count: 0,
            free_count: 0,
            check_sum: -44

  def part1(input) do
    %__MODULE__{}
    |> parse(input)
    |> info()
    |> compact()
    |> checksum()
    |> dbg
  end

  def checksum(%__MODULE__{} = state) do
    checksum =
      Map.to_list(state.file_map)
      |> Enum.map(fn {file_id, file_sectors} -> file_id * Enum.sum(file_sectors) end)
      |> Enum.sum()

    %{state | check_sum: checksum}
  end

  def compact(%__MODULE__{} = state) do
    first_free_sector = -55

    %{
      state
      | current_file: state.file_count - 1,
        current_free: 0,
        current_sector: first_free_sector
    }
    |> compact1()
  end

  def compact1(%__MODULE__{} = state) do
    cond do
      # if there are no free sectors, we're done
      # test with part1("135")
      state.free_sectors == 0 -> state
      # if there are no more files to compact, we're done
      # test with part1("191")
      # test with part1("19")
      state.current_file <= 0 -> state
      true -> maybe_move_some_sectors(state) |> compact1()
    end
  end

  def maybe_move_some_sectors(state = %__MODULE__{}) do
    current_file = Map.get(state.file_map, state.current_file)
    current_free = Map.get(state.free_map, state.current_free)

    cond do
      current_free == [] -> handle_next_free(state)
      current_file == [] -> handle_next_file(state)
      Enum.max(current_file) < hd(current_free) -> handle_next_file(state)
      true -> move_a_sector(state)
    end
  end

  def move_a_sector(state = %__MODULE__{}) do
    [_last_file | restof_file] = Map.get(state.file_map, state.current_file) |> Enum.reverse()
    [first_free | restof_free] = Map.get(state.free_map, state.current_free)
    new_file = [first_free | restof_file] |> Enum.sort()
    new_file_map = Map.put(state.file_map, state.current_file, new_file)
    new_free_map = Map.put(state.free_map, state.current_free, restof_free)

    %{
      state
      | file_map: new_file_map,
        free_map: new_free_map,
        free_sectors: state.free_sectors - 1
    }
  end

  def handle_next_file(state = %__MODULE__{}) do
    %{state | current_file: state.current_file - 1}
  end

  def handle_next_free(state = %__MODULE__{}) do
    %{state | current_free: state.current_free + 1}
  end

  def info(state = %__MODULE__{}) do
    file_locations =
      for file_number <- 0..(state.file_count - 1), do: Map.get(state.file_map, file_number)

    free_locations =
      for free_number <- 0..(state.free_count - 1), do: Map.get(state.free_map, free_number)

    file_sectors = List.flatten(file_locations) |> length()
    free_sectors = List.flatten(free_locations) |> length()
    IO.puts("#{state.file_count} files using #{file_sectors} blocks")
    IO.puts("#{state.free_count} free spaces using #{free_sectors} blocks")
    %{state | file_sectors: file_sectors, free_sectors: free_sectors}
  end

  def parse(%__MODULE__{} = state, ""), do: state

  def parse(%__MODULE__{} = state, input) do
    %{state | input: input}
    |> parse()
  end

  def parse(%__MODULE__{} = state) do
    new_state =
      parse_file(state)
      |> parse_free()

    if String.length(state.input) == 0, do: new_state, else: parse(new_state)
  end

  def parse_file(%__MODULE__{} = state) do
    if String.length(state.input) == 0 do
      state
    else
      {length, sectors} = parse_head_of_input(state)

      if length == 0,
        do: IO.puts("----------------------- zero length file! -----------------------")

      %{
        state
        | current_sector: state.current_sector + length,
          file_map: Map.put(state.file_map, state.current_file, sectors),
          current_file: state.current_file + 1,
          file_count: state.file_count + 1,
          input: String.slice(state.input, 1, 999_999)
      }
    end
  end

  def parse_free(%__MODULE__{} = state) do
    if String.length(state.input) == 0 do
      state
    else
      {length, sectors} = parse_head_of_input(state)

      if length == 0 do
        IO.puts("---------------- zero length free ----------------; sectors: #{sectors}")
      end

      %{
        state
        | current_sector: state.current_sector + length,
          free_map: Map.put(state.free_map, state.current_free, sectors),
          current_free: state.current_free + 1,
          free_count: state.free_count + 1,
          input: String.slice(state.input, 1, 999_999)
      }
    end
  end

  def parse_head_of_input(%__MODULE__{} = state) do
    length = String.first(state.input) |> String.to_integer()

    sectors =
      if length > 0,
        do: state.current_sector..(state.current_sector + length - 1) |> Enum.to_list(),
        else: []

    {length, sectors}
  end

  def part2(input) do
    %__MODULE__{}
    |> parse(input)
    |> info()
    |> compact2()
    |> checksum()
    |> dbg
  end

  def compact2(%__MODULE__{} = state) do
    state
    |> set_up_for_compaction()
    |> compact2bis()
  end

  def compact2bis(%__MODULE__{} = state) do
    Enum.reduce_while(state.file_count-1..0\\-1, {:error, state}, fn file_index, {_, state} -> compact3(state, file_index) end)
  end

  def set_up_for_compaction(%__MODULE__{} = state) do
    %{
      state
      | current_file: state.file_count - 1,
        current_free: 0,
        current_sector: -55
    }
    |> fill_free_sizes()
  end

  def find_first_free_as_big_as(%__MODULE__{} = state, size) do
    no_good = {:error, "not big enough"}

    Enum.reduce_while(0..(state.free_count - 1), no_good, fn index, _acc ->
      if Map.get(state.free_sizes, index) >= size,
        do: {:halt, {:ok, index}},
        else: {:cont, no_good}
    end)
  end

  def fill_free_sizes(%__MODULE__{} = state) do
    free_sizes =
      Map.to_list(state.free_map)
      |> Enum.reduce(%{}, fn {id, blocks}, map -> Map.put(map, id, length(blocks)) end)

    %{state | free_sizes: free_sizes}
  end
end
