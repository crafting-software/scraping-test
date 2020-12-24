defmodule Scrape.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scrape.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "ingredients" do
    field(:name, :string)

    many_to_many(:products, Product, join_through: "product_ingredient")

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint([:name], message: "Ingredient already exists")
  end
end
