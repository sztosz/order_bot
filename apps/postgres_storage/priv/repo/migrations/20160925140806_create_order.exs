defmodule Storage.Repo.Migrations.AddOrder do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:orders) do
      add :closed, :boolean, null: false
      add :sent, :boolean, null: false

      timestamps
    end
  end
end
