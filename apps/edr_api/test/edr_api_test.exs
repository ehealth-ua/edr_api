defmodule EdrApiTest do
  use ExUnit.Case
  doctest EdrApi

  test "greets the world" do
    assert EdrApi.hello() == :world
  end
end
