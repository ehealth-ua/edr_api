defmodule EdrApi.Rpc do
  @moduledoc """
  This module contains functions that are called from other pods via RPC.
  """

  import EdrApi.Validator

  @edr_api Application.get_env(:edr_api, :api)

  @doc """
  Search legal entity by passport or EDRPOU

  ## Examples

      iex> EdrApi.Rpc.search_legal_entity(%{passport: "ББ000000"})
      {:ok, %{
        "url" => "https://example.com",
        "id" => 123456,
        "state" => 1,
        "state_text" => "зареєстровано",
        "passport" => "АА111111",
        "name" => "TEST"
      }}

      iex> EdrApi.Rpc.legal_entity_by_pasport(%{passport: "ББ000000"})
      {:error,
        %{
          "body" => %{"errors" => [%{"code" => 2, "message" => "Invalid token."}]},
          "status_code" => 401
        }}
  """
  @spec search_legal_entity(params :: map()) ::
          {:ok, map()} | {:error, binary()} | {:error, atom()} | {:error, map()}
  def search_legal_entity(params) do
    with :ok <- validate_params(params) do
      case @edr_api.search_legal_entity(params) do
        {:ok, response} -> validate_response(response)
        error -> error
      end
    end
  end

  @doc """
  Get legal entity detailed information by id

  ## Examples

      iex> EdrApi.Rpc.get_legal_entity_detailed_info("1111111")
      {:ok,
      %{
        "activity_kinds" => [
          %{
            ...
          }
        ],
        "address" => %{
          "address" => "...",
          "country" => "...",
          "parts" => %{
            "atu" => "...",
            "atu_code" => "ATU_CODE",
            ...
          },
          ...
        },
        "assignees" => [],
        "authorised_capital" => %{...},
        "bankruptcy" => nil,
        "branches" => [],
        "code" => "some code",
        "contacts" => %{...},
        "executive_power" => nil,
        "founders" => [
          %{
            ...
          }
        ],
        "founding_document" => nil,
        "heads" => [
          %{
            ...
          }
        ],
        "id" => 1111111,
        "is_modal_statute" => false,
        "management" => "...",
        "managing_paper" => nil,
        "names" => %{
          "display" => "Some name",
          "include_olf" => 1,
          "name" => "...",
          "name_en" => "",
          "short" => "...",
          "short_en" => ""
        },
        "object_name" => "...",
        "olf_code" => "...",
        "olf_name" => "...",
        "open_enforcements" => ["2000-01-01", ...],
        "predecessors" => [],
        "prev_registration_end_term" => nil,
        "primary_activity_kind" => %{
          ...
        },
        "registration" => %{
          ...
        },
        "registrations" => [
          %{
            ...
          },
          ...
        ],
        "state" => 1,
        "state_text" => "зареєстровано",
        "termination" => nil,
        "termination_cancel" => nil
      }}

      iex> EdrApi.Rpc.get_legal_entity_detailed_info("1111111")
      {:error,
        %{
          "body" => %{"errors" => [%{"code" => 2, "message" => "Invalid token."}]},
          "status_code" => 401
        }}
  """
  @spec get_legal_entity_detailed_info(id :: binary()) ::
          {:ok, map()} | {:error, binary()} | {:error, atom()} | {:error, map()}
  def get_legal_entity_detailed_info(id) do
    case @edr_api.legal_entity_detailed_info(id) do
      {:ok, response} -> validate_response(response)
      error -> error
    end
  end
end
