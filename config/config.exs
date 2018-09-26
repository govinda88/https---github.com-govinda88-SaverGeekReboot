# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :saver_admin, SaverAdmin.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "+9AYioO/U1R8B1txibl8EgvekWw6vuoboDUe6wMXPf2S6QGGA+v5cpM/IowZ0WwE",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: SaverAdmin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# Mailgun config

config :saver_admin, 
       mailgun_domain: "https://api.mailgun.net/v3/sandboxfc3c9566089b4196add983afebf0bb90.mailgun.org",
       mailgun_key: "key-6c1b24342f3f5756ca16c1fa362b7393"
