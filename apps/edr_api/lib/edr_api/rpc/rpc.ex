defmodule EdrApi.Rpc do
  @moduledoc """
  This module contains functions that are called from other pods via RPC.
  """

  import EdrApi.Validator

  @edr_api Application.get_env(:edr_api, :api)

  @doc """
  Get legal entity detailed information by code (EDRPOU)
  In case of error the second response parameter could be a binary or a map with keys 'status_code' and 'body' (error description)

  ## Examples

      iex> EdrApi.Rpc.legal_entity_by_code("00000000")
      {:ok,
      %{
        activity_kinds: [
          %{
            ...
          }
        ],
        address: %{
          address: "...",
          country: "...",
          parts: %{
            atu: "...",
            atu_code: "ATU_CODE",
            ...
          },
          ...
        },
        assignees: [],
        authorised_capital: %{...},
        bankruptcy: nil,
        branches: [],
        code: "some code",
        contacts: %{...},
        executive_power: nil,
        founders: [
          %{
            ...
          }
        ],
        founding_document: nil,
        heads: [
          %{
            ...
          }
        ],
        id: 1111111,
        is_modal_statute: false,
        management: "...",
        managing_paper: nil,
        names: %{
          display: "Some name",
          include_olf: 1,
          name: "...",
          name_en: "",
          short: "...",
          short_en: ""
        },
        object_name: "...",
        olf_code: "...",
        olf_name: "...",
        open_enforcements: ["2000-01-01", ...],
        predecessors: [],
        prev_registration_end_term: nil,
        primary_activity_kind: %{
          ...
        },
        registration: %{
          ...
        },
        registrations: [
          %{
            ...
          },
          ...
        ],
        state: 1,
        state_text: "зареєстровано",
        termination: nil,
        termination_cancel: nil
      }}

      iex> EdrApi.Rpc.legal_entity_by_code("00000000")
      {:error,
        %{
          "body" => %{"errors" => [%{"code" => 2, "message" => "Invalid token."}]},
          "status_code" => 401
        }}
  """
  @spec legal_entity_by_code(code :: binary()) :: {:ok, map()} | {:error, binary()} | {:error, atom()} | {:error, map()}
  def legal_entity_by_code(code) do
    request_delay = Confex.fetch_env!(:edr_api, :request_delay)

    with :ok <- validate_code(code),
         {:ok, %{"id" => id}} <- search_legal_entity(%{code: code}) do
      :timer.sleep(request_delay)
      get_legal_entity_detailed_info(id)
    end
  end

  @doc """
  Get legal entity detailed information by pasport
  In case of error the second response parameter could be a binary or a map with keys 'status_code' and 'body' (error description)

  ## Examples

      iex> EdrApi.Rpc.legal_entity_by_pasport("ББ000000")
      {:ok,
      %{
        activity_kinds: [
          %{
            ...
          }
        ],
        address: %{
          address: "...",
          country: "...",
          parts: %{
            atu: "...",
            atu_code: "ATU_CODE",
            ...
          },
          ...
        },
        assignees: [],
        authorised_capital: %{...},
        bankruptcy: nil,
        branches: [],
        code: "some code",
        contacts: %{...},
        executive_power: nil,
        founders: [
          %{
            ...
          }
        ],
        founding_document: nil,
        heads: [
          %{
            ...
          }
        ],
        id: 1111111,
        is_modal_statute: false,
        management: "...",
        managing_paper: nil,
        names: %{
          display: "Some name",
          include_olf: 1,
          name: "...",
          name_en: "",
          short: "...",
          short_en: ""
        },
        object_name: "...",
        olf_code: "...",
        olf_name: "...",
        open_enforcements: ["2000-01-01", ...],
        predecessors: [],
        prev_registration_end_term: nil,
        primary_activity_kind: %{
          ...
        },
        registration: %{
          ...
        },
        registrations: [
          %{
            ...
          },
          ...
        ],
        state: 1,
        state_text: "зареєстровано",
        termination: nil,
        termination_cancel: nil
      }}

      iex> EdrApi.Rpc.legal_entity_by_pasport("ББ000000")
      {:error,
        %{
          "body" => %{"errors" => [%{"code" => 2, "message" => "Invalid token."}]},
          "status_code" => 401
        }}
  """
  @spec legal_entity_by_passport(passport :: binary()) ::
          {:ok, map()} | {:error, binary()} | {:error, atom()} | {:error, map()}
  def legal_entity_by_passport(passport) do
    request_delay = Confex.fetch_env!(:edr_api, :request_delay)

    with :ok <- validate_passport(passport),
         {:ok, %{"id" => id}} <- search_legal_entity(%{passport: passport}) do
      :timer.sleep(request_delay)
      get_legal_entity_detailed_info(id)
    end
  end

  defp search_legal_entity(params) do
    case @edr_api.search_legal_entity(params) do
      {:ok, response} -> validate_response(response)
      error -> error
    end
  end

  defp get_legal_entity_detailed_info(id) do
    case @edr_api.legal_entity_detailed_info(id) do
      {:ok, response} -> validate_response(response)
      error -> error
    end
  end
end
