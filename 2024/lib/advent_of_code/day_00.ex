defmodule AdventOfCode.Day00 do
  def get(file_fragment) do
    # |> dbg
    file_name = Path.join([".", "games", "day-" <> file_fragment <> ".txt"])
    # |> dbg
    File.read!(file_name) |> String.trim()
  end

  def get_test(file_fragment), do: get(file_fragment <> "-test")
end
