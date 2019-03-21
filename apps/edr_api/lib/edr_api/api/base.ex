defmodule EdrApi.API.Base do
  @moduledoc false

  require Logger
  alias HTTPoison.Error
  alias HTTPoison.Response

  @success_codes [200]

  defmacro __using__(_) do
    quote do
      use Confex, otp_app: :edr_api
      use HTTPoison.Base
      import EdrApi.API.Base
      require Logger

      def process_url(url) do
        "#{config()[:edr_url]}/#{config()[:edr_api_version]}/#{config()[:edr_api_resource]}#{url}"
      end

      def process_request_options(options), do: Keyword.merge(config()[:hackney_options], options)

      def process_request_headers(headers) do
        headers ++ config()[:edr_headers] ++ [{"Authorization", config()[:edr_api_key]}]
      end

      def request(method, url, body \\ "", headers \\ [], options \\ []) do
        params = Keyword.get(options, :params, %{})
        query_string = if Enum.empty?(params), do: "", else: "?#{URI.encode_query(params)}"
        endpoint = process_url(url)
        Logger.info("Microservice #{method} request to #{endpoint} with params: #{Jason.encode!(params)}")
        check_response(super(method, url, body, headers, options))
      end
    end
  end

  def check_response({:ok, %Response{status_code: status_code, body: body}})
      when status_code in @success_codes do
    case decode_response(body) do
      {:ok, body} -> {:ok, %{body: body, status_code: status_code}}
      error -> error
    end
  end

  def check_response({:ok, %Response{status_code: status_code, body: body}}) do
    {:ok, %{body: body, status_code: status_code}}
  end

  def check_response({:error, %Error{reason: reason}}) do
    Logger.error("HTTPoison error: #{reason}")
    {:error, reason}
  end

  def decode_response("") do
    Logger.error("Invalid response body: empty binary")
    {:error, "Invalid response body"}
  end

  def decode_response(response) do
    case Jason.decode(response) do
      {:ok, body} ->
        {:ok, body}

      err ->
        Logger.error(err)
        {:error, "Response body parse error: #{response}"}
    end
  end
end
