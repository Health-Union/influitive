defmodule Influitive.GroupsTest do
  use ExUnit.Case

  alias Influitive.Groups

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "members/1" do
    test "should hit the correct url", %{bypass: bypass} do
      group_uuid = "5aad58b6-9098-4f39-ab1e-f7dfdccfc27a"

      Bypass.expect(bypass, fn conn ->
        assert "/groups/#{group_uuid}/members" == conn.request_path
        assert "GET" == conn.method
        assert %{} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{"links": {}, "contacts": []}>)
      end)

      Groups.members(group_uuid)
    end
  end
end
