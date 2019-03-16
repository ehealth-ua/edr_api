use Mix.Config

config :logger_json, :backend,
  formatter: EhealthLogger.Formatter,
  metadata: :all

config :logger,
  backends: [LoggerJSON],
  level: :info

config :edr_api,
  api: EdrApi.API.EDR,
  request_delay: {:system, :integer, "EDR_API_REQUEST_DELAY", 1_000}

config :edr_api, EdrApi.API.EDR,
  edr_url: {:system, :string, "EDR_URL", "https://zqedr-api.nais.gov.ua"},
  edr_api_version: {:system, :string, "EDR_API_VERSION", "1.0"},
  edr_api_resource: {:system, :string, "EDR_API_RESOURCE", "subjects"},
  edr_headers: [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"},
    {"cache-control", "no-cache"}
  ],
  edr_api_key: {:system, :string, "EDR_API_KEY"}

import_config "#{Mix.env()}.exs"
