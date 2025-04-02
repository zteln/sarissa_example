defmodule SarissaExample.RemoveItemTest do
  use ExUnit.Case, async: true
  import SarissaCase

  setup [:new_channel]

  test "remove item", context do
    gwt(
      context,
      [
        %Sarissa.Events.CartCreated{
          cart_id: "test-cart"
        },
        %Sarissa.Events.ItemAdded{
          cart_id: "test-cart",
          description: "item desc",
          image: "item image",
          price: 100,
          item_id: 1,
          product_id: 2
        }
      ],
      %SarissaExample.Commands.RemoveItem{
        id: "test-cart",
        item_id: 1
      },
      [
        %Sarissa.Events.ItemRemoved{
          cart_id: "test-cart",
          item_id: 1
        }
      ]
    )
  end

  test "remove item which was already removed", context do
    gwt(
      context,
      [
        %Sarissa.Events.CartCreated{
          cart_id: "test-cart"
        },
        %Sarissa.Events.ItemAdded{
          cart_id: "test-cart",
          description: "item desc",
          image: "item image",
          price: 100,
          item_id: 1,
          product_id: 2
        },
        %Sarissa.Events.ItemRemoved{
          cart_id: "test-cart",
          item_id: 1
        }
      ],
      %SarissaExample.Commands.RemoveItem{
        id: "test-cart",
        item_id: 1
      },
      {:error, :item_not_in_cart}
    )
  end
end
