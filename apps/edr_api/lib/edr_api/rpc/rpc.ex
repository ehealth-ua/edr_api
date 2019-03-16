defmodule EdrApi.Rpc do
  @moduledoc """
  This module contains functions that are called from other pods via RPC.
  """

  import EdrApi.Validator
  alias HTTPoison.Error
  alias HTTPoison.Response

  @edr_api Application.get_env(:edr_api, :api)

  def search_legal_entity(params) do
    with :ok <- validate_params(:search, params),
         {:ok, %Response{body: body, status_code: status_code}} <- @edr_api.search_legal_entity(params),
         :ok <- validate_status_code(status_code),
         {:ok, response_data} <- validate_body(body) do
      {:ok, response_data}
    else
      {:error, %Error{reason: reason}} -> {:error, {:httpoison_error, reason}}
      error -> error
    end
  end

  def legal_entity_detailed_info(id) do
    with :ok <- validate_params(:get, id),
         {:ok, %Response{body: body, status_code: status_code}} <- @edr_api.legal_entity_detailed_info(id),
         :ok <- validate_status_code(status_code),
         {:ok, response_data} <- validate_body(body) do
      {:ok, response_data}
    else
      {:error, %Error{reason: reason}} -> {:error, {:httpoison_error, reason}}
      error -> error
    end
  end

  def search_get_legal_entity_detailed_info(params) do
    request_delay = Confex.fetch_env!(:edr_api, :request_delay)

    case search_legal_entity(params) do
      {:ok, %{id: id}} ->
        :timer.sleep(request_delay)
        legal_entity_detailed_info(id)

      error ->
        error
    end
  end
end
