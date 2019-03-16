defmodule EdrApi.API.EDRBehaviour do
  @moduledoc false

  alias HTTPoison.Error
  alias HTTPoison.Response

  @callback search_legal_entity(params :: map) :: {:ok, Response.t()} | {:error, Error.t()}
  @callback legal_entity_detailed_info(id :: binary) :: {:ok, Response.t()} | {:error, Error.t()}
end
