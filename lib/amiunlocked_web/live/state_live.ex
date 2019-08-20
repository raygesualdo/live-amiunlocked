defmodule AmiunlockedWeb.StateLive do
  use Phoenix.LiveView
  alias Amiunlocked.State

  def render(assigns) do
    ~L"""
    <main class="<%= body_class(@state) %>">
      <div>Your computer is</div>
      <div id="state"><%= text(@state) %></div>
      <div id="updated-at"><%= format_date(@updated_at) %></div>
    </main>
    """
  end

  def mount(_session, socket) do
    State.subscribe()
    state = State.read()

    {:ok, assign(socket, state: state.state, updated_at: state.updatedAt)}
  end

  def handle_info({State, state}, socket) do
    {:noreply, assign(socket, state: state.state, updated_at: state.updatedAt)}
  end

  defp body_class(state) when state in ["locked", "unlocked"], do: state
  defp body_class(_state), do: ""
  defp text(state) when state in ["locked", "unlocked"], do: state
  defp text(_state), do: "Schrödinger's cat"

  @date_format "{Mfull} {D}, {YYYY}, {h12}:{m}:{s} {AM}"

  defp format_date(""), do: ""

  defp format_date(date) do
    with {:ok, iso_date} <- Timex.parse(date, "{ISO:Extended}"),
         local_date <- Timex.Timezone.convert(iso_date, Timex.Timezone.Local.lookup()),
         {:ok, formatted_date} <- Timex.format(local_date, @date_format) do
      "Updated " <> formatted_date
    end
  end
end
