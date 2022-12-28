defmodule EctoprintWeb.NavigationLive do
  use EctoprintWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "", inner_liveview: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-screen px-2 py-8 mx-4 overflow-y-auto border-r">
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
    """
  end
end
