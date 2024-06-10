 defmodule ElixirGistWeb.GistFormComponent do
   use ElixirGistWeb, :live_component

   alias ElixirGist.{Gists, Gists.Gist}
   @spec mount(any()) :: {:ok, any()}
   def mount(socket) do

    {:ok, socket}
  end
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div>
    <.form for={@form} phx-submit={@action} phx-change="validate" phx-target={@myself} >
        <div class="justify-center px-28 w-full space-y-4 mb-10">
          <%= if @action == "update" do %>
            <.input field={@form[:id] } type="hidden"/>
          <% end %>
          <.input field={@form[:description]} placeholder="Gist description..." autocomplete="off" phx-debounce="blur"/>
          <div>
            <div class="flex p-2 items-center bg-emDark rounded-t-md border">
              <div class="w-[300px] mb-2">
                <.input field={@form[:name]} placeholder="Filename incluing extension..." autocomplete="off"  phx-debounce="blur"/>
              </div>
            </div>
            <div id="gist-wrapper-form" class="flex w-full" phx-update="ignore">
              <textarea id="line-numbers" class="line-numbers rounded-bl-md" readonly>
                <%= "1\n" %>
              </textarea>
              <div class="flex-grow">
                <.input
                  type="textarea"
                  field={@form[:markup_text]}
                  phx-hook= "UpdateLineNumbers"
                  class= "w-full rounded-br-md textarea"
                  placeholder= "Insert code..."
                  spellcheck= "false"
                  autocomplete= "false"
                  phx-debounce= "blur"
                />
              </div>
            </div>
          </div>
          <div class="flex justify-end">
            <%= if @action == "update" do %>
              <.button class="create_button" phx-disable-with="Updating...">Update gist</.button>
            <% else %>
              <.button class="create_button" phx-disable-with="Creating...">Create gist</.button>
            <%end %>
          </div>
        </div>
      </.form>
    </div>
  """
  end


  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, form: to_form(changeset))
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("update", %{"gist" => params}, socket) do
    case Gists.update_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}
      {:error, message} ->
        socket = put_flash(socket, :error, "Failed to update gist: #{message}")
        {:noreply, socket}
    end
  end
 end
