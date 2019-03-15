defmodule EdrApi.Umbrella.Mixfile do
  use Mix.Project

  @version "0.0.1"
  def project do
    [
      version: @version,
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:distillery, "~> 2.0", runtime: false, override: true},
      {:excoveralls, "~> 0.9.1", only: [:dev, :test]},
      {:credo, "~> 0.9.3", only: [:dev, :test]},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:git_ops, "~> 0.6.0", only: [:dev]}
    ]
  end
end
