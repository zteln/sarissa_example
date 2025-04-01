defmodule SarissaExample.AddItemTest do
  use ExUnit.Case, async: true
  import SarissaCase

  setup [:new_channel]

  test "add item", context do
    gwt(
      context,
      [],
      %SarissaExample.Commands.AddItem{
        id: "test-cart",
        description: "item desc",
        image: "item image",
        price: 100,
        item_id: 1,
        product_id: 2
      },
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
      ]
    )
  end

  test "add item max 3 times", context do
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
        },
        %Sarissa.Events.ItemAdded{
          id: "test-cart",
          description: "item desc",
          image: "item image",
          price: 100,
          item_id: 2,
          product_id: 3
        },
        %Sarissa.Events.ItemAdded{
          id: "test-cart",
          description: "item desc",
          image: "item image",
          price: 100,
          item_id: 3,
          product_id: 4
        }
      ],
      %SarissaExample.Commands.AddItem{
        id: "test-cart",
        description: "item desc",
        image: "item image",
        price: 100,
        item_id: 4,
        product_id: 5
      },
      {:error, :too_many_items_already_in_cart}
    )
  end
end
