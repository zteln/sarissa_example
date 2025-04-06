defmodule SarissaExample.InventoriesTest do
  use ExUnit.Case, async: true
  import SarissaCase
  alias Sarissa.Events

  test_channel()
  start_projector(SarissaExample.Queries.Inventories)

  test "inventories", context do
    gwt(
      context,
      [
        %Events.InventoryChanged{
          product_id: "product-1",
          inventory: 5
        }
      ],
      %SarissaExample.Queries.Inventories{
        id: "product-1"
      },
      %{
        product_id: "product-1",
        inventory: 5
      }
    )
  end
end
