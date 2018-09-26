defmodule SaverAdmin.Repo.Migrations.AddEbayId do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :ebayid, :string
    end
  end
end
