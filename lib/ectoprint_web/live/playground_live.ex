defmodule EctoprintWeb.PlaygroundLive do
  use EctoprintWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       pagination_page: 1,
       active_tab: :live
     )}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :live ->
        {:noreply, assign(socket, modal: false, slide_over: false)}

      :modal ->
        {:noreply, assign(socket, modal: params["size"])}

      :slide_over ->
        {:noreply, assign(socket, slide_over: params["origin"])}

      :pagination ->
        {:noreply, assign(socket, pagination_page: String.to_integer(params["page"]))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container class="mt-10 mb-32 self-center">
      <.h2 class="underline text-center">
        <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
          Component Playground
        </span>
      </.h2>
      <.tabs class="!gap-x-4">
        <.tab link_type="a" is_active={@active_tab == :home} to="/playground" label="Components" />
        <.tab
          link_type="a"
          is_active={@active_tab == :live}
          to="/playground/live"
          label="Live Components"
        />
      </.tabs>

      <.h2 underline class="mt-10" label="Color Scheme Switcher" />
      <.color_scheme_switch />

      <.h2 underline class="mt-10" label="Dropdowns" />
      <.h3 label="" />
      <.dropdown label="Dropdown" js_lib="live_view_js">
        <.dropdown_menu_item type="button">
          <HeroiconsV1.Outline.home class="w-5 h-5 text-gray-500 dark:text-gray-300" />
          Button item with icon
        </.dropdown_menu_item>
        <.dropdown_menu_item type="a" to="/playground" label="a item" />
        <.dropdown_menu_item type="live_patch" to="/playground" label="Live Patch item" />
        <.dropdown_menu_item type="live_redirect" to="/playground" label="Live Redirect item" />
      </.dropdown>

      <.h2 underline class="mt-10" label="Modal" />

      <.button label="sm" link_type="live_patch" to={~p"/playground/live/modal/sm"} />
      <.button label="md" link_type="live_patch" to={~p"/playground/live/modal/md"} />
      <.button label="lg" link_type="live_patch" to={~p"/playground/live/modal/lg"} />
      <.button label="xl" link_type="live_patch" to={~p"/playground/live/modal/xl"} />
      <.button label="2xl" link_type="live_patch" to={~p"/playground/live/modal/2xl"} />
      <.button label="full" link_type="live_patch" to={~p"/playground/live/modal/full"} />

      <%= if @modal do %>
        <.modal max_width={@modal} phx-click-away="close_modal" title="Modal">
          <div class="gap-5 text-sm">
            <.form_label label="Add some text here." />
            <div class="flex justify-end">
              <.button label="close" phx-click={PetalComponents.Modal.hide_modal()} />
            </div>
          </div>
        </.modal>
      <% end %>

      <.h2 underline class="mt-10" label="SlideOver" />

      <.button label="left" link_type="live_patch" to={~p"/playground/live/slide_over/left"} />
      <.button label="top" link_type="live_patch" to={~p"/playground/live/slide_over/top"} />
      <.button label="right" link_type="live_patch" to={~p"/playground/live/slide_over/right"} />
      <.button label="bottom" link_type="live_patch" to={~p"/playground/live/slide_over/bottom"} />

      <%= if @slide_over do %>
        <.slide_over phx-click-away="close_slide_over" origin={@slide_over} title="SlideOver">
          <div class="gap-5 text-sm">
            <.form_label label="Add some text here." />
            <div class="flex justify-end">
              <.button
                label="close"
                phx-click={PetalComponents.SlideOver.hide_slide_over(@slide_over)}
              />
            </div>
          </div>
        </.slide_over>
      <% end %>

      <.h2 underline class="mt-10" label="Interactive Pagination" />
      <.pagination
        link_type="live_patch"
        path="/playground/live/pagination/:page"
        current_page={@pagination_page}
        total_pages={10}
      />

      <.h2 underline class="mt-10" label="Accordion" />
      <.accordion js_lib="live_view_js">
        <:item heading="Accordion">
          <.p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis. Ut enim ad minim veniam quis. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </.p>
        </:item>
        <:item heading="Accordion 2">
          <.p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis. Ut enim ad minim veniam quis. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </.p>
        </:item>
        <:item heading="Accordion 3">
          <.p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis. Ut enim ad minim veniam quis. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </.p>
        </:item>
      </.accordion>
    </.container>
    """
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/playground/live")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/playground/live")}
  end
end
