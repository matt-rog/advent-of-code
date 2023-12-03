{:ok, input} = File.read("input.txt")

find_min = fn (pulls, term) -> pulls
  |> Enum.filter(fn pull -> String.contains?(pull, term) end)
  |> Enum.map(fn pull -> pull |> String.split(" ")
  |> hd |> String.to_integer end) |> Enum.max
end

game_num_sum = input |> String.split("\n")
  |> Enum.map(fn game ->
    pulls = game |> String.split(": ") |> tl |> hd |> String.split( ~r/; |, /, trim: true)
    (pulls |> find_min.("red")) * (pulls |> find_min.("blue")) * (pulls |> find_min.("green"))

  end)
  |> Enum.sum

IO.puts game_num_sum
