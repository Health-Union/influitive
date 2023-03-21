defmodule Influitive.ReferralsTest do
  use ExUnit.Case

  alias Influitive.Referrals

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "create/1" do
    test "should hit the correct url", %{bypass: bypass} do
      create_params = %{
        "referral" => %{
          "prospect" => %{
          "first_name" => "Some",
          "last_name" => "Prospect",
          "email" => "some@prospect.com",
          "title" => "CMO"
        },
        "contact" => %{
          "first_name" => "Johnny",
          "last_name" => "Advocate",
          "email" => "johnny@advocate.com"
        },
        "campaign_id" => "98160557-5a70-4306-949e-ee8d2ea7f4b4"}
      }

      Bypass.expect(bypass, fn conn ->
        assert "/referrals" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, create_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Referrals.create(create_params)
    end
  end

  describe "advance/3" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/referrals/123/milestones/won" == conn.request_path
        assert "PUT" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, %{"feedback" => "Some feedback"}} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Referrals.advance("123", "won", "Some feedback")
    end
  end

  describe "list/3" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/referrals" == conn.request_path
        assert "GET" == conn.method
        assert %{"status_type" => "qualified"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Referrals.list(%{status_type: "qualified"})
    end
  end

  describe "get/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/referrals/123" == conn.request_path
        assert "GET" == conn.method
        assert %{} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Referrals.get(123)
    end
  end
end
