defmodule ConstrutoraLcHiertWeb.Admin.PropertyController do
  use ConstrutoraLcHiertWeb, :controller

  alias ConstrutoraLcHiertWeb.Live.Admin.PropertiesIndexView
  alias ConstrutoraLcHiert.RealEstate.Properties.Property
  alias ConstrutoraLcHiert.RealEstate.Properties
  alias ConstrutoraLcHiert.RealEstate.Amenities
  alias ConstrutoraLcHiert.RealEstate

  plug :load_amenities when action in [:new, :create, :edit, :update]

  def index(conn, _params) do
    live_render(conn, PropertiesIndexView, session: %{})
  end

  def new(conn, _params) do
    changeset = %Property{} |> Properties.load_amenities() |> Properties.change_property()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"property" => params}) do
    case RealEstate.register_property(params) do
      {:ok, property} ->
        conn
        |> put_flash(:info, gettext("Successfully created"))
        |> redirect(to: Routes.admin_property_image_path(conn, :new, property))

      {:error, changeset} ->
        data = Properties.load_amenities(changeset.data)

        conn
        |> put_flash(:error, gettext("Error occurred! Please fix the warnings"))
        |> render("new.html", changeset: %{changeset | data: data})
    end
  end

  def edit(conn, %{"id" => id}) do
    property = Properties.get_property!(id)
    changeset = Properties.change_property(property)

    render(conn, "edit.html", property: property, changeset: changeset)
  end

  def update(conn, %{"id" => id, "property" => params}) do
    property = Properties.get_property!(id)

    case Properties.update_property(property, params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Successfully updated"))
        |> redirect(to: Routes.admin_property_path(conn, :edit, property.id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, gettext("Error occurred! Please fix the warnings"))
        |> render("edit.html", property: property, changeset: changeset)
    end
  end

  defp load_amenities(conn, _) do
    assign(conn, :amenities, Amenities.list_amenities())
  end
end
