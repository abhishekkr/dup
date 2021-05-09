defmodule Dup.CLI do
  @default_path "."
  @worker_count Application.get_env(:dup, :worker_count, 2)

  @moduledoc """
  Handle cli parsing and dispatch to function using it.
  """

  def main(argv), do: parse_args(argv) |> process()

  @doc """
  `argv` can be -h or --help which returns :help

  otherwise it's a directory path(s)
  """
  def parse_args(argv) do
    {switches, args, _x} = OptionParser.parse(argv,
      switches: [help: :boolean, path: :string],
      aliases: [h: :help, p: :path]
    )
    do_parse_args(switches, args)
  end

  defp do_parse_args([help: true], _args), do: :help
  defp do_parse_args([], []), do: [@default_path]
  defp do_parse_args([], args), do: args
  defp do_parse_args(_switches, _args), do: :help

  def process(:help) do
    IO.puts("usage: dup dirpath [dirpath ..]")
  end
  def process(paths) do
    {:ok, _pathfinder} = Dup.PathFinder.start_link(paths)
    {:ok, _gatherer} = Dup.Gatherer.start_link([cli: self(), worker_count: @worker_count])
    receive do
      :done -> report_results()
    end
  end

  defp do_report_results([]), do: :done
  defp do_report_results([h|tail]) do
    Enum.join(h, " SAME-AS\n\t") |> IO.puts()
    IO.puts "-------------"
    do_report_results(tail)
  end
  defp report_results do
    Dup.Results.find_duplicates() |> do_report_results()
  end
end
