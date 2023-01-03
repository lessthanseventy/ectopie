defmodule EctoprintWeb.SetupLive.ProjectFilterLive do
  use EctoprintWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:open, "before")}
  end

  def handle_event("sessionSet", %{value: value}, socket) do
    IO.inspect(value)
    {:noreply, socket |> assign(:open, value)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div x-data="{ title: 'Start Here Now' }">
        <h1 x-text="title"></h1>
      </div>
      <div>
        Last Printed
        <.container id="date-filter-container" class="mt-10">
          <.tabs phx-mounted={set_tab()} class="flex-col sm:flex-row">
            <.tab class="filter-date-tab" id="filter-date-tab-before" link_type="button" phx-click={select_tab("before")} label="Before" is_active={is_active(@open, "before")} />
            <.tab class="filter-date-tab" id="filter-date-tab-between" link_type="button" phx-click={select_tab("between")} label="Between" is_active={is_active(@open, "between")} />
            <.tab class="filter-date-tab" id="filter-date-tab-after" link_type="button" phx-click={select_tab("after")} label="After" is_active={is_active(@open, "after")}  />
          </.tabs>
        </.container>
        <h1 id="item" x-show="open == 'before'">BEFORE</h1>
        <h1 x-show="open == 'between'">BETWEEN</h1>
        <h1 x-show="open == 'after'">AFTER</h1>
        <h2 x-text="open"></h2>
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

  defp select_tab(tab) do
    JS.dispatch("setSessionItem", detail: %{key: "open", value: tab})

  end

  defp set_tab() do
    JS.dispatch("getSessionItem", detail: %{key: "open"})
  end

  defp is_active(current, test), do: current == test
end
