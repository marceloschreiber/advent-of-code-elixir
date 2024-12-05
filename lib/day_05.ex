defmodule AdventOfCode.Day05 do
  def part1(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.filter(&sorted?(rules, &1))
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  def part2(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.reject(&sorted?(rules, &1))
    |> Enum.map(fn update ->
      update
      |> Enum.sort(&greater?(rules, &1, &2))
      |> middle()
    end)
    |> Enum.sum()
  end

  defp middle(list) do
    Enum.at(list, div(length(list), 2))
  end

  defp parse_input(input) do
    [rules_raw, updates_raw] = String.split(input, "\n\n")

    rules =
      rules_raw
      |> String.split(["|", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.group_by(fn [a, _] -> a end, fn [_, b] -> b end)

    updates =
      updates_raw
      |> String.split("\n", trim: true)
      |> Enum.map(fn report ->
        report
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  defp greater?(rules, greater, lesser) do
    lesser in Map.get(rules, greater, [])
  end

  defp sorted?(rules, report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [greater, lesser] -> greater?(rules, greater, lesser) end)
  end
end
