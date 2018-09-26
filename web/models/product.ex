defmodule SaverAdmin.Product do
  use SaverAdmin.Web, :model

  schema "products" do
    field :name, :string
    field :url, :string
    field :ebayid, :string
    field :stock, :boolean, default: false
    field :price, :float

    timestamps
  end

  @required_fields ~w(name url stock price)
  @optional_fields ~w(ebayid)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
