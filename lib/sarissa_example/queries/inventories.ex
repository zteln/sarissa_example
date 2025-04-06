defmodule SarissaExample.Queries.Inventories do
  @moduledoc """
  Decider with postgres table example
  """
  use Sarissa.Decider, [:id]
  use Sarissa.Projector
  alias Sarissa.Events
  alias Sarissa.Context
  alias SarissaExample.Repo
  alias SarissaExample.Inventories.Inventory

  @impl Sarissa.Evolver
  def initial_context(_opts) do
    channel = Sarissa.EventStore.Channel.new("product", type: :by_category)
    Context.new(channel: channel)
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
  def context(id, _opts) do
    state = Repo.get_by(Inventory, product_id: id)

    Context.new(state: state)
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{}, state) do
    result =
      case state do
        %Inventory{} = inventory ->
          %{product_id: inventory.product_id, inventory: inventory.inventory}

        _ ->
          %{}
      end

    {:read, result}
  end
end
