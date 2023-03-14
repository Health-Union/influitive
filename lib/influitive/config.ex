defmodule Influitive.Config do
  @moduledoc """
  Configuration helper.
  """

  def api_key do
    Application.get_env(
      :active_campaign,
      :api_key
    )
  end

  def org_id do
    Application.get_env(
      :active_campaign,
      :org_id
    )
  end

  def api_url do
    "https://api.influitive.com"
  end

  def json_library do
    Application.get_env(:active_campaign, :json_library, Jason)
  end
end
