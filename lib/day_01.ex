defmodule AdventOfCode.Day01 do
  @moduledoc """
  Solution for Advent of Code Day 1
  """
  @type number_list :: {list(integer()), list(integer())}

  @doc """
  Process the input to calculate the sum of the differences between pairs of numbers.

  ## Examples
  ```
  iex> AdventOfCode.Day01.part1("2 6\\n3 10") # => 5
  ```
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    {first_numbers, second_numbers} = extract_numbers(input)

    Enum.zip(Enum.sort(first_numbers), Enum.sort(second_numbers))
    |> Enum.map(fn {first, second} -> abs(second - first) end)
    |> Enum.sum()
  end

  @doc """
  Process the input to calculate the sum of the products based on the frequency of the numbers.

  ## Examples
  ```
  iex> AdventOfCode.Day01.part2("2 6\\n2 2") # => 4
  ```
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    {first_numbers, second_numbers} = extract_numbers(input)

    frequencies = Util.frequencies(second_numbers)

    first_numbers
    |> Enum.map(fn number -> number * Map.get(frequencies, number, 0) end)
    |> Enum.sum()
  end

  @spec extract_numbers(String.t()) :: number_list()
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
