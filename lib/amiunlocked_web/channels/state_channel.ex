defmodule AmiunlockedWeb.StateChannel do
  use AmiunlockedWeb, :channel
  alias Amiunlocked.State

  def join("state", _payload, socket) do
    state = State.read()
    State.subscribe()

    {:ok, state, socket}
  end

  def handle_info({State, state}, socket) do
    broadcast!(socket, "state_change", state)

    {:noreply, socket}
  end
end
