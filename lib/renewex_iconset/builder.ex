defmodule RenewexIconset.Builder do
  alias RenewexIconset.SvgPath

  def build_symbol_path(
        %{
          position_x: _x,
          position_y: _y,
          width: _width,
          height: _height
        } = box,
        %{
          segments: segments
        }
      ) do
    segments
    |> Enum.map(fn segment ->
      start =
        {start_x, start_y} = {
          build_coord(box, :x, segment.relative, unify_coord(:x, segment)),
          build_coord(box, :y, segment.relative, unify_coord(:y, segment))
        }

      {path_string, _end_pos} =
        segment.steps
        |> Enum.reduce(
          {
            "#{SvgPath.svg_command(:move, segment.relative)} #{start_x} #{start_y}",
            start
          },
          fn step, {current_string, current_pos} ->
            {next_string, next_pos} =
              build_step(
                box,
                start,
                current_pos,
                step
              )

            {[current_string, next_string], next_pos}
          end
        )

      :erlang.iolist_to_binary(path_string)
    end)
    |> Enum.join(" ")
  end

  def unify_coord(:x, obj) do
    %{
      value: obj.x_value,
      unit: obj.x_unit,
      offset: %{
        operation: obj.x_offset_operation,
        value_static: obj.x_offset_value_static,
        dynamic_value: obj.x_offset_dynamic_value,
        dynamic_unit: obj.x_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:y, obj) do
    %{
      value: obj.y_value,
      unit: obj.y_unit,
      offset: %{
        operation: obj.y_offset_operation,
        value_static: obj.y_offset_value_static,
        dynamic_value: obj.y_offset_dynamic_value,
        dynamic_unit: obj.y_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:rx, obj) do
    %{
      value: obj.rx_value,
      unit: obj.rx_unit,
      offset: %{
        operation: obj.rx_offset_operation,
        value_static: obj.rx_offset_value_static,
        dynamic_value: obj.rx_offset_dynamic_value,
        dynamic_unit: obj.rx_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:ry, obj) do
    %{
      value: obj.ry_value,
      unit: obj.ry_unit,
      offset: %{
        operation: obj.ry_offset_operation,
        value_static: obj.ry_offset_value_static,
        dynamic_value: obj.ry_offset_dynamic_value,
        dynamic_unit: obj.ry_offset_dynamic_unit
      }
    }
  end

  defp build_step(box, start_pos, {current_x, current_y} = current_pos, step) do
    cond do
      step.arc ->
        rx = build_coord(box, :x, true, unify_coord(:rx, step.arc))
        ry = build_coord(box, :y, true, unify_coord(:ry, step.arc))

        angle = step.arc.angle
        large = step.arc.large
        sweep = step.arc.sweep

        {x, y} =
          cond do
            step.vertical != nil and step.horizontal != nil ->
              x = build_coord(box, :x, step.relative, unify_coord(:x, step.horizontal))
              y = build_coord(box, :y, step.relative, unify_coord(:y, step.vertical))

              {x, y}

            step.vertical != nil ->
              x = if(step.relative, do: 0, else: current_x)
              y = build_coord(box, :y, step.relative, unify_coord(:y, step.vertical))

              {x, y}

            step.horizontal != nil ->
              x = build_coord(box, :x, step.relative, unify_coord(:x, step.horizontal))
              y = if(step.relative, do: 0, else: current_y)

              {x, y}

            true ->
              x = if(step.relative, do: 0, else: current_x)
              y = if(step.relative, do: 0, else: current_y)

              {x, y}
          end

        {"#{SvgPath.svg_command(:arc, step.relative)} #{rx} #{ry} #{if(angle, do: 1, else: 0)} #{if(sweep, do: 1, else: 0)} #{if(large, do: 1, else: 0)}  #{x} #{y}",
         SvgPath.svg_move(step.relative, current_pos, {x, y})}

      step.vertical != nil and step.horizontal != nil ->
        x = build_coord(box, :x, step.relative, unify_coord(:x, step.horizontal))
        y = build_coord(box, :y, step.relative, unify_coord(:y, step.vertical))

        {"#{SvgPath.svg_command(:diagonal, step.relative)} #{x} #{y}",
         SvgPath.svg_move(step.relative, current_pos, {x, y})}

      step.vertical != nil ->
        y = build_coord(box, :y, step.relative, unify_coord(:y, step.vertical))

        {"#{SvgPath.svg_command(:vertical, step.relative)} #{y}",
         SvgPath.svg_move(step.relative, current_pos, {nil, y})}

      step.horizontal != nil ->
        x = build_coord(box, :x, step.relative, unify_coord(:x, step.horizontal))

        {"#{SvgPath.svg_command(:horizontal, step.relative)} #{x}",
         SvgPath.svg_move(step.relative, current_pos, {x, nil})}

      true ->
        {SvgPath.svg_command(:close, step.relative), start_pos}
    end
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
