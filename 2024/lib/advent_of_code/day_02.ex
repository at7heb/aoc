defmodule AdventOfCode.Day02 do
  def part1(input) do
    %{input: input}
    |> parse_lines()
    |> make_diffs()
    |> only_positive_1_to_3()
    |> only_negative_1_to_3()
    |> sum_only_lengths()
  end

  def parse_lines(%{input: input} = state) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ") |> Enum.map(&String.to_integer(&1)) end)
    |> update_state(:parsed_lines, state)
  end

  def make_diffs(%{parsed_lines: lines} = state) do
    lines
    |> Enum.map(fn line ->
      Enum.reduce(tl(line), {[], hd(line)}, fn next_in_line, {acc_list, prev_in_line} ->
        {[next_in_line - prev_in_line | acc_list], next_in_line}
      end)
    end)
    |> Enum.map(&elem(&1, 0))
    |> update_state(:diffed_lines, state)
  end

  def only_positive_1_to_3(%{diffed_lines: lines} = state) do
    lines
    |> Enum.filter(&Enum.all?(&1, fn v -> v > 0 and v <= 3 end))
    |> update_state(:only_positive_1_to_3, state)
  end

  def only_negative_1_to_3(%{diffed_lines: lines} = state) do
    lines
    |> Enum.filter(&Enum.all?(&1, fn v -> v < 0 and v >= -3 end))
    |> update_state(:only_negative_1_to_3, state)
  end

  def sum_only_lengths(%{only_positive_1_to_3: op, only_negative_1_to_3: on} = _state) do
    length(op) + length(on)
  end

  def update_state(value, key, %{} = state) when is_atom(key) do
    Map.put(state, key, value)
  end

  def convert_to_game_records(text) do
    text_list = String.split(text, "\n")

    Enum.reduce(text_list, %{}, fn record_text, games ->
      convert_one_text_record(record_text, games)
    end)
  end

  def convert_one_text_record(text, games) do
    game_index = get_game_index(text)
    record = get_record_items(text)
    Map.put(games, game_index, record)
  end

  def get_game_index(text) do
    [head, _rest] = String.split(text, ": ")
    String.replace(head, "Game ", "") |> String.to_integer()
  end

  def get_record_items(text) do
    [_head, all_draws] = String.split(text, ": ")

    String.split(all_draws, "; ")
    |> Enum.map(fn each_draw -> create_draws_map(each_draw) end)

    # |> dbg
  end

  def create_draws_map(draws) do
    group_record = String.split(draws, ", ") |> Enum.map(&String.trim(&1))

    Enum.reduce(group_record, %{red: 0, green: 0, blue: 0}, fn one_color, counts ->
      update_map_for_count(counts, one_color)
    end)
  end

  def update_map_for_count(count_map, color_count) do
    pat = ~r/^[0-9]+/
    [digits] = Regex.run(pat, color_count, capture: :first)
    count = String.to_integer(digits)

    cond do
      String.contains?(color_count, "red") -> Map.put(count_map, :red, count)
      String.contains?(color_count, "green") -> Map.put(count_map, :green, count)
      String.contains?(color_count, "blue") -> Map.put(count_map, :blue, count)
    end
  end

  def calculate_game_index_sums(games_map) do
    Enum.reduce(games_map, 0, fn one_game, acc -> check_one_game(one_game, acc) end)
  end

  def check_one_game(game, accum) do
    # game |> dbg
    {game_index, draw_list} = game
    okay = Enum.all?(draw_list, &all_in_bounds(&1))
    if okay, do: accum + game_index, else: accum
  end

  def all_in_bounds(map) do
    # 12 red cubes, 13 green cubes, and 14 blue cubes
    rlim = 12
    glim = 13
    blim = 14
    map.red <= rlim and map.green <= glim and map.blue <= blim
  end

  def calculate_game_powers(games_map) do
    Enum.map(games_map, fn {_index, one_game} -> one_game_power(one_game) end)
  end

  def one_game_power(one_game) do
    # one_game |> dbg
    # |> dbg
    rmax = get_max(one_game, :red)
    # |> dbg
    gmax = get_max(one_game, :green)
    # |> dbg
    bmax = get_max(one_game, :blue)
    rmax * gmax * bmax
  end

  def get_max(game, color) do
    Enum.map(game, fn draw -> Map.get(draw, color) end)
    |> Enum.max()
  end

  def part2(input) do
    input
    |> convert_to_game_records()
    |> calculate_game_powers()
    |> Enum.sum()
  end
end
