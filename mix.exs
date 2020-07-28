defmodule Islands.Coord.MixProject do
  use Mix.Project

  def project do
    [
      app: :islands_coord,
      version: "0.1.11",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      name: "Islands Coord",
      source_url: source_url(),
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp source_url do
    "https://github.com/RaymondLoranger/islands_coord"
  end

  defp description do
    """
    Creates a coordinate struct for the Game of Islands.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "config/persist*.exs"],
      maintainers: ["Raymond Loranger"],
      licenses: ["MIT"],
      links: %{"GitHub" => source_url()}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_tasks,
       github: "RaymondLoranger/mix_tasks", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:persist_config, "~> 0.4", runtime: false},
      {:poison, "~> 3.1"},
      {:jason, "~> 1.0"}
    ]
  end
end
