defmodule AdventOfCode.Day06 do
  defstruct times: [], distances: [], counts: []

  # if more than 9999 races this will fail!!

  def part1(input) do
    %__MODULE__{}
    |> parse(input)
    |> solve_each_race()
    |> determine_answer()
  end

  def parse(%__MODULE__{} = state, input) do
    [time_line | distance_line] = input |> String.split("\n")
    {time_line, distance_line} |> dbg

    times =
      time_line
      |> String.split(":")
      |> Enum.slice(1..1)
      |> hd()
      |> String.split()
      |> Enum.map(fn time -> String.to_integer(time) end)

    distances =
      distance_line
      |> hd()
      |> String.split(":")
      |> Enum.slice(1..1)
      |> hd()
      |> String.split()
      |> Enum.map(fn time -> String.to_integer(time) end)

    %{state | times: times, distances: distances}
  end

  def solve_each_race(%__MODULE__{} = state) do
    time_dist = Enum.zip(state.times, state.distances)
    counts = Enum.map(time_dist, fn {t, d} -> possibilities(t, d) end)
    %{state | counts: counts}
  end

  def possibilities(time, distance) do
    discriminant = time * time - 4 * distance

    if discriminant < 0 do
      raise "Impossible time #{time} and distance #{distance} and discriminant #{discriminant}"
    end

    firstf = (time - discriminant ** 0.5) / 2 + 0.00000000001
    first = firstf |> Float.ceil() |> trunc()
    secondf = (time + discriminant ** 0.5) / 2 - 0.00000000001
    second = secondf |> Float.floor() |> trunc()
    answer = second - first + 1
    {time, distance, firstf, first, secondf, second, answer} |> dbg()
    answer
  end

  def determine_answer(%__MODULE__{} = state) do
    Enum.product(state.counts)
  end

  def part2(input) do
    %__MODULE__{}
    |> parse2(input)
    |> solve_each_race()
    |> determine_answer()
  end

  def parse2(%__MODULE__{} = state, input) do
    [time_line | distance_line] = input |> String.replace(" ", "") |> String.split("\n")
    {time_line, distance_line} |> dbg

    time =
      time_line
      |> String.split(":")
      |> Enum.slice(1..1)
      |> hd()
      |> String.to_integer()

    distance =
      distance_line
      |> hd()
      |> String.split(":")
      |> Enum.slice(1..1)
      |> hd()
      |> String.to_integer()

    %{state | times: [time], distances: [distance]}
  end

  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end
end
