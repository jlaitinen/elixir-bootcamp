defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input 
    |> hash_string
    |> pick_color
  end

  @doc """
    Hashes string with md5 and then does a list of them

    ## Examples

      iex> Identicon.hash_string("asdf")
      [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]

  """
  def hash_string(input) do 
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(input) do
    %Identicon.Image{hex: hex_list} = input
    color = Enum.take(hex_list, 3)
    %Identicon.Image{hex: hex_list, color: color}
  end
end
