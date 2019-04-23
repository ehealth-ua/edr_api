defmodule EdrApi.Validator do
  @moduledoc """
  EDR API validator
  """

  require Logger

  def validate_params(params) do
    with :ok <- validate_passport(Map.get(params, :passport)),
         :ok <- validate_code(Map.get(params, :code)) do
      :ok
    end
  end

  def validate_code(nil), do: :ok

  def validate_code(value) when is_binary(value) do
    if Regex.match?(~r/^[0-9]{8,10}|[0-9]{9,10}$/, value) do
      :ok
    else
      Logger.error(
        "Invalid request params (code request param should match '^[0-9]{8,10}|[0-9]{9,10}$' reg exp): #{value}"
      )

      {:error, "code request param should match '^[0-9]{8,10}|[0-9]{9,10}$' reg exp"}
    end
  end

  def validate_code(value) do
    Logger.error("Invalid request params (code request param should be a binary): #{value}")
    {:error, "code request param should be a binary"}
  end

  def validate_passport(nil), do: :ok

  def validate_passport(value) when is_binary(value) do
    if Regex.match?(~r/^((?![ЫЪЭЁ])([А-ЯҐЇІЄ])){2}[0-9]{6}$/u, value) do
      :ok
    else
      Logger.error(
        "Invalid request params (passport request param should match '^[0-9]{8,10}|[0-9]{9,10}$' reg exp): #{value}"
      )

      {:error, "passport request param should match '^((?![ЫЪЭЁ])([А-ЯҐЇІЄ])){2}[0-9]{6}$' reg exp"}
    end
  end

  def validate_passport(value) do
    Logger.error("Invalid request params (passport request param should be a binary): #{value}")
    {:error, "passport request param should be a binary"}
  end

  def validate_response(%{status_code: 200, body: ""}), do: {:ok, []}

  def validate_response(%{status_code: 200, body: body}) do
    {:ok, body}
  end

  def validate_response(%{status_code: status_code, body: body}) do
    {:error, %{"status_code" => status_code, "body" => body}}
  end
end
