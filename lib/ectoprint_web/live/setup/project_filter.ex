defmodule EctoprintWeb.SetupLive.ProjectFilterLive do
  use EctoprintWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    HI
    """
  end
end
