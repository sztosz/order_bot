defmodule PostgresStorage.Order do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias PostgresStorage.Repo
  alias PostgresStorage.OrderItem

  schema "orders" do
    field :closed, :boolean, null: false
    field :sent, :boolean, null: false

    has_many :order_items, OrderItem

    timestamps
  end

  def changeset(order, params \\ %{}) do
    order
    |> Changeset.cast(params, [:closed, :sent])
    |> Changeset.validate_required([:closed, :sent])
  end

  def opened do
    case Repo.get_by(__MODULE__, closed: false) do
      nil ->
        new
      order ->
        {:ok, order}
    end
  end

  defp new do
    __MODULE__
    |> changeset(closed: false, sent: false)
    |> Repo.insert
  end
end
