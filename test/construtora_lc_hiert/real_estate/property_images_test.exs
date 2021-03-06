defmodule ConstrutoraLcHiert.RealEstate.PropertyImagesTest do
  use ConstrutoraLcHiert.DataCase
  use ConstrutoraLcHiert.Fixtures, [:property]

  alias ConstrutoraLcHiert.Repo
  alias ConstrutoraLcHiert.RealEstate.PropertyImages
  alias ConstrutoraLcHiert.RealEstate.Properties.PropertyImage

  def property_image_fixture(attrs) do
    {:ok, property_image} = PropertyImages.create_property_image(attrs)

    property_image
  end

  describe "create_property_image/1" do
    setup [:create_property]

    test "with valid data creates a property_image", %{property: property} do
      attrs = %{
        "image" => %Plug.Upload{
          path: "test/fixtures/images/aprovameupr.png",
          filename: "aprovameupr.png"
        },
        "property_id" => property.id
      }

      assert {:ok, %PropertyImage{} = property_image} =
               PropertyImages.create_property_image(attrs)

      assert File.exists?("uploads/test/#{property.id}/#{property_image.image.file_name}")
    end

    test "with invalid data returns error changeset" do
      attrs = %{
        "image" => %Plug.Upload{
          path: "test/fixtures/images/aprovameupr.png",
          filename: "aprovameupr.png"
        },
        "property_id" => nil
      }

      assert {:error, %Ecto.Changeset{}} = PropertyImages.create_property_image(attrs)
    end
  end

  describe "get_property_image_by!/1" do
    setup [:create_property]

    test "returns the property image", %{property: property} do
      attrs = %{
        "image" => %Plug.Upload{
          path: "test/fixtures/images/aprovameupr.png",
          filename: "aprovameupr.png"
        },
        "property_id" => property.id
      }

      property_image = property_image_fixture(attrs)

      assert property_image =
               PropertyImages.get_property_image_by!(
                 id: property_image.id,
                 property_id: property.id
               )
    end
  end

  describe "delete_property_image/1" do
    setup [:create_property]

    test "deletes the property_image and the file", %{property: property} do
      attrs = %{
        "image" => %Plug.Upload{
          path: "test/fixtures/images/aprovameupr.png",
          filename: "aprovameupr.png"
        },
        "property_id" => property.id
      }

      property_image = property_image_fixture(attrs)

      assert {:ok, %PropertyImage{}} = PropertyImages.delete_property_image(property_image)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(PropertyImage, property_image.id) end
    end
  end

  describe "set_featured_property_image/1" do
    setup [:create_property]

    test "sets the given image as featured", %{property: property} do
      first_property_image =
        property_image_fixture(%{
          "image" => %Plug.Upload{
            path: "test/fixtures/images/aprovameupr.png",
            filename: "to_aqui_fazendo_nada.png"
          },
          "property_id" => property.id
        })

      second_property_image =
        property_image_fixture(%{
          "image" => %Plug.Upload{
            path: "test/fixtures/images/aprovameupr.png",
            filename: "ce_ta_doido.png"
          },
          "property_id" => property.id,
          "featured" => true
        })

      assert {:ok, %PropertyImage{featured: true}} =
               PropertyImages.set_featured_property_image(first_property_image)

      assert Repo.get(PropertyImage, second_property_image.id).featured == false
    end
  end

  defp create_property(_) do
    property = property_fixture()

    {:ok, property: property}
  end
end
