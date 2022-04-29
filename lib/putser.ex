defmodule Putser do
  def clear do
    {:ok,height} = :io.rows
    for _ <- 1..height do
      IO.puts("")
    end
  end

  def print_lines lines do
    for line <- lines do
      IO.puts(line)
    end
  end
end
