# update_local_repo.ex
{mix_map , []} = Code.eval_file("mix.lock")

# Enable mix commands programatically
Mix.start()

mix_map
|> Enum.map(fn {package, entry} ->
  # Every third entry of the tuple is the exact version
  # entry = {:hex, :decimal, "1.8.1", "omittedhash", [:mix], [], "hexpm"}
  {package, elem(entry, 2)}
end)
|> Enum.filter(fn {_package, version} ->
  # Optional, remove git packages since they do not have versions but revisions
  # version = {:git, "https://github.com/annkissam/rummage_ecto.git", "gitrev", [branch: "v2.0"]}
  case Version.parse(version) do
    {:ok, _} -> true
    :error -> false
  end
end)
# Optional, sort packages by name to get predicatable progress
|> Enum.sort_by(&elem(&1, 0))
# Optional, Task.async_stream is just to parallelize the process. Enum.each also works.
|> Task.async_stream(fn {package, version} ->
  # Run mix hex.package fetch for each package and store in the repository
  Mix.shell().cmd("mix hex.package fetch #{package} #{version} --output .hex_repo/tarballs/")
end, timeout: :infinity, max_concurrency: 3)
|> Stream.run()
