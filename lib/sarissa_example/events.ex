defmodule SarissaExample.Events do
  use Sarissa.Events

  event(CartCreated, [:id])
  event(ItemAdded, [:id, :description, :image, :price, :item_id, :product_id])
end
