{:ok, input} = File.read("input.txt")

parse_num_rgx = fn (nums, line) ->
  Enum.map(nums, fn num ->
    {i, l} = num |> hd
    String.slice(line, i, l)
  end)
end

cards = input |> String.split("\n")

sum = cards |> Enum.map(fn card ->
  nums = String.split(card, ": ") |> Enum.at(-1) |> String.split(" | ")
  winning_nums = Regex.scan(~r/\b\d+\b/, Enum.at(nums, 0), return: :index) |> parse_num_rgx.(Enum.at(nums, 0))
  local_nums = Regex.scan(~r/\b\d+\b/, Enum.at(nums, -1), return: :index) |> parse_num_rgx.(Enum.at(nums, -1))

  winning_local_nums = MapSet.intersection(MapSet.new(winning_nums), MapSet.new(local_nums)) |> MapSet.to_list
  if length(winning_local_nums) == 0, do: 0, else: :math.pow(2, (length(winning_local_nums)-1)) |> trunc

end)
  |> Enum.sum

IO.puts sum
