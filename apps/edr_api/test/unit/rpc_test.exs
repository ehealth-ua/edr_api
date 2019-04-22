defmodule EdrApi.RpcTest do
  @moduledoc false

  use ExUnit.Case
  import Mox

  alias EdrApi.Rpc

  setup :verify_on_exit!

  describe "search_legal_entity/1" do
    test "search by passport" do
      expect(EdrApiMock, :search_legal_entity, fn _params ->
        {:ok,
         %{
           body: [
             %{
               "url" => "https://example.com",
               "id" => 123_456,
               "state" => 1,
               "state_text" => "зареєстровано",
               "passport" => "АА111111",
               "name" => "TEST"
             }
           ],
           status_code: 200
         }}
      end)

      assert {:ok,
              %{
                "id" => 123_456,
                "name" => "TEST",
                "passport" => "АА111111",
                "state" => 1,
                "state_text" => "зареєстровано",
                "url" => "https://example.com"
              }} = Rpc.search_legal_entity(%{passport: "ББ000000"})
    end

    test "search by edrpou" do
      expect(EdrApiMock, :search_legal_entity, fn _params ->
        {:ok,
         %{
           body: [
             %{
               "url" => "https://example.com",
               "id" => 123_456,
               "state" => 1,
               "state_text" => "зареєстровано",
               "passport" => "АА111111",
               "name" => "TEST"
             }
           ],
           status_code: 200
         }}
      end)

      assert {:ok,
              %{
                "id" => 123_456,
                "name" => "TEST",
                "passport" => "АА111111",
                "state" => 1,
                "state_text" => "зареєстровано",
                "url" => "https://example.com"
              }} = Rpc.search_legal_entity(%{code: "00000000"})
    end
  end

  describe "get_legal_entity_detailed_info/1" do
    test "success get legal entity detailed info" do
      body = %{
        "assignees" => [],
        "bankruptcy" => nil,
        "branches" => [],
        "code" => "some code",
        "executive_power" => nil,
        "id" => 1_111_111,
        "is_modal_statute" => false,
        "management" => "...",
        "managing_paper" => nil,
        "names" => %{
          "display" => "Some name"
        },
        "object_name" => "...",
        "olf_code" => "...",
        "olf_name" => "...",
        "predecessors" => [],
        "prev_registration_end_term" => nil,
        "state" => 1,
        "state_text" => "зареєстровано",
        "termination" => nil,
        "termination_cancel" => nil
      }

      expect(EdrApiMock, :legal_entity_detailed_info, fn _params ->
        {:ok, %{body: body, status_code: 200}}
      end)

      assert {:ok, ^body} = Rpc.get_legal_entity_detailed_info("1111111")
    end
  end
end
