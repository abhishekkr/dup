defmodule DupTest do
  use ExUnit.Case
  doctest Dup

  test "greets the world" do
    assert Dup.hello() == :world
  end
end
