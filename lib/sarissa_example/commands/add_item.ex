defmodule SarissaExample.Commands.AddItem do
  use Sarissa.Decider, [:id, :description, :image, :price, :item_id, :product_id]
  use Sarissa.Evolver

  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Evolver
  def initialize(_opts), do: 0

  @impl Sarissa.Evolver
  def handle_event(%Events.ItemAdded{}, no_of_items_in_cart) do
    no_of_items_in_cart + 1
  end

  @impl Sarissa.Decider
  def channel(id, _opts), do: Channel.new("cart", id: id)

  @impl Sarissa.Decider
  def state(channel, opts) do
    evolve(channel, opts)
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = command, no_of_items_in_cart) do
    cond do
      no_of_items_in_cart >= 3 ->
        {:error, :too_many_items_already_in_cart}

      no_of_items_in_cart == 0 ->
        {:write,
         [
           %Events.CartCreated{id: command.id},
           %Events.ItemAdded{
             id: command.id,
             description: command.description,
             image: command.image,
             price: command.price,
             item_id: command.item_id,
             product_id: command.product_id
           }
         ]}

      true ->
        {:write,
         [
           %Events.ItemAdded{
             id: command.id,
             description: command.description,
             image: command.image,
             price: command.price,
             item_id: command.item_id,
             product_id: command.product_id
           }
         ]}
    end
  end
end
