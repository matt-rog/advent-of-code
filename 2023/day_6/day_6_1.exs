{:ok, input} = File.read("input.txt")

races = input |> String.split("\n")
  |> Enum.map(fn line -> String.split(line, "  ")
    |> Enum.filter(fn e -> e != "" and !String.contains?(e, "e:") end)
    |> Enum.map(fn s -> String.to_integer(String.trim(s)) end)
  end)
  |> Enum.zip()

product = races |> Enum.map(fn race ->
  # calc ways to beat races
  {time, distance} = race
  # find min and max holding time
  min_ht = Enum.reduce_while(1..time, 1, fn _ms, acc ->
    speed = acc
    time_to_move = time - speed
    moved_distance = speed * time_to_move
    if moved_distance > distance do
      {:halt, speed}
    else
      {:cont, acc + 1}
    end
  end)

  max_ht = Enum.reduce_while(time..0, time, fn _ms, acc ->
    speed = acc
    time_to_move = time - speed
    moved_distance = speed * time_to_move
    if moved_distance > distance do
      {:halt, speed}
    else
      {:cont, acc - 1}
    end
  end)

  max_ht - min_ht + 1

end)
  |> Enum.reduce(1, &(&1*&2))

IO.inspect(product)
