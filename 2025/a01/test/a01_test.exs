defmodule A01Test do
  use ExUnit.Case
  doctest A01

  test "greets the world" do
    assert A01.hello() == :world
  end
end
