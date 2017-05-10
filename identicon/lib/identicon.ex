defmodule Identicon do
  require Integer
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input 
    |> hash_string
    |> pick_color
    |> build_grid
    |> build_graph
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
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

  def pick_color(%Identicon.Image{hex: [r,g,b | _tail]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  def build_grid(%Identicon.Image{hex: hex_list} = image) do 
    grid = 
      hex_list
      |> Enum.chunk(3)
      |> Enum.map(&mirror/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def build_graph(%Identicon.Image{grid: grid} = image) do
    vals = Enum.filter(grid, fn({code, _}) -> rem(code, 2) == 0 end) 
    %Identicon.Image{image | graph: vals}
  end

  def build_pixel_map(%Identicon.Image{graph: graph} = image) do 
    map = Enum.map graph, fn({_, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = rem(index, 5) * 50
      top = {horizontal, vertical}
      bottom = {horizontal + 50, vertical + 50}
      {top, bottom}  
    end

    %Identicon.Image{ image | pixel_map: map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :edg.create(250, 250)
    fill = :edg.color(color)

    Enum.each pixel_map, fn({start, stop}) -> 
      :edg.filledRectangle(image, start, stop, fill)
    end
    
    :egd.render(image)
  end

  def save_image(image, name) do
    File.write("#{name}.png", image)
  end
end
