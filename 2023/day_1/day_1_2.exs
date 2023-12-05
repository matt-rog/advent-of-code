{:ok, input} = File.read("input.txt")

abc = "abcdefghijklmnopqrstuvwxyz"
abc_nums = %{"one" => "1", "two" => "2", "three" => "3",
  "four" => "4", "five" => "5", "six" => "6",
  "seven" => "7", "eight" => "8", "nine" => "9"}


# Used to arrange queues for processing numbers : outside->in
interleave_maps = fn {map1, map2} ->
  [map1, map2]
end

alternate_lists = fn (list1, list2) ->
  Enum.concat(Enum.zip(list1, list2) |> Enum.flat_map(&interleave_maps.(&1)))
end

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
      abc_nums_i_sorted = abc_nums_i |> Enum.sort_by(fn map-> map |> Map.values() |> hd end)
      abc_nums_i_r_sorted = abc_nums_i_sorted |> Enum.reverse
      abc_nums_i = alternate_lists.(abc_nums_i_sorted, abc_nums_i_r_sorted)
      abc_nums_i = Enum.take(abc_nums_i, div(length(abc_nums_i), 2))
      IO.inspect(abc_nums_i)


      n_line = Enum.reduce(abc_nums_i, line, fn abc_num, acc ->
        {abc_num_k, _i} = abc_num
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
