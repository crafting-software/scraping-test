defmodule Scrape.Repo.Migrations.CreateProductsTable do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add :name, :string
      add :brand_name, :string


      timestamps()
    end
  end
end
