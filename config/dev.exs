use Mix.Config

# Configure your database
config :scrape, Scrape.Repo,
  username: "gluten_free",
  password: "gluten_free",
  database: "scrape_dev",
  hostname: "localhost",
  port: "5432",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
