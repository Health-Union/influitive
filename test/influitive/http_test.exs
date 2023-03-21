defmodule Influitive.HttpTest do
  use ExUnit.Case

  alias Influitive.Http

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "delete/1" do
    test "should hit the url with method DELETE", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/delete_path" == conn.request_path
        assert "DELETE" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Http.delete("delete_path")
    end
  end

  describe "post/2" do
    test "should hit the url with method POST", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/post_path" == conn.request_path
        assert "POST" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Http.post("post_path")
    end
  end

  describe "put/2" do
    test "should hit the url with method POST", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/put_path" == conn.request_path
        assert "PUT" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Http.put("put_path", %{foo: "bar"})
    end
  end

  describe "patch/2" do
    test "should hit the url with method POST", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/patch_path" == conn.request_path
        assert "PATCH" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Http.patch("patch_path", %{foo: "bar"})
    end
  end

  describe "get/2" do
    test "should hit the url with method POST", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/get_path" == conn.request_path
        assert "GET" == conn.method
        assert %{"foo" => "bar"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Http.get("get_path", [params: %{foo: "bar"}])
    end
  end

  describe "headers/0" do
    test "should set the API key and ORG_ID" do
      Application.put_env(:influitive, :api_key, "test-api-key")
      Application.put_env(:influitive, :org_id, "test-org-id")

      assert Http.headers == [
               "Authorization": "Token test-api-key",
               "X_ORG_ID": "test-org-id"
             ]

      Application.delete_env(:influitive, :api_key)
      Application.delete_env(:influitive, :org_id)
    end
  end
end
