defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    gists = Gists.list_gists()

    socket = assign(socket, gists: gists)

    {:noreply, socket}
  end


  def gist(assigns) do
    ~H"""
    <div class="text-white">
      <div>
        <%= @gist.user_id%>/<%= @gist.name%>
      </div>
      <div>
        <%= @gist.updated_at %>
      </div>
      <div>
        <%= @gist.description%>
      </div>
      <div>
        <%= @gist.markup_text %>
      </div>
    </div>
    """
  end
end
