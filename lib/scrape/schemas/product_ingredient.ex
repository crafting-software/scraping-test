defmodule Scrape.ProductIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scrape.Product
  alias Scrape.Ingredient

  @primary_key false
  schema "product_ingredient" do
    belongs_to(:product, Product, type: :binary_id)
    belongs_to(:ingredient, Ingredient, type: :binary_id)
  end

  def changeset(product_ingredient, attrs) do
    product_ingredient
    |> cast(attrs, [:product_id, :ingredient_id])
    |> validate_required([:product_id, :ingredient_id])
  end
end
