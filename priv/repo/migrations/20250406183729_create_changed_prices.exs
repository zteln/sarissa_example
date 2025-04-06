defmodule SarissaExample.Repo.Migrations.CreateChangedPrices do
  use Ecto.Migration

  def change do
    create table(:changed_prices) do
      add(:product_id, :string, primary_key: true)
      add(:old_price, :integer)
      add(:new_price, :integer)
    end

    create(index("changed_prices", [:product_id], unique: true))
  end
end
