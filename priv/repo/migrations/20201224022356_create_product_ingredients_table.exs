defmodule Scrape.Repo.Migrations.CreateProductIngredientsTable do
  use Ecto.Migration

  def change do
    create table(:product_ingredient, primary_key: false) do
      add(:product_id, references(:products, type: :uuid, on_delete: :delete_all))
      add(:ingredient_id, references(:ingredients, type: :uuid, on_delete: :delete_all))
    end
  end
end
