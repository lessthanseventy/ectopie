defmodule EctoprintWeb.SetupLive do
  use EctoprintWeb, :live_view

  alias Ectoprint.Setup.Files

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :setup ->
        {:noreply, assign(socket, modal: false, slide_over: false)}

      :upload_files ->
        changeset = Files.changeset(%Files{}, %{})

        {:noreply,
         socket
         |> allow_upload(:files, accept: :any, max_entries: 5)
         |> assign(changeset: changeset)}

      :preview_and_save_files ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    # Go back to the :index live action
    {:noreply, push_patch(socket, to: "/setup")}
  end

  @impl true
  def handle_event("submit_preview", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :files, fn %{path: path} = args, entry ->
        dest =
          Path.join([
            "/home/andrew/projects/ectoprint/",
            "priv",
            "static",
            "uploads",
            Path.basename(entry.client_name)
          ])

        File.cp!(path, dest)
        {:ok, dest}
      end)

    {:noreply,
     socket
     |> assign(:uploaded_files, uploaded_files)
     |> push_patch(to: "/setup/preview_and_save_files")}
  end

  @impl true
  def handle_event("save_files", _params, %{assigns: %{uploaded_files: uploaded_files}} = socket) do
    {:noreply,
     socket
     |> push_patch(to: "/setup")}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>
      <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
        Fancy Setup
      </span>
    </.h1>
    <.button link_type="live_patch" label="Upload Files" to={~p"/setup/upload_files"} />

    <%= if @live_action == :upload_files do %>
      <.modal max_width="md" title="Modal">
        <form id="upload-form" phx-submit="submit_preview" phx-change="validate">
          <.live_file_input upload={@uploads.files} />
          <button type="submit">Upload</button>
        </form>
      </.modal>
    <% end %>

    <%= if @live_action == :preview_and_save_files do %>
      <.modal max_width="md" title="Modal">
        <%= if assigns[:uploads] do %>
          <%= for entry <- @uploads.files do %>
            <article class="upload-entry">
              <%= entry.client_name %>
            </article>
          <% end %>
        <% end %>
        <form id="sumbit-form" phx-submit="save_files" phx-change="validate">
          <button type="submit">Save</button>
        </form>
      </.modal>
    <% end %>

    <.table class="mt-5">
      <.tr>
        <.th>File Name</.th>
        <.th>Size</.th>
        <.th>Date Uploaded</.th>
        <.th></.th>
      </.tr>

      <.tr>
        <.td>
          Cat_file_103.cd
        </.td>
        <.td>20gb</.td>
        <.td>02/03/04</.td>
        <.td class="float-right flex">
          <HeroiconsV1.Solid.folder class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.bookmark class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.trash class="w-6 h-6 text-secondary-500" />
        </.td>
      </.tr>

      <.tr>
        <.td>Cat_file_109.cd</.td>
        <.td>20gb</.td>
        <.td>02/03/04</.td>
        <.td class="float-right flex">
          <HeroiconsV1.Solid.folder class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.bookmark class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.trash class="w-6 h-6 text-secondary-500" />
        </.td>
      </.tr>

      <.tr>
        <.td>Cat_file_223.cd</.td>
        <.td>20gb</.td>
        <.td>02/03/04</.td>
        <.td class="float-right flex">
          <HeroiconsV1.Solid.folder class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.bookmark class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.trash class="w-6 h-6 text-secondary-500" />
        </.td>
      </.tr>

      <.tr>
        <.td>Cat_file_143.cd</.td>
        <.td>20gb</.td>
        <.td>02/03/04</.td>
        <.td class="float-right flex">
          <HeroiconsV1.Solid.folder class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.bookmark class="w-6 h-6 text-secondary-500" />
          <HeroiconsV1.Solid.trash class="w-6 h-6 text-secondary-500" />
        </.td>
      </.tr>
    </.table>
    """
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
