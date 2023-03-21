defmodule Influitive.ConfigTest do
  use ExUnit.Case

  alias Influitive.Config

  describe "api_key/0" do
    test "should update api_key" do
      Application.put_env(:influitive, :api_key, "test-api-key")
      assert Config.api_key() == "test-api-key"
      Application.delete_env(:influitive, :api_key)
    end
  end

  describe "org_id/0" do
    test "should update org_id" do
      Application.put_env(:influitive, :org_id, "test-org-id")
      assert Config.org_id() == "test-org-id"
      Application.delete_env(:influitive, :org_id)
    end
  end

  describe "api_endpoint/0" do
    test "should have a default endpoint" do
      assert Config.api_endpoint() == "https://api.influitive.com"
    end

    test "should update the default endpoint" do
      Application.put_env(:influitive, :api_endpoint, "api.influitive.local")
      assert Config.api_endpoint() == "api.influitive.local"
      Application.delete_env(:influitive, :api_endpoint)
    end
  end
end
