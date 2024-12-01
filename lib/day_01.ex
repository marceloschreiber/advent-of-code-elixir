defmodule AdventOfCode.Day01 do
  @doc """
  Process the input to calculate the sum of the differences between pairs of numbers.
  """
  def part1(input) do
    {first_numbers, second_numbers} = extract_numbers(input)

    Enum.zip(Enum.sort(first_numbers), Enum.sort(second_numbers))
    |> Enum.map(fn {first, second} -> abs(second - first) end)
    |> Enum.sum()
  end

  defp extract_numbers(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], []}, fn line, {first_numbers, second_numbers} ->
      [_, first, second] = Regex.run(~r/(\d+)\s+(\d+)/, line)

      {
        [String.to_integer(first) | first_numbers],
        [String.to_integer(second) | second_numbers]
      }
    end)
  end
end
