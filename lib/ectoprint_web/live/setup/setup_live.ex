defmodule EctoprintWeb.SetupLive do
  use EctoprintWeb, :live_view

  alias __MODULE__.FileUploadComponent
  alias __MODULE__.ProjectFilterLive
  alias __MODULE__.ProjectPreviewComponent
  alias Ectoprint.Projects
  alias Ectoprint.Projects.Project

  @impl true
  def mount(_params, _session, socket) do
    %{entries: projects} = Projects.list_projects()

    {:ok,
     socket
     |> assign(
       selected_project: nil,
       pagination_page: 1,
       loaded_projects: projects
     )}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :setup ->
        {:noreply, socket}

      :pagination ->
        pagination_page = String.to_integer(params["pagination_page"])

        %{entries: projects} = Projects.list_projects(pagination_page)

        {:noreply,
         socket
         |> assign(
           selected_project: %Project{},
           pagination_page: pagination_page,
           loaded_projects: projects
         )}

      :upload_files ->
        {:noreply,
         socket
         |> assign(selected_project: %Project{})}
    end
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    # Go back to the :index live action
    {:noreply, push_patch(socket, to: "/setup")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>
      <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
        Fancy Setup
      </span>
    </.h1>

    <%= if @live_action == :upload_files do %>
      <%= live_component(FileUploadComponent,
        id: "file-upload-component",
        selected_project: @selected_project
      ) %>
    <% end %>

    <div class="flex flex-row w-screen h-screen py-1">
      <div class="flex flex-col w-[20%] justify-items-center">
        <aside>
          <%= for project <- @loaded_projects do %>
            <%= live_component(ProjectPreviewComponent,
              id: "project-preview-component-#{project.id}",
              project: project
            ) %>
          <% end %>
          <.pagination
            link_type="live_patch"
            id="projects-pagination"
            class="my-5 justify-center"
            path={~p"/setup/projects/:page"}
            current_page={@pagination_page}
            total_pages={10}
            sibling_count={0}
            boundary_count={0}
          />
        </aside>
      </div>
      <div class="mt-5">
        <.button link_type="live_patch" label="Upload Files" to={~p"/setup/upload_files"} />
      </div>
      <div class="ml-auto w-[30%]">
        <%= live_render(@socket, ProjectFilterLive, id: "project-filter") %>
      </div>
    </div>
    """
  end
end
