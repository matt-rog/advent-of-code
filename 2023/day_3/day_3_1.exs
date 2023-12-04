{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n")
lines_len = length(lines)

sum = lines |> Enum.with_index
  |> Enum.map(fn line_m ->

    {line, l_i} = line_m
    nums = Regex.scan(~r/\b\d+\b/, line, return: :index)

    line_count = nums |> Enum.map(fn num ->

      {n_i, n_l} = num |> hd
      num_s = String.slice(line, n_i, n_l)

      {j,k} = (if (n_i == 0), do: {0,n_l}, else: {n_i-1,n_i+n_l})
      visit_here = %{
        l_i => j..k,
        (l_i-1) => j..k, # line index => range of string positions to check
        (l_i+1) => j..k}
      adj_status = Map.keys(visit_here) |> Enum.map(fn line_i ->
        line_adj_status = if line_i < 0 || line_i >= lines_len do
          false
        else
          substr = Enum.at(lines, line_i)
            |> String.slice(Range.new(Enum.at(visit_here[line_i], 0), Enum.at(visit_here[line_i], -1))) # get substring
          Regex.match?(~r/[^0-9.]/, substr)
        end
        line_adj_status
      end)
      |> Enum.member?(true)

      if adj_status, do: String.to_integer(num_s), else: 0
    end)
    line_count
      |> Enum.sum
  end)
  |> Enum.sum
IO.inspect sum
