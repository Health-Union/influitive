defmodule RewardsTest do
  use ExUnit.Case, async: true

  alias Influitive.Rewards

  setup do
    bypass = Bypass.open()
    Application.put_env(:influitive, :api_endpoint, "http://localhost:#{bypass.port}/")

    on_exit(:clear_config, fn ->
      Application.delete_env(:influitive, :api_endpoint)
    end)

    {:ok, bypass: bypass}
  end

  describe "Rewards.list" do
    test "correctly parse success response", %{bypass: bypass} do
      mocked_response = ~s<[{"uuid":"afbcc0a4-f025-414e-91e5-35e430f4e72c","provider":"robert","published":"true"}]>
      mock_success(bypass, "GET", "external/rewards", mocked_response)

      expected_response = {:ok, [
        %{
          "provider" => "robert",
          "published" => "true",
          "uuid" => "afbcc0a4-f025-414e-91e5-35e430f4e72c"
        }
      ]}

      assert expected_response == Rewards.list()
    end
  end

  describe "Rewards.reward_redemptions" do
    test "correctly handle 200 response", %{bypass: bypass} do
      mocked_response = ~s<{"reward_redemptions": [], "contacts": []}>
      mock_success(bypass, "GET", "reward_redemptions", mocked_response)

      expected_response = {:ok,
        %{
          "reward_redemptions" => [],
          "contacts" => []
        }
      }

      assert expected_response == Rewards.reward_redemptions()
    end
  end

  defp mock_success(bypass, method, url, response) do
    Bypass.expect(bypass, method, url, fn conn ->
      Plug.Conn.resp(conn, 200, response)
    end)
  end
end
