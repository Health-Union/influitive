defmodule Influitive.AdvocateAnywhereTest do
  use ExUnit.Case

  alias Influitive.AdvocateAnywhere

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "challenges/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/embedded/challenges" == conn.request_path
        assert "GET" == conn.method
        assert %{"challenge_ids" => "1, 2, 3"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{"challenges": []}>)
      end)

      AdvocateAnywhere.challenges(%{challenge_ids: "1, 2, 3"})
    end
  end

  describe "identify/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/embedded/contacts/identify" == conn.request_path
        assert "GET" == conn.method
        assert %{"email" => "tmp@gmail.com"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      AdvocateAnywhere.identify(%{email: "tmp@gmail.com"})
    end
  end

  describe "submit_challenges/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/embedded/challenges" == conn.request_path
        assert "GET" == conn.method
        assert %{"foo" => "bar"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      AdvocateAnywhere.submit_challenges(%{foo: "bar"})
    end
  end
end
