defmodule SarissaExample.Commands.ClearCart do
  @moduledoc """
  Decider with no state example.
  """
  use Sarissa.Decider, [:id]
  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Decider
  def context(id, opts) do
    channel =
      (opts[:channel] || Channel.new("cart", id: id))
      |> Channel.update_revision(:any)

    Sarissa.Context.new(channel: channel)
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = command, _state) do
    {:write,
     [
       %Events.CartCleared{
         cart_id: command.id
       }
     ]}
  end
end
