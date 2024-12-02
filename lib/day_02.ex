defmodule AdventOfCode.Day02 do
  @max_distance 3

  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&check_report_safety/1)
    |> Enum.filter(&(&1 == true))
    |> length()
  end

  @spec part2(binary()) :: integer()
  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn report ->
      # Original report is safe, or removing one level makes it safe
      check_report_safety(report) ||
        report
        |> Enum.with_index()
        |> Enum.any?(fn {_level, idx} ->
          modified_report = List.delete_at(report, idx)
          check_report_safety(modified_report)
        end)
    end)
    |> Enum.filter(&(&1 == true))
    |> length()
  end

  @spec check_report_safety(list(integer())) :: boolean()
  defp check_report_safety(report) when length(report) < 2, do: true

  defp check_report_safety(report) do
    [first, second | _] = report
    direction = if first > second, do: :descending, else: :ascending

    Enum.chunk_every(report, 2, 1, :discard)
    |> Enum.all?(fn [a, b] -> check_sequence(a, b, direction) end)
  end

  @spec check_sequence(integer(), integer(), :ascending | :descending) :: boolean()
  defp check_sequence(a, b, :ascending), do: a < b && b - a <= @max_distance
  defp check_sequence(a, b, :descending), do: b < a && a - b <= @max_distance

  @spec parse_input(String.t()) :: list(list(integer()))
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn reports -> Enum.map(reports, &String.to_integer/1) end)
  end
end
