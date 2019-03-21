use Mix.Config

config :logger_json, :backend,
  formatter: EhealthLogger.Formatter,
  metadata: :all

config :logger,
  backends: [LoggerJSON],
  level: :info

config :edr_api,
  api: EdrApi.API.Edr,
  request_delay: {:system, :integer, "EDR_API_REQUEST_DELAY", 5_000}

config :edr_api, EdrApi.API.Edr,
  edr_url: {:system, :string, "EDR_URL", "https://zqedr-api.nais.gov.ua"},
  edr_api_version: {:system, :string, "EDR_API_VERSION", "1.0"},
  edr_api_resource: {:system, :string, "EDR_API_RESOURCE", "subjects"},
  edr_headers: [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"},
    {"cache-control", "no-cache"}
  ],
  edr_api_key: {:system, :string, "EDR_API_KEY", "Token test"},
  hackney_options: [
    connect_timeout: {:system, :integer, "EDR_API_REQUEST_TIMEOUT", 10_000},
    recv_timeout: {:system, :integer, "EDR_API_REQUEST_TIMEOUT", 10_000},
    timeout: {:system, :integer, "EDR_API_REQUEST_TIMEOUT", 10_000}
  ]

import_config "#{Mix.env()}.exs"
