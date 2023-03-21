defmodule Influitive.MembersTest do
  use ExUnit.Case

  alias Influitive.Members

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "list/1" do
    test "should call the correct url with correct query params", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/contacts" == conn.request_path
        assert "GET" == conn.method
        assert %{"company" => "Foo Bar"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{"contacts": []}>)
      end)

      Members.list(%{company: "Foo Bar"})
    end
  end

  describe "get_own_record/0" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/members/me" == conn.request_path
        assert "GET" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{"id": 1, "email": "foo@bar.com"}>)
      end)

      Members.get_own_record()
    end
  end

  describe "find_by_email/1" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/members" == conn.request_path
        assert "GET" == conn.method
        assert %{"email" => "foo@bar.com"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<{"id": 1, "email": "foo@bar.com"}>)
      end)

      Members.find_by_email("foo@bar.com")
    end
  end

  describe "find_by_id/1" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/members/123" == conn.request_path
        assert "GET" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{"id": 123, "email": "bar@baz.com"}>)
      end)

      Members.find_by_id("123")
    end
  end

  describe "recently_updated/1" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/updated_contacts" == conn.request_path
        assert "GET" == conn.method
        assert %{"past_hours" => "4"} == conn.params

        Plug.Conn.resp(conn, 200, ~s<["6dd6afb4-85f4-4bf1-aef0-3678aa957594"]>)
      end)

      Members.recently_updated(4)
    end
  end

  describe "create/1" do
    test "should call the correct url", %{bypass: bypass} do
      create_params = %{
        "email" => "test+create@influitive.com",
        "name" => "Bobby Mac",
        "source" => "External Provider",
        "title" => "Product Manager",
        "company" => "Influitive",
        "salesforce_id" => "00300N0ef032r323",
        "match_criteria" => %{},
        "type" => "Nominee"
      }

      Bypass.expect(bypass, fn conn ->
        assert "/members" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, create_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{"success": "ok"}>)
      end)

      Members.create(create_params)
    end
  end

  describe "lock_profile/1" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/members/123/lock" == conn.request_path
        assert "POST" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{"success": "ok"}>)
      end)

      Members.lock_profile(123)
    end
  end

  describe "unlock_profile/1" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/members/123/unlock" == conn.request_path
        assert "POST" == conn.method

        Plug.Conn.resp(conn, 200, ~s<{"success": "ok"}>)
      end)

      Members.unlock_profile(123)
    end
  end

  describe "send_invite/2" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/members/123/invitations" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, %{"deliver_emails" => true}} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{"success": "ok"}>)
      end)

      Members.send_invite(123, true)
    end
  end

  describe "update/2" do
    test "should call the correct url", %{bypass: bypass} do
      update_params = %{
        "title" => "CEO",
        "company" => "Incorprated Inc.",
      }

      Bypass.expect(bypass, fn conn ->
        assert "/members/123" == conn.request_path
        assert "PATCH" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, update_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{"id": 123, "first_name": "Teresa", "last_name": "Test", "title": "CEO", "company": "Incorprated Inc.">)
      end)

      Members.update(123, update_params)
    end
  end

  describe "unsubscribe/1" do
    test "should call the correct url", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "/contacts/unsubscribe" == conn.request_path
        assert "PUT" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, %{"email" => "foo@bar.com"}} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{"data": null}>)
      end)

      Members.unsubscribe("foo@bar.com")
    end
  end
end
