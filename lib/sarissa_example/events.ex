defmodule SarissaExample.Events do
  use Sarissa.Events

  event(CartCreated, [:id])
  event(ItemAdded, [:id, :description, :image, :price, :item_id, :product_id])
  event(ItemRemoved, [:id, :item_id])
end
