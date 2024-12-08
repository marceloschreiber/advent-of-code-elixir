defmodule PermutationGenerator do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_permutations(elements, slots) do
    cache_key = {elements, slots}

    case Agent.get(__MODULE__, &Map.get(&1, cache_key)) do
      nil ->
        result = generate_permutations(elements, slots)
        Agent.update(__MODULE__, &Map.put(&1, cache_key, result))
        result

      cached_result ->
        cached_result
    end
  end

  defp generate_permutations(elements, slots) do
    for p <- List.duplicate(elements, slots), reduce: [[]] do
      acc -> for x <- acc, y <- p, do: [y | x]
    end
  end
end

defmodule AdventOfCode.Day07 do
  def part1(input) do
    PermutationGenerator.start_link()

    calibrations = parse_input(input)

    calibrations
    |> Task.async_stream(fn calibration -> calibrate(calibration, ["+", "*"]) end)
    |> Enum.reduce(0, fn {:ok, result}, acc -> acc + result end)
  end

  def part2(input) do
    PermutationGenerator.start_link()

    calibrations = parse_input(input)

    calibrations
    |> Task.async_stream(fn calibration -> calibrate(calibration, ["+", "*", "||"]) end)
    |> Enum.reduce(0, fn {:ok, result}, acc -> acc + result end)
  end

  defp calibrate({result, numbers}, operators) do
    permutations = PermutationGenerator.get_permutations(operators, length(numbers) - 1)

    if Enum.any?(permutations, fn permutation ->
         calculate_result(numbers, permutation) == result
       end) do
      result
    else
      0
    end
  end

  defp calculate_result(numbers, permutation) do
    numbers
    |> Enum.zip([nil | permutation])
    |> Enum.reduce({nil, nil}, fn
      {num, nil}, {nil, nil} ->
        {num, nil}

      {num, operator}, {acc, nil} ->
        {acc, {operator, num}}

      {num, operator}, {acc, {prev_op, prev_num}} ->
        result =
          case prev_op do
            "+" -> acc + prev_num
            "*" -> acc * prev_num
            "||" -> String.to_integer("#{acc}#{prev_num}")
          end

        {result, {operator, num}}
    end)
    |> then(fn
      {acc, nil} -> acc
      {acc, {"+", num}} -> acc + num
      {acc, {"*", num}} -> acc * num
      {acc, {"||", num}} -> String.to_integer("#{acc}#{num}")
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [result | numbers] =
        line
        |> String.split([":", " "], trim: true)
        |> Enum.map(&String.to_integer/1)

      {result, numbers}
    end)
  end
end
