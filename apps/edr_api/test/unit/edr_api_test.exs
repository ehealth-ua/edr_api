defmodule EdrApiTest do
  use ExUnit.Case
  import Mox

  alias EdrApi.Rpc
  alias HTTPoison.Error
  alias HTTPoison.Response

  setup :verify_on_exit!

  describe "search_legal_entity" do
    test "success search legal entity" do
      code = "11111111"

      body = [
        %{
          "url" => "https://example.com",
          "id" => 123_456,
          "state" => 1,
          "state_text" => "зареєстровано",
          "code" => code,
          "name" => "TEST"
        }
      ]

      edr_api_expectation(:search_legal_entity, body, 200)
      assert {:ok, body} = Rpc.search_legal_entity(%{"code" => code})
    end

    test "invalid request params" do
      assert {:error, {:invalid_request_params, "request_params should be a map with one of keys 'code' or 'passport'"}} =
               Rpc.search_legal_entity(%{code: "11111111", passport: "АА111111"})

      assert {:error, {:invalid_request_params, "request_params should be a map with one of keys 'code' or 'passport'"}} =
               Rpc.search_legal_entity(code: "11111111", passport: "АА111111")

      assert {:error, {:invalid_request_params, reason}} = Rpc.search_legal_entity(%{code: "test"})
      assert reason =~ "code request param should match"

      assert {:error, {:invalid_request_params, reason}} = Rpc.search_legal_entity(%{passport: "test"})
      assert reason =~ "passport request param should match"
    end

    test "invalid response status code" do
      edr_api_expectation(:search_legal_entity, "body", 403)
      assert {:error, {:invalid_validation, "EDR validation failed"}} = Rpc.search_legal_entity(%{code: "11111111"})
    end

    test "invalid response body" do
      api_call_fun = fn body, status_code ->
        edr_api_expectation(:search_legal_entity, body, status_code)
        assert {:error, {:invalid_validation, "EDR validation failed"}} = Rpc.search_legal_entity(%{code: "11111111"})
      end

      api_call_fun.(nil, 200)
      api_call_fun.("body", 200)
      api_call_fun.([], 200)
      api_call_fun.(["body", "body"], 200)

      api_call_fun.(
        body = [
          %{
            "url" => "https://example.com",
            "id" => 123_456,
            "state" => 1,
            "state_text" => "зареєстровано",
            "code" => "code",
            "name" => "TEST"
          },
          %{
            "url" => "https://example.com",
            "id" => 654_321,
            "state" => 1,
            "state_text" => "зареєстровано",
            "code" => "code",
            "name" => "TEST"
          }
        ],
        200
      )
    end

    test "error response" do
      reason = "error reason"
      edr_api_error_expectation(reason)
      assert {:error, {:httpoison_error, reason}} = Rpc.search_legal_entity(%{code: "11111111"})
    end
  end

  describe "legal_entity_detailed_info" do
    test "success get legal entity detailed info" do
      id = 111_111

      body = %{
        "id" => id,
        "state" => 1,
        "state_text" => "зареєстровано",
        "code" => "09807750"
      }

      edr_api_expectation(:legal_entity_detailed_info, body, 200)
      assert {:ok, body} = Rpc.legal_entity_detailed_info(id)
    end

    test "invalid request params" do
      assert {:error, {:invalid_request_params, "request_param should be a binary or a integer"}} =
               Rpc.legal_entity_detailed_info(1.1)

      assert {:error, {:invalid_request_params, "request_param should be a binary or a integer"}} =
               Rpc.legal_entity_detailed_info([])
    end
  end

  describe "search_get_legal_entity_detailed_info" do
    test "success search and get legal entity detailed info" do
      body = %{"id" => 123_456}
      edr_api_expectation(:search_legal_entity, [body], 200)
      edr_api_expectation(:legal_entity_detailed_info, body, 200)
      assert {:ok, body} = Rpc.search_get_legal_entity_detailed_info(%{"code" => "11111111"})
    end
  end

  defp edr_api_expectation(fun, body, status_code) do
    expect(EdrApiMock, fun, fn _params ->
      {:ok,
       %Response{
         body: body,
         request_url: "https://example.com",
         status_code: status_code
       }}
    end)
  end

  defp edr_api_error_expectation(reason) do
    expect(EdrApiMock, :search_legal_entity, fn _params ->
      {:error,
       %Error{
         id: nil,
         reason: reason
       }}
    end)
  end
end
