defmodule EdrApi.API.Edr do
  @moduledoc """
  EDR API client
  """

  use EdrApi.API.Base

  @behaviour EdrApi.API.EdrBehaviour

  def search_legal_entity(params) do
    get("", [], params: params)
  end

  def legal_entity_detailed_info(id) do
    get("/#{id}", [])
  end
end
