defmodule SarissaExample.Commands.RemoveItem do
  use Sarissa.Decider, [:id, :item_id]
  use Sarissa.Evolver

  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Evolver
  def initialize(_opts), do: MapSet.new()

  @impl Sarissa.Evolver
  def handle_event(%Events.ItemAdded{} = event, items) do
    MapSet.put(items, event.item_id)
  end

  def handle_event(%Events.ItemRemoved{} = event, items) do
    MapSet.delete(items, event.item_id)
  end

  @impl Sarissa.Decider
  def state(channel, opts) do
    evolve(channel, opts)
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = command, items) do
    if MapSet.member?(items, command.item_id) do
      {:write,
       [
         %Events.ItemRemoved{
           cart_id: command.id,
           item_id: command.item_id
         }
       ]}
    else
      {:error, :item_not_in_cart}
    end
  end
end
