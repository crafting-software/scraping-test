defmodule Scrape.Repo.Migrations.CreateIngredientsTable do
  use Ecto.Migration

  def change do
    create table(:ingredients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text

      timestamps()
    end
  end
end
