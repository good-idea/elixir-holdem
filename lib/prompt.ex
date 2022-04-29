defmodule Prompt do
  def ask question, options do
    IO.puts("\nOptions:\n")
    Putser.print_lines(options)
    answer = IO.gets("\nYour move: ") |> String.trim_trailing

    case Enum.member?(options, answer) do
      true -> answer
      false ->
        IO.puts("'#{answer}' is not valid")
        ask question, options
    end
  end

  def ask question do
    IO.gets(question)
  end

end
