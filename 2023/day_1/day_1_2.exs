{:ok, input} = File.read("input.txt")

abc = "abcdefghijklmnopqrstuvwxyz"
abc_nums = %{"one" => "1", "two" => "2", "three" => "3",
  "four" => "4", "five" => "5", "six" => "6",
  "seven" => "7", "eight" => "8", "nine" => "9"}

sum = input
  |> String.split("\n")
  |> Enum.map(fn line ->
    # get indecies of abc_num locations, in map, then sort by first indeces and apply those
      abc_nums_i = Enum.map(Map.keys(abc_nums), fn abc_nums_k ->
        index = case String.split(line, abc_nums_k, parts: 2) do
          [left, _] -> String.length(left)
          [_] -> nil
        end
        %{abc_nums_k => index}
      end)
      # sort by indices
      abc_nums_i = abc_nums_i |> Enum.sort_by(fn map-> map |> Map.values() |> hd end)

      n_line = Enum.reduce(abc_nums_i, line, fn abc_num, acc ->
        {abc_num_k, _i} = abc_num |> Map.to_list |> List.to_tuple |> elem(0)
        if String.contains?(acc, abc_num_k) do
          String.replace(acc, abc_num_k, abc_nums[abc_num_k])
        else
          acc
        end
      end)
      nums = n_line
        |> String.graphemes # atp all snums should be nums
        |> Enum.reject(fn char -> String.contains?(abc, char) end)
      a = nums |> Enum.at(0)
      b = nums |> Enum.at(-1)
      Enum.join([a, b], "") |> String.to_integer
    end)
  |> Enum.sum

IO.puts sum
