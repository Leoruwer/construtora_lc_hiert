defmodule ConstrutoraLcHiertWeb.ApartmentControllerTest do
  use ConstrutoraLcHiertWeb.ConnCase

  alias ConstrutoraLcHiert.Properties

  describe "GET /imoveis/apartamentos" do
    test "accesses the page when there are apartments", %{conn: conn} do
      property = property_fixture()

      conn = get(conn, "/imoveis/apartamentos")

      assert html_response(conn, 200) =~ property.address
    end

    test "show no results found when there are no apartments", %{conn: conn} do
      conn = get(conn, "/imoveis/apartamentos")

      assert html_response(conn, 200) =~ "não foi encontrado nenhum resultado"
    end
  end

  def property_fixture(attrs \\ %{}) do
    {:ok, property} =
      attrs
      |> Enum.into(%{
        address: "Rua Carlos Barbosa",
        address_number: "1650",
        area: "50",
        city: "Toledo",
        neighborhood: "Vila Industrial",
        price: 800_000.0,
        qty_bathrooms: "2",
        qty_garages: "2",
        qty_kitchens: "1",
        qty_rooms: "3",
        state: "PR",
        type: :apartment
      })
      |> Properties.create_property()

    property
  end
end