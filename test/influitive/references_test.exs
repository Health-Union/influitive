defmodule Influitive.ReferencesTest do
  use ExUnit.Case

  alias Influitive.References

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "create_or_update/1" do
    test "should hit the correct url", %{bypass: bypass} do
      create_or_update_params = %{
        "crm_opportunity_id" => "",
        "prospect" => %{ "name" => "Steve", "email" => "steveo@influitive.com" },
        "account" => %{ "name" => "", "email" => "", "title" => "", "company" => "" },
        "members" => %{ "id" => "", "email" => "", "crm_contact_id" => "" },
        "advocates" => [],
        "status" => "requested",
        "close_challenge" => "false",
        "template_code" => "awesome_reference_template",
        "notes" => "This prospect is really interested in external integrations",
        "participant_limit" => "1",
        "start_at" => "YYYY-MM-DDThh:mm:ss.sTZD",
        "end_at" => "YYYY-MM-DDThh:mm:ss.sTZD"
      }

      Bypass.expect(bypass, fn conn ->
        assert "/references" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, create_or_update_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      References.create_or_update(create_or_update_params)
    end
  end

  describe "log_events/1" do
    test "should hit the correct url", %{bypass: bypass} do
      log_event_params = %{
        "type" => "site_visit",
        "member" => %{
          "id" => "123",
          "email" => "steve@advocate.ca",
          "crm_contact_id" => "0030120343feffwf0",
          "first_name" => "Steve",
          "last_name" => "Orpan"
        },
        "notes" => "completed a site visit",
        "link" => "",
        "points" => "123"
      }

      Bypass.expect(bypass, fn conn ->
        assert "/references/events" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, log_event_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      References.log_events(log_event_params)
    end
  end

  describe "completions/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/references" == conn.request_path
        assert "GET" == conn.method
        assert %{"cursor" => "1468188804-1"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      References.completions("1468188804-1")
    end
  end
end
