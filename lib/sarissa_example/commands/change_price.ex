defmodule SarissaExample.Commands.ChangePrice do
  @moduledoc """
  Command with state from postgres table.
  """
  use Sarissa.Decider, [:id, :old_price, :new_price]
  alias Sarissa.Events
  alias Sarissa.Context
  alias Sarissa.EventStore.Channel
  alias SarissaExample.Repo
  alias SarissaExample.ChangedPrices.ChangedPrice

  @impl Sarissa.Decider
  def context(id, opts) do
    channel =
      (opts[:channel] || Channel.new("product", id: id))
      |> Channel.update_revision(:any)

    state = Repo.get_by(ChangedPrice, product_id: id)

    Context.new(channel: channel, state: state)
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = command, state) do
    case state do
      nil ->
        # Do something...
        {:write,
         [
           %Events.PriceChanged{
             product_id: command.id,
             old_price: command.old_price,
             new_price: command.new_price
           }
         ]}

      %ChangedPrice{} ->
        # Do something else...
        {:write,
         [
           %Events.PriceChanged{
             product_id: command.id,
             old_price: command.old_price,
             new_price: command.new_price
           }
         ]}
    end
  end
end
