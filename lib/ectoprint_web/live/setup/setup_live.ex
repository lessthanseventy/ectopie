defmodule EctoprintWeb.SetupLive do
  use EctoprintWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do

    # Go back to the :index live action
    {:noreply, push_patch(socket, to: "/")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mt-9 w-full p-14">
      <.h1>
        <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
          Fancy Setup
        </span>
      </.h1>
      <.button type="live_patch" to="/setup/modal" label="Upload Files"/>
      <%= if @live_action == :modal do %>
      <.modal title="Modal" close_modal_target={@myself}>
        <.p>Content</.p>
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
    </div>
    """
  end
end
