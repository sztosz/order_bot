defmodule Storage.Repo.Migrations.CreateOrderItem do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :name, :string
      add :quantity, :integer
      add :measure_unit, :string

      add :deleted_at, :datetime

      timestamps
    end
  end
end
