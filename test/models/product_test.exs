defmodule SaverAdmin.ProductTest do
  use SaverAdmin.ModelCase

  alias SaverAdmin.Product

  @valid_attrs %{name: "some content", price: "120.5", stock: true, url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
