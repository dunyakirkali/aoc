defmodule AGCTest do
  use ExUnit.Case
  doctest AGC

  test "test" do
    res =
      AGC.new("priv/day2/input.txt")
      |> AGC.set(12, 2)
      |> AGC.run
    assert res == 3562624
  end
end
