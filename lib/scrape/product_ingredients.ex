defmodule Scrape.ProductIngredients do
  import Ecto.Query, warn: false
  alias Scrape.Repo

  alias Scrape.ProductIngredient

  def add_product_ingredient(product_id, ingredient_id) do
    Repo.insert_all(
      ProductIngredient,
      [%{product_id: product_id, ingredient_id: ingredient_id}],
      on_conflict: :nothing
    )
  end
end
