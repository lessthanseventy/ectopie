defmodule EctoprintWeb.SetupLive.ProjectFilterLive do
  use EctoprintWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      if connected?(socket) do
        # This represents some meaningful key to your LiveView that you can
        # store and restore state using. Perhaps an ID from the page
        # the user is visiting?
        # For handle_params, it could be
        # my_storage_key = params["id"]

        socket
        # request the browser to restore any state it has for this key.
        |> push_event("restore", %{key: "open", event: "restoreSettings"})
      else
        socket
        |> assign(:open, nil)
      end

    {:ok, new_socket}
  end

  @impl true
  # Pushed from JS hook. Server requests it to send up any
  # stored settings for the key.
  def handle_event("restoreSettings", token_data, socket) when is_binary(token_data) do
    socket =
      case restore_from_token(token_data) do
        {:ok, nil} ->
          # do nothing with the previous state
          socket
          |> assign(:open, "before")

        {:ok, restored} ->
          socket
          |> assign(:open, restored)

        {:error, reason} ->
          # We don't continue checking. Display error.
          # Clear the token so it doesn't keep showing an error.
          socket
          |> put_flash(:error, reason)
          |> clear_browser_storage()
      end

    {:noreply, socket}
  end

  def handle_event("restoreSettings", _token_data, socket) do
    # No expected token data received from the client
    {:noreply, socket}
  end

  def handle_event("tab_clicked", %{"tab" => tab}, socket) do
    # This represents the special state you want to store. It may come from the
    # socket.assigns. It's specific to your LiveView.
    socket =
      socket
      |> assign(:open, tab)
      |> push_event("store", %{
        key: "open",
        data: serialize_to_token(tab)
      })
      |> IO.inspect()

    {:noreply, socket}
  end

  defp restore_from_token(token) do
    salt = Application.get_env(:ectoprint, EctoprintWeb.Endpoint)[:live_view][:signing_salt]
    # Max age is 1 day. 86,400 seconds
    case Phoenix.Token.decrypt(EctoprintWeb.Endpoint, salt, token, max_age: 86_400) do
      {:ok, data} ->
        {:ok, data}

      {:error, reason} ->
        # handles `:invalid`, `:expired` and possibly other things?
        {:error, "Failed to restore previous state. Reason: #{inspect(reason)}."}
    end
  end

  defp serialize_to_token(state_data) do
    salt = Application.get_env(:ectoprint, EctoprintWeb.Endpoint)[:live_view][:signing_salt]
    Phoenix.Token.encrypt(EctoprintWeb.Endpoint, salt, state_data)
  end

  # Push a websocket event down to the browser's JS hook.
  # Clear any settings for the current my_storage_key.
  defp clear_browser_storage(socket) do
    push_event(socket, "clear", %{key: socket.assigns.open})
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        Last Printed
        <.container
          id="definitelyreallymain"
          phx-hook="LocalStateStore"
          id="date-filter-container"
          class="mt-10"
        >
          <.tabs class="flex-col sm:flex-row">
            <.tab
              class="filter-date-tab"
              id="filter-date-tab-before"
              link_type="button"
              phx-click="tab_clicked"
              phx-value-tab="before"
              label="Before"
              is_active={is_active(assigns[:open], "before")}
            />
            <h1 id="item">BEFORE</h1>
            <.tab
              class="filter-date-tab"
              id="filter-date-tab-between"
              link_type="button"
              phx-click="tab_clicked"
              phx-value-tab="between"
              label="Between"
              is_active={is_active(assigns[:open], "between")}
            />
            <h1>BETWEEN</h1>
            <.tab
              class="filter-date-tab"
              id="filter-date-tab-after"
              link_type="button"
              phx-click="tab_clicked"
              phx-value-tab="after"
              label="After"
              is_active={is_active(assigns[:open], "after")}
            />
            <h1>AFTER</h1>
          </.tabs>
        </.container>
      </div>
      <div>
        Printer Head Speed
      </div>
      <div>
        Filament Type
      </div>
    </div>
    """
  end

  defp is_active(current, test), do: current == test
end
