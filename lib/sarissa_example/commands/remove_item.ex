defmodule SarissaExample.Commands.RemoveItem do
  @moduledoc """
  Decider with file persistance example
  """
  use Sarissa.Decider, [:id, :item_id]
  use Sarissa.Evolver

  alias Sarissa.Events
  alias Sarissa.EventStore.Channel

  @impl Sarissa.Evolver
  def initial_context(opts) do
    file = file(opts)
    %{revision: revision} = read(file)
    channel = Channel.new("cart", id: opts[:id]) |> Channel.update_revision(revision)
    Sarissa.Context.new(channel: channel, state: file)
  end

  @impl Sarissa.Evolver
  def handle_event(%Events.ItemAdded{} = event, file) do
    %{items: items} = read(file)
    items = MapSet.put(items, event.item_id)

    write(event, items, file)
    file
  end

  def handle_event(%Events.ItemRemoved{} = event, file) do
    %{items: items} = read(file)
    items = MapSet.delete(items, event.item_id)

    write(event, items, file)
    file
  end

  @impl Sarissa.Decider
  def decide(%__MODULE__{} = command, file) do
    %{items: items} = read(file)

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

  defp read(file) do
    file
    |> File.read!()
    |> decode()
  end

  defp write(event, items, file) do
    revision = Sarissa.Events.get_revision(event)
    data = encode(%{revision: revision, items: items})
    File.write!(file, data)
  end

  defp file(opts) do
    file = opts[:persistant_file] || "/tmp/#{opts[:id]}_persistance.txt"

    if File.exists?(file) do
      file
    else
      File.write!(file, encode(%{revision: :start, items: MapSet.new()}))
      file
    end
  end

  defp encode(term), do: :erlang.term_to_binary(term)
  defp decode(bin), do: :erlang.binary_to_term(bin)
end
