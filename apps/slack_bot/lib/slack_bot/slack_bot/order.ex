defmodule SlackBot.Order do
  @moduledoc false

  alias Storage.OrderItem
  alias Storage.Repo

  def add(article, quantity, measure_unit) do
    with \
      {quantity, _} <- Integer.parse(quantity),
      {:ok, _} <- Repo.insert(OrderItem.changeset(%OrderItem{}, %{name: article, quantity: quantity, measure_unit: measure_unit})) do
      {:ok, "Added without a problem"}
    else
      :error -> {:error, "There was a problem with the order"}
    end
  end
end
