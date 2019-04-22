defmodule EdrApiTest do
  @moduledoc false

  use ExUnit.Case
  import Mox

  alias EdrApi.Rpc

  setup :verify_on_exit!

  describe "legal_entity_by_code" do
    test "success get legal entity info by code" do
      code = "11111111"
      id = 123_456

      body = [
        %{
          "url" => "https://example.com",
          "id" => id,
          "state" => 1,
          "state_text" => "зареєстровано",
          "code" => code,
          "name" => "TEST"
        }
      ]

      edr_api_expectation(:search_legal_entity, body, 200)
      edr_api_expectation(:legal_entity_detailed_info, body, 200)
      assert {:ok, %{"id" => ^id}} = Rpc.legal_entity_by_code(code)
    end

    test "invalid request params" do
      assert {:error, "code request param should be a binary"} = Rpc.legal_entity_by_code(11_111_111)
      assert {:error, reason} = Rpc.legal_entity_by_code("test")
      assert reason =~ "code request param should match"
    end

    test "invalid response status code" do
      edr_api_expectation(:search_legal_entity, "body", 403)
      assert {:error, %{"status_code" => 403, "body" => "body"}} = Rpc.legal_entity_by_code("11111111")
    end

    test "invalid response body: empty binary" do
      edr_api_expectation(:search_legal_entity, "", 200)
      assert {:error, "Invalid response body"} = Rpc.legal_entity_by_code("11111111")
    end

    test "invalid response body: binary" do
      edr_api_expectation(:search_legal_entity, "body", 200)
      assert {:error, "Response body parse error: body"} = Rpc.legal_entity_by_code("11111111")
    end

    test "invalid response body: empty list" do
      edr_api_expectation(:search_legal_entity, [], 200)

      assert {:error, %{"body" => "Legal entity not found", "status_code" => 400}} =
               Rpc.legal_entity_by_code("11111111")
    end

    test "invalid response body: list with more than one item" do
      edr_api_expectation(
        :search_legal_entity,
        [
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

      assert {:error, %{"body" => "Too many legal entities found", "status_code" => 400}} =
               Rpc.legal_entity_by_code("11111111")
    end

    test "error response" do
      reason = "error reason"
      edr_api_error_expectation(reason)
      assert {:error, reason} = Rpc.legal_entity_by_code("11111111")
    end
  end

  describe "legal_entity_by_passport" do
    test "success get legal entity info by passport" do
      passport = "АА111111"
      id = 123_456

      body = [
        %{
          "url" => "https://example.com",
          "id" => id,
          "state" => 1,
          "state_text" => "зареєстровано",
          "passport" => passport,
          "name" => "TEST"
        }
      ]

      edr_api_expectation(:search_legal_entity, body, 200)
      edr_api_expectation(:legal_entity_detailed_info, body, 200)
      assert {:ok, %{"id" => ^id}} = Rpc.legal_entity_by_passport(passport)
    end

    test "invalid request params" do
      assert {:error, "passport request param should be a binary"} = Rpc.legal_entity_by_passport(11_111_111)
      assert {:error, reason} = Rpc.legal_entity_by_passport("test")
      assert reason =~ "passport request param should match"
    end

    test "invalid response status code" do
      passport = "АА111111"
      id = 123_456

      body = [
        %{
          "url" => "https://example.com",
          "id" => id,
          "state" => 1,
          "state_text" => "зареєстровано",
          "passport" => passport,
          "name" => "TEST"
        }
      ]

      edr_api_expectation(:search_legal_entity, body, 200)
      edr_api_expectation(:legal_entity_detailed_info, "body", 403)
      assert {:error, %{"status_code" => 403, "body" => "body"}} = Rpc.legal_entity_by_passport(passport)
    end

    test "invalid response body: empty binary" do
      edr_api_search_legal_entity_expectation()
      edr_api_expectation(:legal_entity_detailed_info, "", 200)
      assert {:error, "Invalid response body"} = Rpc.legal_entity_by_passport("АА111111")
    end

    test "invalid response body: binary" do
      edr_api_search_legal_entity_expectation()
      edr_api_expectation(:legal_entity_detailed_info, "body", 200)
      assert {:error, "Response body parse error: body"} = Rpc.legal_entity_by_passport("АА111111")
    end

    test "invalid response body: empty list" do
      edr_api_search_legal_entity_expectation()
      edr_api_expectation(:legal_entity_detailed_info, [], 200)

      assert {:error, %{"body" => "Legal entity not found", "status_code" => 400}} =
               Rpc.legal_entity_by_passport("АА111111")
    end

    test "invalid response body: list with more than one item" do
      edr_api_search_legal_entity_expectation()

      edr_api_expectation(
        :legal_entity_detailed_info,
        [
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

      assert {:error, %{"body" => "Too many legal entities found", "status_code" => 400}} =
               Rpc.legal_entity_by_passport("АА111111")
    end

    test "error response" do
      reason = "error reason"
      edr_api_error_expectation(reason)
      assert {:error, reason} = Rpc.legal_entity_by_code("11111111")
    end
  end

  defp edr_api_expectation(fun, body, status_code) do
    expect(EdrApiMock, fun, fn _params ->
      {:ok, %{body: body, status_code: status_code}}
    end)
  end

  defp edr_api_error_expectation(reason) do
    expect(EdrApiMock, :search_legal_entity, fn _params ->
      {:error, reason}
    end)
  end

  defp edr_api_search_legal_entity_expectation do
    edr_api_expectation(
      :search_legal_entity,
      [
        %{
          "url" => "https://example.com",
          "id" => 123_456,
          "state" => 1,
          "state_text" => "зареєстровано",
          "passport" => "АА111111",
          "name" => "TEST"
        }
      ],
      200
    )
  end
end
