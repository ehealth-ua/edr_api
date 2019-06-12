defmodule EdrApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :edr_api,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8.1",
      compilers: Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EdrApi.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kube_rpc, "~> 0.3.0"},
      {:confex, "~> 3.4"},
      {:httpoison, "~> 1.2"},
      {:jason, "~> 1.1"},
      {:confex_config_provider, "~> 0.1.0"},
      {:ehealth_logger, git: "https://github.com/edenlabllc/ehealth_logger.git"},
      {:mox, "~> 0.4.0", only: :test},
      {:ex_machina, "~> 2.2", only: :test}
    ]
  end
end
