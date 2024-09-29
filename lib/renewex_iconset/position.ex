defmodule RenewexIconset.Position do
  def unify_coord(:x, %{
        x_value: x_value,
        x_unit: x_unit,
        x_offset_operation: x_offset_operation,
        x_offset_value_static: x_offset_value_static,
        x_offset_dynamic_value: x_offset_dynamic_value,
        x_offset_dynamic_unit: x_offset_dynamic_unit
      }) do
    %{
      value: x_value,
      unit: x_unit,
      offset: %{
        operation: x_offset_operation,
        value_static: x_offset_value_static,
        dynamic_value: x_offset_dynamic_value,
        dynamic_unit: x_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:y, %{
        y_value: y_value,
        y_unit: y_unit,
        y_offset_operation: y_offset_operation,
        y_offset_value_static: y_offset_value_static,
        y_offset_dynamic_value: y_offset_dynamic_value,
        y_offset_dynamic_unit: y_offset_dynamic_unit
      }) do
    %{
      value: y_value,
      unit: y_unit,
      offset: %{
        operation: y_offset_operation,
        value_static: y_offset_value_static,
        dynamic_value: y_offset_dynamic_value,
        dynamic_unit: y_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:rx, %{
        rx_value: rx_value,
        rx_unit: rx_unit,
        rx_offset_operation: rx_offset_operation,
        rx_offset_value_static: rx_offset_value_static,
        rx_offset_dynamic_value: rx_offset_dynamic_value,
        rx_offset_dynamic_unit: rx_offset_dynamic_unit
      }) do
    %{
      value: rx_value,
      unit: rx_unit,
      offset: %{
        operation: rx_offset_operation,
        value_static: rx_offset_value_static,
        dynamic_value: rx_offset_dynamic_value,
        dynamic_unit: rx_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:ry, %{
        ry_value: ry_value,
        ry_unit: ry_unit,
        ry_offset_operation: ry_offset_operation,
        ry_offset_value_static: ry_offset_value_static,
        ry_offset_dynamic_value: ry_offset_dynamic_value,
        ry_offset_dynamic_unit: ry_offset_dynamic_unit
      }) do
    %{
      value: ry_value,
      unit: ry_unit,
      offset: %{
        operation: ry_offset_operation,
        value_static: ry_offset_value_static,
        dynamic_value: ry_offset_dynamic_value,
        dynamic_unit: ry_offset_dynamic_unit
      }
    }
  end

  def build_coord(box, axis, relative, coord) do
    origin = box_axis(axis, box)
    base = coord.value * unit(coord.unit, box)

    offset =
      op(
        coord.offset.operation,
        coord.offset.value_static,
        unit(coord.offset.dynamic_unit, box) * coord.offset.dynamic_value
      )

    if(relative, do: base, else: base + origin) + offset
  end

  def box_axis(:x, box), do: box.position_x
  def box_axis(:y, box), do: box.position_y

  def unit(:maxsize, box), do: max(box.width, box.height)
  def unit(:minsize, box), do: min(box.width, box.height)
  def unit(:width, box), do: box.width
  def unit(:height, box), do: box.height

  def op(:max, a, b), do: max(a, b)
  def op(:min, a, b), do: min(a, b)
  def op(:sum, a, b) when is_float(a) and is_float(b), do: a + b
end
