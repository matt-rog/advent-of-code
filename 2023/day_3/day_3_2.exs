{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n")
lines_len = length(lines)

sum = lines |> Enum.with_index
  |> Enum.map(fn line_m ->

    {line, l_i} = line_m
    stars = Regex.scan(~r/\*/, line, return: :index)

    line_gear_ratios = stars |> Enum.map(fn star ->

      {s_i, s_l} = star |> hd

      {j,k} = (if (s_i == 0), do: {0,s_l}, else: {s_i-1,s_i+s_l})
      visit_here = %{
        l_i => j..k,
        (l_i-1) => j..k, # line index => range of string positions to check
        (l_i+1) => j..k}
      maybe_gear_nums = Map.keys(visit_here) |> Enum.map(fn line_i ->
        nums = if line_i < 0 || line_i >= lines_len do
          []
        else
          # Find num locations, check if they're in range
          curr_line = Enum.at(lines, line_i)
          nums = Regex.scan(~r/\b\d+\b/, curr_line, return: :index)
          min_i = Enum.at(visit_here[line_i], 0)
          max_i = Enum.at(visit_here[line_i], -1)
          nums = Enum.reject(nums, fn num ->
            {n_i, n_l} = num |> hd
            ((n_i+n_l-1) < min_i) or (n_i > max_i)
          end)
            |> Enum.map(fn num_o ->
              {n_i, n_l} = num_o |> hd
              String.slice(curr_line, n_i, n_l) |> String.to_integer
            end)
          nums
        end
        nums
      end)

      maybe_gear_nums = maybe_gear_nums |> Enum.reject(fn list -> length(list) == 0 end) |> Enum.flat_map(&(&1))
      product = maybe_gear_nums |> Enum.reduce(1, &(&1*&2))

      if length(maybe_gear_nums) == 2, do: product, else: 0
    end)
    line_gear_ratios
      |> Enum.sum
  end)
  |> Enum.sum

IO.inspect sum
