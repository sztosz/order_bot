defmodule Storage.Repo.Migrations.CreateOrderItem do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :article, :string, null: false
      add :quantity, :integer, null: false
      add :measure_unit, :string, null: false

      add :order_id, references(:orders), null: false

      timestamps
    end
  end
end
