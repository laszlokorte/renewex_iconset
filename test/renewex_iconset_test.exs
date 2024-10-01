defmodule RenewexIconsetTest do
  use ExUnit.Case
  doctest RenewexIconset

  @example_box %{position_x: 50, position_y: 70, width: 130, height: 190}

  @sample_shapes [
    {"rect", ["M 50.0 70.0H 180.0V 260.0H 50.0Z"]},
    {"ellipse", ["M 50.0 165.0a 65.0 95.0 0.0 0 0  130.0 0a 65.0 95.0 0.0 0 0  -130.0 0"]},
    {"cross",
     [
       "M 115.0 165.0 m 22.1 -28.6l 6.5 6.5l -22.1 22.1l 22.1 22.1l -6.5 6.5l " <>
         "-22.1 -22.1l -22.1 22.1l -6.5 -6.5l 22.1 -22.1l -22.1 -22.1l 6.5 -6.5l " <>
         "22.1 22.1l 22.1 -22.1Z"
     ]},
    {"bracket-left", ["M 50.0 70.0H 180.0v 10.0H 60.0V 250.0H 180.0V 260.0H 50.0Z"]}
  ]

  @sample_shapes_with_attributes [
    {"rect",
     [
       %{
         d: "M 50.0 70.0H 180.0V 260.0H 50.0Z",
         fill_color: "inherit",
         stroke_color: "inherit"
       }
     ]},
    {"ellipse",
     [
       %{
         d: "M 50.0 165.0a 65.0 95.0 0.0 0 0  130.0 0a 65.0 95.0 0.0 0 0  -130.0 0",
         fill_color: "inherit",
         stroke_color: "inherit"
       }
     ]},
    {"cross",
     [
       %{
         d:
           "M 115.0 165.0 m 22.1 -28.6l 6.5 6.5l -22.1 22.1l 22.1 22.1l -6.5 6.5l " <>
             "-22.1 -22.1l -22.1 22.1l -6.5 -6.5l 22.1 -22.1l -22.1 -22.1l 6.5 -6.5l " <>
             "22.1 22.1l 22.1 -22.1Z",
         fill_color: "black",
         stroke_color: "inherit"
       }
     ]},
    {"bracket-left",
     [
       %{
         d: "M 50.0 70.0H 180.0v 10.0H 60.0V 250.0H 180.0V 260.0H 50.0Z",
         fill_color: "black",
         stroke_color: "none"
       }
     ]}
  ]

  test "sample shapes" do
    for {name, expected_paths} <- @sample_shapes do
      shape = RenewexIconset.icon_by_name(name)

      assert expected_paths ==
               RenewexIconset.symbol_paths(
                 shape,
                 @example_box
               )
    end
  end

  test "sample shapes with attributes" do
    for {name, expected_paths} <- @sample_shapes_with_attributes do
      shape = RenewexIconset.icon_by_name(name)

      assert expected_paths ==
               RenewexIconset.symbol_paths_with_attributes(
                 shape,
                 @example_box
               )
    end
  end

  test "all shapes" do
    for {name, shape} <- RenewexIconset.icons_by_name() do
      assert [_ | _] =
               RenewexIconset.symbol_paths(
                 shape,
                 @example_box
               ),
             "#{name} is converted to list of paths"
    end
  end
end
