defmodule AmiunlockedWeb.PageController do
  use AmiunlockedWeb, :controller
  alias Amiunlocked.{KVDB, State}

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"state" => state, "updatedAt" => updatedAt}) do
    state = %State{state: state, updatedAt: updatedAt}

    with {:ok, _} <- KVDB.write(state),
         :ok <- State.write(state) do
      render(conn, "success.json")
    end
  end
end
