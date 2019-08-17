defmodule Amiunlocked.KVDB do
  alias Amiunlocked.State

  @spec read :: {:error, String.t()} | {:ok, String.t()}
  def read() do
    case HTTPoison.get(url()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: data}} ->
        %{"state" => state, "updatedAt" => updatedAt} = Jason.decode!(data)
        state = %State{state: state, updatedAt: updatedAt}
        {:ok, state}

      {:ok, %HTTPoison.Response{body: body} = response} ->
        IO.inspect(response)
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, reason}
    end
  end

  @spec write(Amiunlocked.State.t()) :: {:error, String.t()} | {:ok, %{}}
  def write(%State{} = state) do
    stringified_json = Jason.encode!(state)
    hackney = [basic_auth: {write_key(), ""}]

    case HTTPoison.post(url(), stringified_json, [], hackney: hackney) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, %{}}

      {:ok, %HTTPoison.Response{body: body} = response} ->
        IO.inspect(response)
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, reason}
    end
  end

  @spec write_key :: String.t()
  def write_key, do: Application.fetch_env!(:amiunlocked, :kvdb)[:write_key]
  defp url, do: Application.fetch_env!(:amiunlocked, :kvdb)[:url]
end
