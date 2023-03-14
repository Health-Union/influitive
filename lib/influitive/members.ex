defmodule Influitive.Members do
  @moduledoc """
  The HTTP interface for interacting with Members.
  """

  @type success_or_error :: {:ok, map()} | {:error, any()}

  alias Influitive.Http

  @doc """
  Query All Members In Your AdvocateHub
  """
  @spec list :: success_or_error
  def list(query_params \\ []) do
    Http.get("contacts", [params: query_params])
  end

  @doc """
  Get information about your API user
  """
  @spec get_own_record :: success_or_error
  def get_own_record() do
    Http.get("members/me")
  end

  @doc """
  Lookup a current member of your AdvocateHub by email
  """
  @spec find_by_email(String.t()) :: success_or_error
  def find_by_email(email) do
    Http.get("members", [params: %{email: email}])
  end

  @doc """
  Look up a current member of your AdvocateHub by their ID. Substituting the UUID for the ID also works with this endpoint.
  """
  @spec find_by_id(integer() | String.t()) :: success_or_error
  def find_by_id(id_or_uuid) do
    Http.get("members/#{id_or_uuid}")
  end

  @doc """
  This will return a list of the UUIDs of Advocates who's profile has been updated within the `past_hours` (Offset in hours from current time)
  """
  @spec recently_updated(past_hours :: integer()) :: success_or_error
  def recently_updated(past_hours) do
    Http.get("updated_contacts", [params: %{past_hours: past_hours}])
  end

  @doc """
  Create a new member in your AdvocateHub
  """
  @spec create(map()) :: success_or_error
  def create(params) do
    Http.post("members", [params: params])
  end

  @doc """
  Lock an Advocates profile identified by ID or UUID
  """
  @spec lock_profile(integer() | String.t()) :: success_or_error
  def lock_profile(id_or_uuid) do
    Http.post("members/#{id_or_uuid}/lock")
  end

  @doc """
  Lock an Advocates profile identified by ID or UUID
  """
  @spec unlock_profile(integer() | String.t()) :: success_or_error
  def unlock_profile(id_or_uuid) do
    Http.post("members/#{id_or_uuid}/unlock")
  end

  @doc """
  Send an invitation to a previously uninvited member. This endpoint will generate and return an invite link.

  Note: This will only send an invite once, if you try to repeat the call to send a second invite to a given member, it will not work
  """
  @spec send_invite(integer(), boolean()) :: success_or_error
  def send_invite(id, deliver_emails) do
    Http.post("members/#{id}/invitations", [params: %{deliver_emails: deliver_emails}])
  end

  @doc """
  To update an existing member of your AdvocateHub

  Note: Email address cannot be changed.
  Note: Name, Title, Company, CRM Contact ID, Other External IDs, and Match Criteria can be updated in this call.
  """
  @spec update(integer(), map()) :: success_or_error
  def update(id, params) do
    Http.patch("members/#{id}", [params: params])
  end

  @doc """
  Unsubscribe a member of your AdvocateHub from emails based on their email address
  """
  @spec unsubscribe(String.t()) :: success_or_error
  def unsubscribe(email) do
    Http.put("contacts/unsubscribe", %{email: email})
  end
end
