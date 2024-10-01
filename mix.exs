defmodule RenewexIconset.MixProject do
  use Mix.Project

  @source_url "https://github.com/laszlokorte/renewex_iconset"
  @version "0.2.0"

  def project do
    [
      app: :renewex_iconset,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: @source_url,
      homepage_url: @source_url,
      docs: [
        # The main page in the docs
        extras: ["README.md"],
        source_url: @source_url,
        logo: "guides/images/logo-square.png"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, "~> 0.34.0", only: :dev, runtime: false}]
  end

  defp description() do
    "A set of reponsive vector icons for Renew drawings and a converter to generate correspondonding SVG paths."
  end

  defp package() do
    [
      name: "renewex_iconset",
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/laszlokorte/renewex_iconset",
        "Renew" => "http://www.renew.de"
      }
    ]
  end
end
