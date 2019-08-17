import Config

config :amiunlocked, AmiunlockedWeb.Endpoint,
  server: true,
  url: [host: nil, port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]
