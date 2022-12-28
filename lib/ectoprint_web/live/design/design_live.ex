defmodule EctoprintWeb.DesignLive do
  use EctoprintWeb, :live_view

  import Ectoprint.Design

  @impl true
  def mount(_params, _session, socket) do
    {cards, metadata} = list_design_cards() |> IO.inspect(label: "\n\n\n\n\n\n")

    {:ok,
     socket
     |> assign(
       cards: cards,
       cards_metadata: metadata,
       pagination_page: 1
     )}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :design ->
        {:noreply,
         assign(
           socket,
           page_title: "Design Page",
           pagination_page: "1"
         )}

      :pagination ->
        {cards, metadata} = list_design_cards(socket.assigns.cards_metadata.after)

        {:noreply,
         assign(
           socket,
           pagination_page: String.to_integer(params["pagination_page"]),
           cards: cards,
           cards_metadata: metadata
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-between h-full w-full">
      <div class="grid gap-5 mt-5 md:grid-cols-2 lg:grid-cols-4">
        <%= for card <- @cards do %>
          <.card>
            <.card_media src={card.img_src} />
            <.card_content category={card.category} heading={card.heading}>
              <div class="mt-4 font-light text-gray-500 text-md">
                <%= card.description %>
              </div>
            </.card_content>
            <.card_footer>
              <.button to="/" label="View">
                <HeroiconsV1.Solid.eye class="w-4 h-4 mr-2" />View
              </.button>
            </.card_footer>
          </.card>
        <% end %>
      </div>
      <div class="w-1/2 self-center flex justify-center">
        <.pagination
          link_type="live_patch"
          class="w-1/2"
          path="/design/:page"
          current_page={@pagination_page}
          total_pages={10}
        />
      </div>
    </div>
    """
  end
end
