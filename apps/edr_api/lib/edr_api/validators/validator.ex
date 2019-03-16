defmodule EdrApi.Validator do
  @moduledoc """
  EDR API validator
  """

  def validate_params(:search, params) when is_map(params) do
    params
    |> atomize_keys()
    |> do_validate_params()
  end

  def validate_params(:search, _) do
    {:error, {:invalid_request_params, "request_params should be a map with one of keys 'code' or 'passport'"}}
  end

  def validate_params(:get, value) when is_integer(value), do: :ok
  def validate_params(:get, value) when is_binary(value), do: :ok
  def validate_params(:get, _), do: {:error, {:invalid_request_params, "request_param should be a binary or a integer"}}

  def validate_status_code(200), do: :ok
  def validate_status_code(_), do: {:error, {:invalid_validation, "EDR validation failed"}}

  def validate_body(nil), do: {:error, {:invalid_validation, "EDR validation failed"}}

  def validate_body(body) when is_list(body) and length(body) != 1 do
    {:error, {:invalid_validation, "EDR validation failed"}}
  end

  def validate_body([body]), do: validate_body(body)
  def validate_body(body) when is_map(body), do: {:ok, atomize_keys(body)}
  def validate_body(_), do: {:error, {:invalid_validation, "EDR validation failed"}}

  defp atomize_keys(nil), do: nil

  defp atomize_keys(value) when is_map(value) do
    value
    |> Enum.map(fn {k, v} ->
      if is_binary(k) do
        {String.to_atom(k), atomize_keys(v)}
      else
        {k, atomize_keys(v)}
      end
    end)
    |> Enum.into(%{})
  end

  defp atomize_keys(value) when is_list(value) do
    Enum.map(value, &atomize_keys/1)
  end

  defp atomize_keys(value), do: value

  defp do_validate_params(%{code: _, passport: _}) do
    {:error, {:invalid_request_params, "request_params should be a map with one of keys 'code' or 'passport'"}}
  end

  defp do_validate_params(%{code: value}), do: validate_code(value)
  defp do_validate_params(%{passport: value}), do: validate_passport(value)

  defp validate_code(value) do
    if Regex.match?(~r/^[0-9]{8,10}|[0-9]{9,10}$/, value) do
      :ok
    else
      {:error, {:invalid_request_params, "code request param should match '^[0-9]{8,10}|[0-9]{9,10}$' reg exp"}}
    end
  end

  defp validate_passport(value) do
    if Regex.match?(~r/^((?![ЫЪЭЁ])([А-ЯҐЇІЄ])){2}[0-9]{6}$/, value) do
      :ok
    else
      {:error,
       {:invalid_request_params, "passport request param should match '^((?![ЫЪЭЁ])([А-ЯҐЇІЄ])){2}[0-9]{6}$' reg exp"}}
    end
  end
end
