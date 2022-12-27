defmodule EctoprintWeb.NavigationLive do
  use EctoprintWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, page_title: "", inner_liveview: nil)}

      :design ->
        {:noreply,
         assign(
           socket,
           page_title: "Design Page",
           inner_liveview: EctoprintWeb.DesignLive
         )}

      :setup ->
        {:noreply,
         assign(
           socket,
           page_title: "Setup Page",
           inner_liveview: EctoprintWeb.SetupLive
         )}

      :control ->
        {:noreply,
         assign(
           socket,
           page_title: "Control Page",
           inner_liveview: EctoprintWeb.ControlLive
         )}

      :monitor ->
        {:noreply,
         assign(
           socket,
           page_title: "Monitor Page",
           inner_liveview: EctoprintWeb.MonitorLive
         )}

      :review ->
        {:noreply,
         assign(
           socket,
           page_title: "Review Page",
           inner_liveview: EctoprintWeb.ReviewLive
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex w-full">
      <div class="flex flex-col w-64 h-screen px-4 py-8 overflow-y-auto border-r">
        <h2 class="text-3xl font-semibold text-center text-blue-800">Logo</h2>

        <div class="flex flex-col justify-between mt-6">
          <aside>
            <ul>
              <li>
                <.a
                  link_type="live_patch"
                  to="/design"
                  class="flex items-center px-4 py-2 mt-5 text-gray-600 rounded-md hover:bg-gray-200"
                >
                  <Heroicons.pencil class="w-6 h-6 rotate-90 text-secondary-500" />
                  <span class="mx-4 font-medium">Design</span>
                </.a>
              </li>

              <li>
                <.a
                  link_type="live_patch"
                  to="/setup"
                  class="flex items-center px-4 py-2 mt-5 text-gray-600 rounded-md hover:bg-gray-200"
                >
                  <Heroicons.squares_plus class="w-6 h-6 rotate-90 text-secondary-500" />
                  <span class="mx-4 font-medium">Setup</span>
                </.a>
              </li>

              <li>
                <.a
                  link_type="live_patch"
                  to="/control"
                  class="flex items-center px-4 py-2 mt-5 text-gray-600 rounded-md hover:bg-gray-200"
                >
                  <Heroicons.wrench_screwdriver class="w-6 h-6 rotate-90 text-secondary-500" />
                  <span class="mx-4 font-medium">Control</span>
                </.a>
              </li>

              <li>
                <.a
                  link_type="live_patch"
                  to="/monitor"
                  class="flex items-center px-4 py-2 mt-5 text-gray-600 rounded-md hover:bg-gray-200"
                >
                  <Heroicons.magnifying_glass_plus class="w-6 h-6 rotate-90 text-secondary-500" />
                  <span class="mx-4 font-medium">Monitor</span>
                </.a>
              </li>

              <li>
                <.a
                  link_type="live_patch"
                  to="/review"
                  class="flex items-center px-4 py-2 mt-5 text-gray-600 rounded-md hover:bg-gray-200"
                >
                  <Heroicons.megaphone class="w-6 h-6 rotate-90 text-secondary-500" />
                  <span class="mx-4 font-medium">Review</span>
                </.a>
              </li>
            </ul>
          </aside>
        </div>
      </div>
      <div class="flex flex-col self-start">
        <div class="mt-6 ml-6">
          <%= @page_title %>
        </div>
        <div class="mt-6 ml-6">
          <%= if @inner_liveview do %>
            <%= live_render(@socket, @inner_liveview, id: @inner_liveview) %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
