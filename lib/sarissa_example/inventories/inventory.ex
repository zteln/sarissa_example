defmodule SarissaExample.Inventories.Inventory do
  use Ecto.Schema

  schema "inventories" do
    field(:product_id, :string)
    field(:inventory, :integer)
  end
end
