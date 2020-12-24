defmodule Scrape.Repo do
  use Ecto.Repo,
    otp_app: :scrape,
    adapter: Ecto.Adapters.Postgres

  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, "postgres://gluten_free:gluten_free@localhost:5432/scrape_dev")}
  end
end
