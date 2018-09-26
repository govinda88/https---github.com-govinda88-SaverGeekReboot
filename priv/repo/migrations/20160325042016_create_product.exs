defmodule SaverAdmin.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :url, :string
      add :stock, :boolean, default: false
      add :price, :float

      timestamps
    end

  end
end
