{:ok, input} = File.read("input.txt")

abc = "abcdefghijklmnopqrstuvwxyz"
abc_nums = %{"one" => "1", "two" => "2", "three" => "3",
  "four" => "4", "five" => "5", "six" => "6",
  "seven" => "7", "eight" => "8", "nine" => "9"}

sum = input
  |> String.split("\n")
  |> Enum.map(fn line ->
    # get indecies of abc_num locations, in map, then sort by first indices and apply those
      abc_nums_i = Enum.map(Map.keys(abc_nums), fn abc_nums_k ->
        index = case String.split(line, abc_nums_k, parts: 2) do
          [left, _] -> String.length(left)
          [_] -> nil
        end
        %{abc_nums_k => index}
      end)
      IO.inspect(line)
      # sort by indices
      abc_nums_i = Enum.reject(abc_nums_i, fn abc_nums_i_m ->
        Map.values(abc_nums_i_m) |> hd == nil
      end)
      # Used to arrange queues for processing numbers : outside->in
      abc_nums_i_sorted = abc_nums_i |> Enum.sort_by(fn map-> map |> Map.values() |> hd end)
      abc_nums_i = if length(abc_nums_i) == 0, do: [], else: [Enum.at(abc_nums_i_sorted, 0), Enum.at(abc_nums_i_sorted, -1)] |> Enum.reverse


      n_line = Enum.reduce(abc_nums_i, line, fn abc_num, acc ->
        {abc_num_k, _i} = abc_num |> Map.to_list() |> hd
        if String.contains?(acc, abc_num_k) do
          String.replace(acc, abc_num_k, abc_nums[abc_num_k])
        else
          acc
        end
      end)
      IO.inspect(n_line)
      nums = n_line
        |> String.graphemes # atp all word-nums should be digit-nums
        |> Enum.reject(fn char -> String.contains?(abc, char) end)
      a = nums |> Enum.at(0)
      b = nums |> Enum.at(-1)
      IO.inspect("#{a}<>#{b}")
      Enum.join([a, b], "") |> String.to_integer
    end)
  |> Enum.sum

IO.puts sum
