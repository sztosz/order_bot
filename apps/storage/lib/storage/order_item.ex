defmodule Storage.OrderItem do
  use Ecto.Schema

  schema "order_items" do
    field :name, :string
    field :quantity, :integer
    field :measure_unit, :string

    field :deleted_at, Ecto.DateTime

    timestamps
  end

  def changeset(order_item, params \\ %{}) do
    order_item
    |> Ecto.Changeset.cast(params, [:name, :quantity, :measure_unit])
    |> Ecto.Changeset.validate_required([:name, :quantity, :measure_unit])
  end
end
