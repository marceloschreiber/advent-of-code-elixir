defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  test "part one example" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert AdventOfCode.Day01.part1(input) == 11
  end

  test "part two example" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert AdventOfCode.Day01.part2(input) == 31
  end
end
