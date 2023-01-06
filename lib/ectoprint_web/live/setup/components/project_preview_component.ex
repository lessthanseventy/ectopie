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
    <div id={"project-preview-component-#{@project.id}"} class="mb-4">
      <div><%= @project.description %></div>
      <div><%= @project.last_printed %></div>
      <div><%= @project.filament_type %></div>
      <div><%= @project.printer_head_speed %></div>
      <div><%= @project.file_upload %></div>
      <div class="mt-5 hidden">
        <.button link_type="live_patch" label="Upload Files" to={~p"/setup/upload_files/#{@project.id}"} />
      </div>
    </div>
    """
  end
end
