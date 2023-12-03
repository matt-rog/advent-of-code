{:ok, input} = File.read("input.txt")

abc = "abcdefghijklmnopqrstuvwxyz"

sum = input
  |> String.split("\n")
  |> Enum.map(fn line ->
      nums = line |> String.graphemes
        |> Enum.reject(fn char -> String.contains?(abc, char) end)
      a = nums |> Enum.at(0)
      b = nums |> Enum.at(-1)
      Enum.join([a, b], "") |> String.to_integer
    end)
  |> Enum.sum

IO.puts sum
