defmodule Influitive.MessagesTest do
  use ExUnit.Case

  alias Influitive.Messages

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "send/3" do
    test "should hit the correct url", %{bypass: bypass} do
      message_params = %{
        "message" => "My first API message",
        "sender_uuid" => "69e5657b-f7cc-4d2a-b64f-64dc14cc755c",
        "recipient_uuid" => "c3f24a2e-4f64-4295-b213-37c4b4b03f80"
      }

      Bypass.expect(bypass, fn conn ->
        assert "/messages/send" == conn.request_path
        assert "POST" == conn.method

        {_status, body, _conn} = Plug.Conn.read_body(conn)
        assert {:ok, message_params} == Jason.decode(body)

        Plug.Conn.resp(conn, 200, ~s<{}>)
      end)

      Messages.send(
        message_params["message"],
        message_params["sender_uuid"],
        message_params["recipient_uuid"]
      )
    end
  end
end
