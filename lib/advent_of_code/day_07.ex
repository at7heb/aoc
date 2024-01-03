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
    # |> dbg
    |> calculate_total()

    # |> dbg
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

    hands =
      if part == 1 do
        Enum.map(pairs, fn [hand, _bet] -> String.split(hand, "", trim: true) end)
      else
        Enum.map(pairs, fn [hand, _bet] ->
          String.replace(hand, "B", "1") |> String.split("", trim: true)
        end)
      end

    bets = Enum.map(pairs, fn [_hand, bet] -> String.to_integer(bet) end)

    hand_patterns =
      Enum.map(hands, fn hand ->
        Enum.frequencies(hand) |> Map.values() |> Enum.sort() |> List.to_tuple()
      end)

    hand_ranks =
      case part do
        1 ->
          Enum.map(hand_patterns, fn pat_tuple -> rank_for_hand_pattern(pat_tuple) end)

        2 ->
          jack_counts = Enum.map(hands, fn hand -> count_jacks(hand) end)
          # |> dbg
          {hand_patterns, jack_counts}

          Enum.map(Enum.zip(hand_patterns, jack_counts), fn {pat_tuple, n_jacks} ->
            rank_for_hand_pattern2(pat_tuple, n_jacks)
          end)

        _ ->
          {:error, "illegal part: #{part}"}
      end

    hand_strength0 =
      Enum.zip(hand_ranks, hands)
      |> Enum.map(fn {rank, hand} ->
        ([rank] ++ hand) |> Enum.join("") |> dbg |> String.to_integer(16)
      end)

    # |> dbg

    to_sort =
      Enum.zip(hand_strength0, bets)
      |> dbg

    sorted = Enum.sort(to_sort, fn {a0, _b0}, {a1, _b1} -> a0 <= a1 end)

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

  def rank_for_hand_pattern(pat_tuple) when is_tuple(pat_tuple) do
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

  def rank_for_hand_pattern2(pat_tuple, n_jacks) do
    case {pat_tuple, n_jacks} do
      {_, 0} -> rank_for_hand_pattern(pat_tuple)
      {{5}, 5} -> rank_for_hand_pattern(pat_tuple)
      {{5}, _} -> {:error, "rank2 #{pat_tuple} #{n_jacks}"}
      {{1, 4}, 1} -> rank_for_hand_pattern({5})
      {{1, 4}, 4} -> rank_for_hand_pattern({5})
      {{1, 4}, _} -> {:error, "rank2 #{pat_tuple} #{n_jacks}"}
      {{2, 3}, 2} -> rank_for_hand_pattern({5})
      {{2, 3}, 3} -> rank_for_hand_pattern({5})
      {{2, 3}, _} -> {:error, "rank2 #{pat_tuple} #{n_jacks}"}
      {{1, 1, 3}, 1} -> rank_for_hand_pattern({1, 4})
      {{1, 1, 3}, 3} -> rank_for_hand_pattern({1, 4})
      {{1, 1, 3}, _} -> {:error, "rank2 #{pat_tuple} #{n_jacks}"}
      {{1, 2, 2}, 1} -> rank_for_hand_pattern({2, 3})
      {{1, 2, 2}, 2} -> rank_for_hand_pattern({1, 4})
      {{1, 1, 2}, _} -> {:error, "rank2 #{pat_tuple} #{n_jacks}"}
      {{1, 1, 1, 2}, 1} -> rank_for_hand_pattern({1, 1, 3})
      {{1, 1, 1, 2}, 2} -> rank_for_hand_pattern({1, 1, 3})
      {{1, 1, 1, 2}, _} -> {:error, "rank2 #{pat_tuple} #{n_jacks}"}
      {{1, 1, 1, 1, 1}, 1} -> rank_for_hand_pattern({1, 1, 1, 2})
      {{1, 1, 1, 1, 1}, _} -> {:error, "rank2 #{pat_tuple} #{n_jacks}"}
      _ -> {:error, "fell through in case #{pat_tuple} #{n_jacks}"}
    end
  end

  def count_jacks(card) do
    card |> Enum.filter(fn a -> a == "1" end) |> length()
  end

  def part2(input) do
    input
    |> new(2)
    # |> dbg
    |> calculate_total()

    # |> dbg
  end

  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end
end
