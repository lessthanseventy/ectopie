defmodule EctoprintWeb.SetupLive.ProjectPreviewComponent do
  use EctoprintWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={"project-preview-component-#{@project.id}"}>
      <%= @project.description %>
      <%= @project.file_upload %>
    </div>
    """
  end
end
