defmodule AdventOfCode.Day04 do
  defstruct card: 0, winners: MapSet.new(), elves: MapSet.new(), winnings: 0, count: 1

  def new(text_line) do
    # parse lines like "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
    [card_id, rest] = String.split(text_line, ":")
    [winners, elves] = String.split(rest, "|")
    [[index]] = Regex.scan(~r/\d+/, card_id)
    winning_numbers = String.split(winners) |> Enum.map(&String.to_integer(&1)) |> MapSet.new()
    elves_numbers = String.split(elves) |> Enum.map(&String.to_integer(&1)) |> MapSet.new()
    %__MODULE__{card: String.to_integer(index), winners: winning_numbers, elves: elves_numbers}
  end

  def part1(input) do
    state = make_state(input)

    calculate_winnings(state)
  end

  def calculate_winnings(state) do
    Enum.map(state, fn card ->
      elves_winners = MapSet.intersection(card.winners, card.elves)
      %{card | winnings: payoff_of(MapSet.size(elves_winners))}
    end)
    |> Enum.reduce(0, fn card, sum -> sum + card.winnings end)
  end

  def payoff_of(0), do: 0
  def payoff_of(n), do: 2 ** (n - 1)

  def make_state(input), do: input |> String.split("\n") |> Enum.map(&new(String.trim(&1)))

  def part2(input) do
    String.split(input, "\n")

    _state =
      make_state(input)
      |> win_more_cards([])
      |> calculate_number_of_cards()
  end

  def win_more_cards([], examined_cards), do: Enum.reverse(examined_cards)

  def win_more_cards([a_card | rest_of_cards] = _state, examined_cards) do
    {a_card.card, length(rest_of_cards), length(examined_cards)} |> IO.inspect()
    number_to_change = MapSet.intersection(a_card.winners, a_card.elves) |> MapSet.size()
    number_to_add = a_card.count

    {changed_cards, unchanged_cards} =
      duplicate_cards(rest_of_cards, [], number_to_add, number_to_change)

    new_cards =
      (changed_cards ++ unchanged_cards)
      |> List.flatten()
      |> Enum.sort(fn a, b -> a.card <= b.card end)

    win_more_cards(new_cards, [a_card | examined_cards])
  end

  def duplicate_cards(pending_cards, done_cards, _number_to_add, 0),
    do: {done_cards, pending_cards}

  def duplicate_cards([this_card | rest_to_do], done_cards, number_to_add, number_to_change) do
    changed_card = %{this_card | count: number_to_add + this_card.count}
    duplicate_cards(rest_to_do, [changed_card | done_cards], number_to_add, number_to_change - 1)
  end

  def calculate_number_of_cards(cards) do
    Enum.reduce(cards, 0, fn card, accum -> accum + card.count end)
  end

  def get(file_fragment) do
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    File.read!(file_name) |> String.trim()
  end
end
