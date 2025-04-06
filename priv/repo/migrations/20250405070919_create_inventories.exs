defmodule SarissaExample.Repo.Migrations.CreateInventories do
  use Ecto.Migration

  def change do
    create table(:inventories) do
      add(:product_id, :string, primary_key: true)
      add(:inventory, :integer)
    end

    create(index("inventories", [:product_id], unique: true))
  end
end
