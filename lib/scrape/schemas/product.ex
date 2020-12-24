defmodule Scrape.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scrape.Ingredient

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "products" do
    field(:name, :string)
    field(:brand_name, :string)

    many_to_many(:ingredients, Ingredient, join_through: "product_ingredient")

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :brand_name
    ])
    |> validate_required([:name])
  end
end
