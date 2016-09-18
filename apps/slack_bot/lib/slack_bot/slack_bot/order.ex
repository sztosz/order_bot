defmodule SlackBot.Order do
  @moduledoc false

  alias Storage.OrderItem
  alias Storage.Repo

  import Happy

  def add(order) do
    case String.split(order) do
        [article, quantity, measure_unit] ->
          add(article, quantity, measure_unit)
        [_ | _] ->
          {:error, "I did not understand"}
    end
  end

  defp add(article, quantity, measure_unit) do
    happy_path do
      {quantity, _} =
        Integer.parse(quantity)
      {:ok, _} =
        Repo.insert(OrderItem.changeset(%OrderItem{}, %{name: article, quantity: quantity, measure_unit: measure_unit}))
      {:ok, "Added without a problem"}
    else
      :error -> {:error, "Product quantity has to be an Integer, and you wrote `#{quantity}` "}
    end
  end
end
