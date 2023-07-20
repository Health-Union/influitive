defmodule Influitive.ChallengesTest do
  use ExUnit.Case

  alias Influitive.Challenges

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "awaiting_approval/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/approvals" == conn.request_path
        assert "GET" == conn.method
        assert %{} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Challenges.awaiting_approval()
    end
  end

  describe "approvals/3" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/approvals/1/decision/approve" == conn.request_path
        assert "POST" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Challenges.approvals(1, "approve")
    end
  end

  describe "archive/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/challenges/1/archive" == conn.request_path
        assert "POST" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{"status": "ok"}>)
      end)

      Challenges.archive(1)
    end
  end

  describe "publish/2" do
    test "should hit the correct url", %{bypass: bypass} do
      body_params = %{
        "start_at" => "2022-04-06T15:36:09Z",
        "end_at" => "2022-04-06T15:37:09Z",
        "participant_limit" => "3"
      }

      Bypass.expect(bypass, fn conn ->
        assert "/challenges/1/publish" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, body_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{"status": "ok"}>)
      end)

      Challenges.publish(1, body_params)
    end
  end

  describe "unpublish/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/challenges/1/unpublish" == conn.request_path
        assert "POST" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{"status": "ok"}>)
      end)

      Challenges.unpublish(1)
    end
  end

  describe "create_by_template/1" do
    test "should hit the correct url", %{bypass: bypass} do
      body_params = %{
        "template_code" => "templatecode123",
        "headline" => "Challenge Headline",
        "description" => "Challenge description",
        "notes" => "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
        "advocates" => [
          %{
            "id" => "13",
            "email" => "tmp@gmail.com",
            "crm_contact_id" => 1234,
            "first_name" => "foo",
            "last_name" => "bar"
          }
        ],
        "group_uuids" => [
          "5aad58b6-9098-4f39-ab1e-f7dfdccfc27a",
          "5aad58b6-9098-4f39-ab1e-fgdfd8gfdgfd"
        ]
      }

      Bypass.expect(bypass, fn conn ->
        assert "/challenges/create_by_template" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, body_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{"status": "ok"}>)
      end)

      Challenges.create_by_template(body_params)
    end
  end

  describe "get/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/challenges/5dba58c6-9748-4f39-ab1e-fgdffdgfdd8g/details" == conn.request_path
        assert "GET" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Challenges.get("5dba58c6-9748-4f39-ab1e-fgdffdgfdd8g")
    end
  end

  describe "get_additional_details/1" do
    test "should hit the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/challenges/5dba58c6-9748-4f39-ab1e-fgdffdgfdd8g" == conn.request_path
        assert "GET" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Challenges.get_additional_details("5dba58c6-9748-4f39-ab1e-fgdffdgfdd8g")
    end
  end
end
