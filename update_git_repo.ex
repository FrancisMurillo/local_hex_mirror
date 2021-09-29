{mix_map , []} = Code.eval_file("mix.lock")

Mix.start()

Mix.shell().cmd("rm -rf .git_repo/*")

mix_map
|> Enum.filter(fn
  # Filter out
  # entry = "elixir_nsq": {:git, "https://github.com/wistia/elixir_nsq", "sharev", [ref: "sharevused"]}
  {package, {:git, "https://github.com" <> _path, _rev, _opts}} -> true
  _ -> false
end)
|> Enum.map(fn {package, entry} -> {package, elem(entry, 1)} end)
|> Enum.sort_by(&elem(&1, 0))
|> Task.async_stream(fn {package, git_url} ->
  "https://github.com/" <> path = git_url

  # Normalize path ends with .git for bare repositories
  path = if(String.ends_with?(path, ".git"), do: path, else: "#{path}.git")

  Mix.shell().cmd("git clone --bare #{git_url} .git_repo/#{path}")
end, timeout: :infinity, max_concurrency: 3)
|> Stream.run()
