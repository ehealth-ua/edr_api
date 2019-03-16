defmodule EdrApi.API.EDR do
  @moduledoc """
  EDR API client
  """

  use Confex, otp_app: :edr_api
  use HTTPoison.Base

  @behaviour Core.API.OPSBehaviour

  def search_legal_entity(params) do
    get(url(), headers(), params: params, recv_timeout: 5_000)
  end

  def legal_entity_detailed_info(id) do
    get(url(id), headers(), recv_timeout: 5_000)
  end

  def process_response_body(body) do
    case Jason.decode(body) do
      {:ok, content} -> content
      _ -> nil
    end
  end

  defp url do
    config = config()
    slashed(config[:edr_url]) <> slashed(config[:edr_api_version]) <> config[:edr_api_resource]
  end

  defp url(id) when is_number(id), do: url(to_string(id))

  defp url(id) when is_binary(id) do
    config = config()
    slashed(config[:edr_url]) <> slashed(config[:edr_api_version]) <> slashed(config[:edr_api_resource]) <> id
  end

  defp headers, do: config()[:edr_headers] ++ [{"Authorization", config()[:edr_api_key]}]
  defp slashed(str), do: str <> "/"
end
