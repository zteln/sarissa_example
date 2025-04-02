defmodule SarissaExample.CartItemsTest do
  use ExUnit.Case, async: true
  import SarissaCase

  setup [:new_channel]

  test "read cart items", context do
    gwt(
      context,
      [
        %Sarissa.Events.CartCreated{
          id: "test-cart"
        },
        %Sarissa.Events.ItemAdded{
          id: "test-cart",
          description: "item desc",
          image: "item image",
          price: 100,
          item_id: 1,
          product_id: 2
        }
      ],
      %SarissaExample.Queries.CartItems{
        id: "test-cart"
      },
      [
        %{
          description: "item desc",
          image: "item image",
          price: 100,
          item_id: 1,
          product_id: 2
        }
      ]
    )
  end
end
