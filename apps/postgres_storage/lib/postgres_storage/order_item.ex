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

  def get_by_article(article) do
    query = from oi in from_opened_order,
              where: oi.article == ^article
    case Repo.all(query) do
      [] ->
        {:error, "Not found"}
      order_item ->
        {:ok, order_item}
    end
  end

  def from_opened_order do
    from oi in __MODULE__,
      join: o in Order,
      where: o.closed == false
  end
end
