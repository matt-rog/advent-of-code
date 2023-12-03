{:ok, input} = File.read("input.txt")

map = %{"red" => 12, "green" => 13, "blue" => 14}

game_num_sum = input |> String.split("\n")
  |> Enum.map(fn game ->
    round_status = game |> String.split(": ") |> tl |> hd |> String.split("; ")
      |> Enum.map(fn round ->
        pull_status = round |> String.split(", ") # pulls
          |> Enum.map(fn pull ->
            pull = pull |> String.split(" ")
            if (hd(pull) |> String.to_integer) > Map.get(map, (pull |> tl |> hd)), do: false, else: true
          end)
        if Enum.member?(pull_status, false), do: false, else: true
      end)
    if not Enum.member?(round_status, false), do: game |> String.split(": ") |> hd |> String.slice(5..-1) |> String.to_integer, else: 0
  end)
  |> Enum.sum

IO.puts game_num_sum
