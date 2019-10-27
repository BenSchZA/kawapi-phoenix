defmodule Example.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Logger.Server
  run Example.Grpc.Server
end

defmodule Example.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Example.Repo,
      # Start the endpoint when the application starts
      ExampleWeb.Endpoint,
      # Starts a worker by calling: Example.Worker.start_link(arg)
      # {Example.Worker, arg},
      supervisor(GRPC.Server.Supervisor, [{Example.Endpoint, 50051}])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
