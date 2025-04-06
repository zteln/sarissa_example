defmodule SarissaExample.Events do
  use Sarissa.Events

  event(CartCreated, [:cart_id])
  event(ItemAdded, [:cart_id, :description, :image, :price, :item_id, :product_id])
  event(ItemRemoved, [:cart_id, :item_id])
  event(CartCleared, [:cart_id])
  event(InventoryChanged, [:product_id, :inventory])
  event(PriceChanged, [:product_id, :old_price, :new_price])
end
