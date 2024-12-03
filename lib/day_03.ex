defmodule AdventOfCode.Day03 do
  @type status :: :enabled | :disabled
  @type operation :: {integer(), integer()} | :do | :dont

  @operation_regex ~r/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/

  @spec part1(String.t()) :: integer()
  def part1(input) do
    ~r/mul\((\d+),(\d+)\)/
    |> Regex.scan(input)
    |> Enum.map(fn [_, first, second] -> String.to_integer(first) * String.to_integer(second) end)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    @operation_regex
    |> Regex.scan(input)
    |> Enum.map(&parse_operation/1)
    |> Enum.reduce({0, :enabled}, &process_operation/2)
    |> elem(0)
  end

  @spec parse_operation([String.t()]) :: operation()
  defp parse_operation([_full_match, first, second]),
    do: {String.to_integer(first), String.to_integer(second)}

  defp parse_operation(["don't()"]), do: :dont
  defp parse_operation(["do()"]), do: :do

  @spec process_operation(operation(), {integer(), status()}) :: {integer(), status()}
  defp process_operation({first, second}, {current, :enabled}),
    do: {current + first * second, :enabled}

  defp process_operation(:dont, {current, _status}),
    do: {current, :disabled}

  defp process_operation(:do, {current, _status}),
    do: {current, :enabled}

  defp process_operation(_element, acc),
    do: acc
end
