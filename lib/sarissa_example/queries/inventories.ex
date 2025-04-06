defmodule SarissaExample.Queries.Inventories do
  @moduledoc """
  Decider with postgres table example
  """
  use Sarissa.Decider, [:id]
  use Sarissa.Projector
  alias Sarissa.Events
  alias SarissaExample.Repo
  alias SarissaExample.Inventories.Inventory

  @impl Sarissa.Evolver
  def initial_context(_opts) do
    channel = Sarissa.EventStore.Channel.new("product", type: :by_category)
    Sarissa.Context.new(channel: channel)
  end

  @impl Sarissa.Evolver
  def handle_event(%Events.InventoryChanged{} = event, state) do
    inventory = %Inventory{product_id: event.product_id, inventory: event.inventory}

    Repo.insert!(inventory,
      on_conflict: [set: [inventory: event.inventory]],
      conflict_target: :product_id
    )

    state
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = query, _state) do
    result =
      case Repo.get_by(Inventory, product_id: query.id) do
        %Inventory{} = inventory ->
          %{product_id: inventory.product_id, inventory: inventory.inventory}

        _ ->
          %{}
      end

    {:read, result}
  end
end
