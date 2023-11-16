defmodule Influitive.MixProject do
  use Mix.Project

  @source_url "https://github.com/Health-Union/influitive_ex"

  def project do
    [
      app: :influitive,
      version: "0.1.2",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.4"},
      {:bypass, "~> 2.1", only: :test}
    ]
  end

  defp package do
    [
      description: "A basic Elixir wrapper for the Influitive API.",
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Hassan Akbar", "Steve DeGele"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: [
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      formatters: ["html"]
    ]
  end
end
