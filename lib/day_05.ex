defmodule AdventOfCode.Day05 do
  def part1(input) do
    [map_str, lists_str] = String.split(input, "\n\n", trim: true)

    order_map = build_order_map(map_str)

    lists_str
    |> parse_and_process_lists(order_map)
    |> calculate_result()
  end

  defp build_order_map(map_str) do
    map_str
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [before, next] = String.split(line, "|", trim: true)
      Map.update(acc, next, MapSet.new([before]), &MapSet.put(&1, before))
    end)
  end

  defp parse_and_process_lists(lists_str, order_map) do
    lists_str
    |> String.split("\n", trim: true)
    |> Enum.map(&process_number_list(&1, order_map))
    |> Enum.filter(&(&1 != false))
  end

  defp process_number_list(line, order_map) do
    numbers = String.split(line, ",", trim: true)

    case check_numbers_validity(numbers, order_map) do
      false -> false
      _visited -> numbers
    end
  end

  defp check_numbers_validity(numbers, order_map) do
    numbers
    |> Enum.reduce_while(MapSet.new(), fn number, visited ->
      if MapSet.member?(visited, number) do
        {:halt, false}
      else
        {:cont, MapSet.union(visited, Map.get(order_map, number, MapSet.new()))}
      end
    end)
  end

  defp calculate_result(valid_lists) do
    valid_lists
    |> Enum.map(fn numbers ->
      middle_index = div(length(numbers), 2)
      Enum.at(numbers, middle_index)
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
