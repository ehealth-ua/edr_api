use Mix.Config

config :edr_api,
  api: EdrApiMock,
  request_delay: {:system, :integer, "EDR_API_REQUEST_DELAY", 0}
