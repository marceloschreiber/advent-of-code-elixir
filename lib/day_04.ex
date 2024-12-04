defmodule AdventOfCode.Day04 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> number_of_patterns(String.split("XMAS", "", trim: true))
  end

  @spec part1(String.t()) :: integer()
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> number_of_xmas()
  end

  def number_of_xmas(matrix) do
    Enum.reduce(1..(length(matrix) - 1), 0, fn i, acc ->
      acc +
        Enum.reduce(1..(length(hd(matrix)) - 1), 0, fn j, acc_inner ->
          words_in_diagonal =
            MapSet.new([
              get_letter(matrix, {i - 1, j - 1}) <>
                get_letter(matrix, {i, j}) <>
                get_letter(matrix, {i + 1, j + 1}),
              get_letter(matrix, {i - 1, j + 1}) <>
                get_letter(matrix, {i, j}) <>
                get_letter(matrix, {i + 1, j - 1})
            ])

          if MapSet.subset?(words_in_diagonal, MapSet.new(["MAS", "SAM"])) do
            acc_inner + 1
          else
            acc_inner
          end
        end)
    end)
  end

  def get_letter(matrix, {i, j}) do
    if i >= 0 && j >= 0 do
      Enum.at(Enum.at(matrix, i, []), j, "")
    else
      ""
    end
  end

  defp number_of_patterns(matrix, pattern) do
    directions = [
      {1, 0},
      {-1, 0},
      {0, 1},
      {0, -1},
      {1, 1},
      {-1, -1},
      {-1, 1},
      {1, -1}
    ]

    Enum.reduce(0..(length(matrix) - 1), 0, fn i, acc ->
      acc +
        Enum.reduce(0..(length(hd(matrix)) - 1), 0, fn j, acc_inner ->
          acc_inner +
            Enum.reduce(directions, 0, fn direction, acc_inner_inner ->
              acc_inner_inner + search_in_direction(matrix, pattern, {i, j}, direction)
            end)
        end)
    end)
  end

  defp search_in_direction(_matrix, [], _coordinate, _direction), do: 1

  defp search_in_direction(matrix, [current_letter | rest], {i, j}, direction) do
    if i >= 0 && j >= 0 && Enum.at(Enum.at(matrix, i, []), j) == current_letter do
      search_in_direction(matrix, rest, next_position(i, j, direction), direction)
    else
      0
    end
  end

  defp next_position(i, j, {di, dj}), do: {i + di, j + dj}
end
