defmodule Aoc.Day24 do
  @doc """
      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
      ...> Aoc.Day24.part1(inp)
      10
  """
  def part1(inp) do
    inp
    |> Stream.map(&parse_line/1)
    |> Stream.map(&path_to_coord/1)
    |> Enum.reduce(MapSet.new(), &flip/2)
    |> MapSet.size()
  end

  @doc """
      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
      ...> Aoc.Day24.part2(inp)
      2208
  """
  def part2(inp) do
    inp
    |> Enum.map(&parse_line/1)
    |> Enum.map(&path_to_coord/1)
    |> Enum.reduce(MapSet.new(), &flip/2)
    |> days(100)
    |> MapSet.size()
  end

  def flip(c, s), do: if c in s, do: MapSet.delete(s, c), else: MapSet.put(s, c)
  def flipped(c, s), do: c |> adjacent() |> Enum.count(&(&1 in s))

  def days(flipped, 0), do: flipped
  def days(flipped, n), do: flipped |> day() |> days(n - 1)

  def day(flipped) do
    flipped
    |> Enum.flat_map(&adjacent/1)
    |> MapSet.new()
    |> Enum.filter(
      &case {&1 in flipped, flipped(&1, flipped)} do
        {true, n} when n == 0 or n > 2 -> false
        {false, 2} -> true
        {flip?, _} -> flip?
      end
    )
    |> MapSet.new()
  end

  def adjacent({x, y, z}) do
    for nx <- (x - 1)..(x + 1),
        ny <- (y - 1)..(y + 1),
        nz <- (z - 1)..(z + 1),
        nx + ny + nz == 0,
        {nx, ny, nz} != {x, y, z} do
      {nx, ny, nz}
    end
  end

  def path_to_coord(path) do
    Enum.reduce(path, {0, 0, 0}, fn
      :e, {x, y, z} -> {x + 1, y - 1, z}
      :w, {x, y, z} -> {x - 1, y + 1, z}
      :ne, {x, y, z} -> {x + 1, y, z - 1}
      :nw, {x, y, z} -> {x, y + 1, z - 1}
      :se, {x, y, z} -> {x, y - 1, z + 1}
      :sw, {x, y, z} -> {x - 1, y, z + 1}
    end)
  end

  def parse_line(""), do: []
  def parse_line(<<"e", rest::binary>>), do: [:e | parse_line(rest)]
  def parse_line(<<"w", rest::binary>>), do: [:w | parse_line(rest)]
  def parse_line(<<"ne", rest::binary>>), do: [:ne | parse_line(rest)]
  def parse_line(<<"nw", rest::binary>>), do: [:nw | parse_line(rest)]
  def parse_line(<<"se", rest::binary>>), do: [:se | parse_line(rest)]
  def parse_line(<<"sw", rest::binary>>), do: [:sw | parse_line(rest)]

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
