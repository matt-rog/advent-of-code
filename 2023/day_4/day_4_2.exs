{:ok, input} = File.read("input.txt")

defmodule AOCDay4 do

  def count_played_cards(cards, curr_card_i) do
    {_curr_i, wins} = Enum.at(cards, curr_card_i)

    total = if wins > 0 do
      next_play_range = if wins == 1, do: [curr_card_i+1], else: Range.to_list((curr_card_i+1)..(curr_card_i+wins))
      t = Enum.map(next_play_range, fn card_i ->
        count_played_cards(cards, card_i)
      end) |> Enum.sum
      t + 1
    else
      1
    end
    total
  end


  def count_wins(card) do
    nums = String.split(card, ": ") |> Enum.at(-1) |> String.split(" | ")
    winning_nums = Regex.scan(~r/\b\d+\b/, Enum.at(nums, 0), return: :index) |> parse_num_rgx(Enum.at(nums, 0))
    local_nums = Regex.scan(~r/\b\d+\b/, Enum.at(nums, -1), return: :index) |> parse_num_rgx(Enum.at(nums, -1))

    winning_local_nums = MapSet.intersection(MapSet.new(winning_nums), MapSet.new(local_nums)) |> MapSet.to_list
    length(winning_local_nums)
  end


  def parse_num_rgx(nums, line) do
    Enum.map(nums, fn num ->
      {i, l} = num |> hd
      String.slice(line, i, l)
    end)
  end
end

cards = input |> String.split("\n")

wins_per_card = cards |> Enum.with_index |> Enum.map(fn card_m ->
  {card, i} = card_m
  {i, AOCDay4.count_wins(card)}
end)

total = cards |> Enum.with_index
  |> Enum.map(fn card_m ->
  {_card, i} = card_m
    IO.puts "MAIN LOOP RUNNING: #{i}"
    t = AOCDay4.count_played_cards(wins_per_card, i)
    IO.puts "\t#{t}"
    t
  end)
  |> Enum.sum
IO.inspect total
