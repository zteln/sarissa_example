defmodule SarissaExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Sarissa.EventStore, connection_string: "esdb://localhost:2113"},
      SarissaExample.Repo,
      SarissaExampleWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:sarissa_example, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SarissaExample.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SarissaExample.Finch},
      # Start a worker by calling: SarissaExample.Worker.start_link(arg)
      # {SarissaExample.Worker, arg},
      # Start to serve requests, typically the last entry
      SarissaExample.Queries.CartItems,
      SarissaExample.Queries.Inventories,
      SarissaExampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SarissaExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SarissaExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
