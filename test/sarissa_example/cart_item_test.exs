defmodule SarissaExample.CartItemsTest do
  use ExUnit.Case, async: true
  import SarissaCase

  test_channel()
  start_projector(SarissaExample.Queries.CartItems)
  # setup [:new_channel, :start_projector]

  test "read cart items", context do
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

  # defp start_projector(context) do
  #   projector =
  #     start_supervised!(
  #       {SarissaExample.Queries.CartItems, channel: context[:channel], name: context[:module]}
  #     )
  #
  #   %{projector: projector}
  # end
end
