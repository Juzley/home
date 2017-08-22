# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :home, Home.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z0jgHkwX/fE66i6xG2oyfn8p5Rjo3kFDW+jAjH/BKtroWpCNRc72fulUWW8OK8eL",
  render_errors: [view: Home.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Home.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
