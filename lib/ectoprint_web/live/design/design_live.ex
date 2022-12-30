defmodule EctoprintWeb.DesignLive do
  use EctoprintWeb, :live_view

  import Ectoprint.Design

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :design ->
        cards = list_design_cards(1)

        {:noreply,
         assign(
           socket,
           cards: cards,
           pagination_page: "1"
         )}

      :pagination ->
        pagination_page = String.to_integer(params["pagination_page"])
        cards = list_design_cards(pagination_page)

        {:noreply,
         assign(
           socket,
           pagination_page: pagination_page,
           cards: cards
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>
      <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
        Fancy Design
      </span>
    </.h1>
    <div class="grid gap-5 auto-rows-5 md:grid-cols-2 lg:grid-cols-4">
      <%= for card <- @cards do %>
        <.card class="relative ">
          <div class="h-40 mb-9">
            <.card_media src={card.img_src} />
          </div>
          <div class="h-52 overflow-y-hidden mt-4 font-light text-gray-500 text-md mb-16">
            <.card_content category={card.category} heading={card.heading}>
              <%= card.description %>
            </.card_content>
          </div>
          <div class="absolute bottom-0 text-align-center w-full flex flex-row">
            <.card_footer>
              <.button to="/" label="View">
                <HeroiconsV1.Solid.eye class="w-4 h-4 mr-2" />View
              </.button>
            </.card_footer>
          </div>
        </.card>
      <% end %>
    </div>
    <div class="my-5">
      <.pagination
        link_type="live_patch"
        class="self-center justify-center w-full"
        sibling_count={3}
        path="/design/:page"
        current_page={@pagination_page}
        total_pages={13}
      />
    </div>
    """
  end
end
