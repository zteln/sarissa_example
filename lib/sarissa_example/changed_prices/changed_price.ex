defmodule SarissaExample.ChangedPrices.ChangedPrice do
  use Ecto.Schema

  schema "changed_prices" do
    field(:product_id, :string)
    field(:old_price, :integer)
    field(:new_price, :integer)
  end
end
