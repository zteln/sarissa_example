defmodule SarissaExample.ChangeInventoryTest do
  use ExUnit.Case, async: true
  import SarissaCase

  # setup [:new_channel]
  test_channel()

  test "change inventory", context do
    gwt(
      context,
      [],
      %SarissaExample.Commands.ChangeInventory{
        id: "test-product",
        inventory: 0
      },
      [
        %Sarissa.Events.InventoryChanged{
          product_id: "test-product",
          inventory: 0
        }
      ]
    )
  end
end
