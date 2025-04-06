defmodule SarissaExample.Commands.ChangeInventory do
  @moduledoc """
  Decider with no state.
  """
  use Sarissa.Decider, [:id, :inventory]
  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Decider
  def context(id, opts) do
    channel =
      (opts[:channel] || Channel.new("product", id: id))
      |> Channel.update_revision(:any)

    Sarissa.Context.new(channel: channel)
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = command, _state) do
    {:write,
     [
       %Events.InventoryChanged{
         product_id: command.id,
         inventory: command.inventory
       }
     ]}
  end
end
