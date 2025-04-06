defmodule SarissaExample.Queries.CartItems do
  @moduledoc """
  Decider with Projector example
  """
  use Sarissa.Decider, [:id]
  use Sarissa.Projector

  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Evolver
  def initial_context(_opts) do
    channel = Channel.new("cart", type: :by_category)
    state = %{}
    Sarissa.Context.new(channel: channel, state: state)
  end

  @impl Sarissa.Evolver
  def handle_event(%Events.CartCreated{} = event, state) do
    Map.put(state, event.cart_id, %{})
  end

  def handle_event(%Events.ItemAdded{} = event, state) do
    item =
      Map.take(event, [
        :description,
        :image,
        :price,
        :item_id,
        :product_id
      ])

    Map.update(
      state,
      event.cart_id,
      %{event.item_id => item},
      &Map.put(&1, event.item_id, item)
    )
  end

  def handle_event(%Events.ItemRemoved{} = event, state) do
    cart_items =
      state
      |> Map.get(event.cart_id)
      |> Map.delete(event.item_id)

    case Enum.count(cart_items) do
      0 -> Map.delete(state, event.cart_id)
      _ -> Map.put(state, event.cart_id, cart_items)
    end
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = query, state) do
    result =
      state
      |> Map.get(query.id, %{})
      |> Enum.map(fn {_item_id, item} -> item end)

    {:read, result}
  end
end
