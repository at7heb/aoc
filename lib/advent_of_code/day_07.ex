defmodule AdventOfCode.Day07 do
  defstruct text: [],
            hands: [],
            bets: [],
            hand_patterns: [],
            hand_ranks: [],
            ranked_hands_and_bets: [],
            part: 1

  def part1(input) do
    input
    |> new(1)
    |> dbg
    |> calculate_total()
    |> dbg
  end

  def calculate_total(%__MODULE__{} = state) do
    Enum.reduce(state.ranked_hands_and_bets, {0, 1}, fn {_hand, bet}, {total, order} ->
      {total + bet * order, order + 1}
    end)
  end

  def new(input, part) do
    # convert AKQJT to EDCBA so the who sequence can be treated as a hex (or base 15) number
    # for sorting to determine the hand strength!
    text =
      String.replace(input, "A", "E")
      |> String.replace("K", "D")
      |> String.replace("Q", "C")
      |> String.replace("J", "B")
      |> String.replace("T", "A")
      |> String.split("\n")

    pairs = Enum.map(text, fn line -> String.split(line, " ") end)
    hands = Enum.map(pairs, fn [hand, _bet] -> String.split(hand, "", trim: true) end)
    bets = Enum.map(pairs, fn [_hand, bet] -> String.to_integer(bet) end)

    hand_patterns =
      Enum.map(hands, fn hand ->
        Enum.frequencies(hand) |> Map.values() |> Enum.sort()
      end)

    hand_ranks =
      case part do
        1 ->
          Enum.map(hand_patterns, fn pat -> rank_for_hand_pattern(pat) end)

        2 ->
          jack_counts = Enum.map(hands, fn hand -> count_jacks(hand) end)

          Enum.map(Enum.zip(hand_patterns, jack_counts), fn {pat, n_jacks} ->
            rank_for_hand_pattern2(pat, n_jacks)
          end)

        _ ->
          {:error, "illegal part: #{part}"}
      end

    hand_ranks =
      Enum.map(hand_patterns, fn pat -> rank_for_hand_pattern(pat) end)

    hand_strength0 =
      Enum.zip(hand_ranks, hands)
      |> Enum.map(fn {rank, hand} ->
        ([rank] ++ hand) |> Enum.join("") |> String.to_integer(16)
      end)
      |> dbg

    to_sort = Enum.zip(hand_strength0, bets) |> dbg
    sorted = Enum.sort(to_sort, fn {a0, _b0}, {a1, _b1} -> a0 <= a1 end) |> dbg

    %__MODULE__{
      text: text,
      hands: hands,
      bets: bets,
      hand_patterns: hand_patterns,
      hand_ranks: hand_ranks,
      ranked_hands_and_bets: sorted,
      part: part
    }
    |> dbg
  end

  def rank_for_hand_pattern(pat) when is_list(pat) do
    pat_tuple = List.to_tuple(pat)

    case pat_tuple do
      {5} ->
        "7"

      {1, 4} ->
        "6"

      {2, 3} ->
        "5"

      {1, 1, 3} ->
        "4"

      {1, 2, 2} ->
        "3"

      {1, 1, 1, 2} ->
        "2"

      {1, 1, 1, 1, 1} ->
        "1"
    end
  end

  def part2(input) do
    input
    |> new(2)
    |> dbg
    |> calculate_total()
    |> dbg
  end

  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end
end
