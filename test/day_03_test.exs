defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  test "part1" do
    input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    assert AdventOfCode.Day03.part1(input) == 161
  end

  test "part2" do
    input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    assert AdventOfCode.Day03.part2(input) == 48
  end
end
