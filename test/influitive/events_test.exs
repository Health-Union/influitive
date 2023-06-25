defmodule Influitive.EventsTest do
  use ExUnit.Case

  alias Influitive.Events

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "list/1" do
    test "should hit the correct url", %{bypass: bypass} do
      query_params = %{
        "start_at" => "2022-04-06T15:36:09Z",
        "end_at" => "2022-04-06T15:37:09Z"
      }

      Bypass.expect(bypass, fn conn ->
        assert "/events" == conn.request_path
        assert "GET" == conn.method
        assert query_params == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Events.list(query_params)
    end
  end

  describe "log/1" do
    test "should hit the correct url", %{bypass: bypass} do
      body_params = %{
        "type" => "custom_event_api_code",
        "contact" => %{
          "id" => "",
          "email" => "steveadvocate@acme.com"
        }
      }

      Bypass.expect(bypass, fn conn ->
        assert "/events" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, body_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Events.log(body_params)
    end
  end
end
