defmodule SarissaExample.Commands.AddItem do
  @moduledoc """
  Decider with Evolver example
  """
  use Sarissa.Decider, [:id, :description, :image, :price, :item_id, :product_id]
  use Sarissa.Evolver

  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Evolver
  def initial_context(opts) do
    channel = Channel.new("cart", id: opts[:id])
    initial_state = 0
    Sarissa.Context.new(channel: channel, state: initial_state)
  end

  @impl Sarissa.Evolver
  def handle_event(%Events.ItemAdded{}, no_of_items_in_cart), do: no_of_items_in_cart + 1

  def handle_event(%Events.ItemRemoved{}, no_of_items_in_cart), do: no_of_items_in_cart - 1

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = command, no_of_items_in_cart) do
    cond do
      no_of_items_in_cart >= 3 ->
        {:error, :too_many_items_already_in_cart}

      no_of_items_in_cart == 0 ->
        {:write,
         [
           %Events.CartCreated{cart_id: command.id},
           %Events.ItemAdded{
             cart_id: command.id,
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
             cart_id: command.id,
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
