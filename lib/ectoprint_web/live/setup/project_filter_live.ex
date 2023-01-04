defmodule EctoprintWeb.SetupLive.ProjectFilterLive do
  use EctoprintWeb, :live_view
  alias Ecto.Changeset

  @defaults %{
    "open" => "before",
    "filters" => %{}
  }

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
        |> push_event("restore", %{key: "filters", event: "restoreSettings"})
      else
        socket
      end
      |> assign(:open, nil)
      |> assign(:filters, %{})

    {:ok, new_socket}
  end

  @impl true
  # Pushed from JS hook. Server requests it to send up any
  # stored settings for the key.
  def handle_event("restoreSettings", %{"data" => token_data, "key" => key}, socket) when is_binary(token_data) do
    socket =
      case restore_from_token(token_data) do
        {:ok, nil} ->
          # do nothing with the previous state
          socket
          |> assign(:open, socket.assigns.open)
          |> assign(:filters, socket.assigns.filters)

        {:ok, restored} ->
          socket
          |> assign(String.to_existing_atom(key), restored)


        {:error, reason} ->
          # We don't continue checking. Display error.
          # Clear the token so it doesn't keep showing an error.
          socket
          |> put_flash(:error, reason)
          |> clear_browser_storage()
      end

    {:noreply, socket}
  end

  def handle_event("restoreSettings", %{"data" => _token_data, "key" => key}, socket) do
    # No expected token data received from the client
    {:noreply, socket |> assign(String.to_existing_atom(key), @defaults[key])}
  end

  def handle_event("tab_clicked", %{"value" => tab}, socket) do
    # This represents the special state you want to store. It may come from the
    # socket.assigns. It's specific to your LiveView.
    socket =
      socket
      |> assign(:open, tab)
      |> push_event("store", %{
        key: "open",
        data: serialize_to_token(tab)
      })

    {:noreply, socket}
  end

  def handle_event("search", %{"filters" => filters}, socket) do
    # save search in local storage
    socket = socket
    |> assign(:filters, filters)
    |> push_event("store", %{
      key: "filters",
      data: serialize_to_token(filters)
    })

    # do the search
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
      <.simple_form :let={f} for={change_filters(%{}, @filters)} as={:filters} phx-change="search">
        <div>
          Last Printed
          <.container
            id="definitelyreallymain"
            phx-hook="LocalStateStore"
            id="date-filter-container"
            class="mt-10"
          >
            <.form_label form={f} field={:open} for="filters_open_before" label="Before" />
            <.radio form={f} field={:open} value="before" phx-click="tab_clicked" checked={is_active(@open, "before")} />
            <.form_label form={f} field={:open} for="filters_open_between" label="Between" />
            <.radio form={f} field={:open} value="between" phx-click="tab_clicked" checked={is_active(@open, "between")} />
            <.form_label form={f} field={:open} for="filters_open_after" label="After" />
            <.radio form={f} field={:open} value="after" phx-click="tab_clicked" checked={is_active(@open, "after")} />
          </.container>
          <%= if @open in ["after", "between"] do %>
            <.datetime_local_input form={f} field={:start_time} />
          <% end %>
          <%= if @open == "between" do %>
            <span>AND</span>
          <% end %>
          <%= if @open in ["before", "between"] do %>
            <.datetime_local_input form={f} field={:end_time} />
          <% end %>
        </div>
        <div>
          Printer Head Speed
        </div>
        <div>
          Filament Type
        </div>
      </.simple_form>
    </div>
    """
  end

  defp is_active(current, test), do: current == test

  def change_filters(%{} = filters, attrs \\ %{}) do
    types = %{
      start_time: :utc_datetime,
      end_time: :utc_datetime,
      filament_type: :string,
      printer_head_speed: :string,
    }

    {filters, types}
    |> Changeset.cast(attrs, Map.keys(types))
  end
end
