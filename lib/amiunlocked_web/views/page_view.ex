defmodule AmiunlockedWeb.PageView do
  use AmiunlockedWeb, :view

  def render("success.json", _) do
    %{
      success: true
    }
  end
end
