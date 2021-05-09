defmodule Dup.MixProject do
  use Mix.Project

  def project do
    [
      app: :dup,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      escript: escript_config(),

      ## ex_doc config
      name: "Dup",
      source_url: "https://github.com/abhishekkr/dup",
      homepage_url: "https://github.com/abhishekkr/dup",
      docs: [
        main: "Dup", ## main page in docs
        logo: "./dup.png",
        extras: ["README.md"]
      ],

      ## excoveralls config
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :vasuki],
      mod: {Dup.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:vasuki, "~> 0.1.1"},
      {:excoveralls, "~> 0.14.0", only: :test},  ## test coverage
      {:ex_doc, "~> 0.24.2", only: :dev, runtime: false},  ## load only in dev mode
    ]
  end

  defp escript_config do
    [main_module: Dup.CLI]
  end
end
