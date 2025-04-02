defmodule SarissaExample.Queries.CartItems do
  use Sarissa.Decider, [:id, :description, :image, :price, :item_id, :product_id]
  use Sarissa.Evolver

  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Evolver
  def initialize(_opts), do: %{}

  @impl Sarissa.Evolver
  def handle_event(%Events.ItemAdded{} = event, state) do
    Map.put(
      state,
      event.item_id,
      Map.take(event, [
        :description,
        :image,
        :price,
        :item_id,
        :product_id
      ])
    )
  end

  def handle_event(%Events.ItemRemoved{} = event, state) do
    Map.delete(state, event.item_id)
  end

  @impl Sarissa.Decider
  def channel(id, _opts), do: Channel.new("cart", id: id)

  @impl Sarissa.Decider
  def state(channel, opts), do: evolve(channel, opts)

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = query, state) do
    {:read, Enum.map(state, fn {_item_id, item} -> item end)}
  end
end
