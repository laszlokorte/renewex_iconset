defmodule RenewexIconset do
  def icons_by_name() do
    RenewexIconset.Predefined.all()
    |> Enum.map(&{&1.name, &1})
    |> Map.new()
  end

  def icons_by_id() do
    RenewexIconset.Predefined.all()
    |> Enum.map(&{&1.id, &1})
    |> Map.new()
  end

  def icon_by_name(name) do
    map = icons_by_name()
    Map.get(map, name)
  end

  def icon_by_id(id) do
    map = icons_by_id()
    Map.get(map, id)
  end

  def symbol_paths(
        symbol,
        %{
          position_x: _x,
          position_y: _y,
          width: _width,
          height: _height
        } = box
      ) do
    for path <- symbol.paths do
      RenewexIconset.Builder.build_symbol_path(box, path)
    end
  end

  def symbol_paths_with_attributes(
        symbol,
        %{
          position_x: _x,
          position_y: _y,
          width: _width,
          height: _height
        } = box
      ) do
    for path <- symbol.paths do
      %{
        d: RenewexIconset.Builder.build_symbol_path(box, path),
        fill_color: path.fill_color,
        stroke_color: path.stroke_color
      }
    end
  end
end
