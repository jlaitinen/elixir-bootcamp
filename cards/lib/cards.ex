defmodule Cards do
    @moduledoc """
        Provides methods for creating and handling a deck
    """

    @doc """
        Returns a deck of cards
    """
    def create_deck do
        values = ["Ace", "Two", "Three", "Four", "Five"]
        suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

        for suit <- suits, value <- values do
                "#{value} of #{suit}"
        end
    end

    @doc """
        Determines wheter a dec contains a given acard

    ## Examples

        iex> deck = Cards.create_deck
        iex> Cards.contains?(deck, "Ace of Spades")
        true

    """
    def contains?(deck, card) do
        Enum.member?(deck, card)
    end

    defp new_shuffled do
        create_deck
        |> List.flatten
        |> Enum.shuffle
    end
    
    def save(deck, filename) do
        File.write(filename, :erlang.term_to_binary(deck))
    end

    def load(filename) do
        case File.read(filename) do
            {:ok, binary} -> :erlang.binary_to_term binary
            {:error, reason} -> "reason #{reason}"
        end
    end

    def create_hand(hand_size) do
        new_shuffled
        |> Enum.split hand_size
    end
end
