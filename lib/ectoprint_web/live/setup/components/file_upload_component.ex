defmodule EctoprintWeb.SetupLive.FileUploadComponent do
  use EctoprintWeb, :live_component
  alias Ectoprint.Projects.Project

  @impl true
  def update(%{selected_project: selected_project} = assigns, socket) do
    changeset = Project.changeset(selected_project, %{file_upload: nil})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:file, accept: :any, max_entries: 5)}
  end

  @impl true
  def handle_event("save", _project_params, socket) do
    _file_path =
      consume_uploaded_entries(socket, :file, fn %{path: path}, entry ->
        dest = Path.join("priv/static/uploads", Path.basename(entry.client_name))
        File.cp!(path, dest)

        {:ok, dest}
      end)

    # project = save_project(Map.put(project_params, :image_upload, file_path))

    {:noreply, socket |> push_patch(to: "/setup/projects")}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end
end
