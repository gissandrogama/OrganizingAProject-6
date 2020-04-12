defmodule Organizingaproject6 do
  @moduledoc """
  Documentation for Organizingaproject6.
  """

  # @user_agent ({"KDTO"})
  
  @xml_url Application.get_env(:organizingaproject6, :xml_url)
  
  @doc """
  Hello world.

  ## Examples

      iex> Organizingaproject6.hello()
      :world

  """

  def fetch(code) do
    project_url(code)
    |> HTTPoison.get()
    |> handle_response
  end


  def project_url(code) do
    "#{@xml_url}/xml/current_obs/#{code}.xml"
  end

  def handle_response({_, %{status_code: status_code, body: body, headers: headers}}) do
    {
      status_code |> check_for_error(),
      body,
      headers
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

  def hello do
    :world
  end
end