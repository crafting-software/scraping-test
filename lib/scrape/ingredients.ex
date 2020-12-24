defmodule Scrape.Ingredients do
  import Ecto.Query, warn: false
  alias Scrape.Repo
  alias Scrape.Ingredient

  def list_ingredients do
    Repo.all(Ingredient)
  end

  def get_ingredient_by_name(name) do
    from(
      i in Ingredient,
      where: i.name == ^name
    )
    |> Repo.one()
  end

  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  def get_ingredient_by_name(name) do
    from(
      i in Ingredient,
      where: i.name == ^name
    )
    |> Repo.one()
  end

  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  def change_ingredient(%Ingredient{} = ingredient) do
    Ingredient.changeset(ingredient, %{})
  end
end
