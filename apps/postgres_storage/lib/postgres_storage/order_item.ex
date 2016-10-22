defmodule PostgresStorage.OrderItem do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias PostgresStorage.Repo
  alias PostgresStorage.Order

  import Ecto.Query

  schema "order_items" do
    field :article, :string
    field :quantity, :integer
    field :measure_unit, :string

    belongs_to :order, Order

    timestamps
  end

  def changeset(order_item, params \\ %{}) do
    order_item
    |> Changeset.cast(params, [:article, :quantity, :measure_unit])
    |> Changeset.validate_required([:article, :quantity, :measure_unit])
  end

  def get_by_id(id) do
    case OrderItem.get(id) do
      nil ->
        {:error, "Not found"}
      order ->
        {:ok, order}
    end
  end

  def get_by_article(article) do
    query = from oi in from_opened_order,
              where: oi.article == ^article
    case Repo.one(query) do
      nil ->
        {:error, "Not found"}
      order_item ->
        {:ok, order_item}
    end
  end

  def from_opened_order do
    from oi in __MODULE__,
      join: o in Order, on: oi.order_id == o.id,
      where: o.closed == false
  end

  def from_order(order) when is_integer(order) do
    from oi in __MODULE__,
      join: o in Order, on: oi.order_id == o.id,
      where: o.id == ^order
  end
end
