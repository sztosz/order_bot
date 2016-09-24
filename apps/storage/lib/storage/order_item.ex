defmodule Storage.OrderItem do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias Storage.Repo


  schema "order_items" do
    field :article, :string
    field :quantity, :integer
    field :measure_unit, :string

    field :deleted_at, Ecto.DateTime

    timestamps
  end

  def changeset(order_item, params \\ %{}) do
    order_item
    |> Changeset.cast(params, [:article, :quantity, :measure_unit])
    |> Changeset.validate_required([:article, :quantity, :measure_unit])
  end

  def get_by_article(article) do
    case Repo.get_by(__MODULE__, article: article) do
      nil ->
        {:error, 'Not found'}
      order_item ->
        {:ok, order_item}
    end
  end
end
