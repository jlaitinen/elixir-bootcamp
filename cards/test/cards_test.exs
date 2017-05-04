defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "creates right length hand" do
    {hand, rest} = Cards.create_hand 5
    assert (Enum.count hand) === 5
    assert (Enum.count rest) === 15
  end
end
