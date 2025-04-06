defmodule SarissaExample.ClearCartTest do
  use ExUnit.Case, async: true
  import SarissaCase

  # setup [:new_channel]
  test_channel()

  test "clear cart", context do
    gwt(
      context,
      [],
      %SarissaExample.Commands.ClearCart{
        id: "test-cart"
      },
      [
        %Sarissa.Events.CartCleared{
          cart_id: "test-cart"
        }
      ]
    )
  end

  test "clear cart with items", context do
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
      %SarissaExample.Commands.ClearCart{
        id: "test-cart"
      },
      [
        %Sarissa.Events.CartCleared{
          cart_id: "test-cart"
        }
      ]
    )
  end
end
