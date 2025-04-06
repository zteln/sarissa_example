defmodule SarissaExample.Translators.Inventory do
  def trigger(%{id: product_id, inventory: product_inventory}, opts) do
    %SarissaExample.Commands.ChangeInventory{
      id: product_id,
      inventory: product_inventory
    }
    |> Sarissa.Decider.execute(opts)
  end

  def trigger(_inventory_change) do
    {:error, :bad_inventory_change}
  end
end
