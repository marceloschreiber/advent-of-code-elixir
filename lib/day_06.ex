defmodule AdventOfCode.Day06 do
  @step_map %{
    up: [0, -1],
    down: [0, 1],
    left: [-1, 0],
    right: [1, 0]
  }

  @direction_change %{
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }

  def part1(input) do
    {map, guard} = parse_input(input)
    MapSet.size(walk(map, guard))
  end

  def part2(input) do
    {map, guard} = parse_input(input)
    guard_path = walk(map, guard)
    possible_positions = MapSet.delete(guard_path, guard)

    Enum.reduce(possible_positions, 0, fn pos, acc ->
      if looped?(Map.put(map, pos, "#"), guard, MapSet.new()) do
        acc + 1
      else
        acc
      end
    end)
  end

  defp parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    map =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} -> {{x, y}, char} end)
      end)
      |> Map.new()

    guard_coordinate = find_position(map, "^")
    {map, {guard_coordinate, :up}}
  end

  defp find_position(map, value) do
    {coordinate, _value} = Enum.find(map, fn {_coordinate, char} -> char === value end)
    coordinate
  end

  defp walk(map, guard) do
    walk(map, guard, MapSet.new())
  end

  defp walk(map, {guard_coordinate, _direction} = guard, visited)
       when is_map_key(map, guard_coordinate) do
    next_position = next_position(map, guard)
    walk(map, next_position, MapSet.put(visited, guard_coordinate))
  end

  defp walk(_map, _guard, visited), do: visited

  defp looped?(map, {guard_coordinate, _direction} = guard, visited) do
    cond do
      Map.get(map, guard_coordinate) == nil -> false
      MapSet.member?(visited, guard) -> true
      true -> looped?(map, next_position(map, guard), MapSet.put(visited, guard))
    end
  end

  defp next_position(map, {{x, y}, direction}) do
    [x_inc, y_inc] = Map.get(@step_map, direction)
    next_pos = {x + x_inc, y + y_inc}

    if Map.get(map, next_pos) == "#" do
      next_direction = Map.get(@direction_change, direction)
      next_position(map, {{x, y}, next_direction})
    else
      {next_pos, direction}
    end
  end
end
