defmodule Storage.Repo.Migrations.CreateOrderItem do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :article, :string
      add :quantity, :integer
      add :measure_unit, :string

      add :deleted_at, :datetime

      timestamps
    end
  end
end
