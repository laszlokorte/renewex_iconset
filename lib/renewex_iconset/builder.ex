defmodule RenewexIconset.Builder do
  alias RenewexIconset.SvgPath
  alias RenewexIconset.Position

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
          Position.build_coord(box, :x, segment.relative, Position.unify_coord(:x, segment)),
          Position.build_coord(box, :y, segment.relative, Position.unify_coord(:y, segment))
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

  defp build_step(box, start_pos, {current_x, current_y} = current_pos, step) do
    cond do
      step.arc ->
        rx = Position.build_coord(box, :x, true, Position.unify_coord(:rx, step.arc))
        ry = Position.build_coord(box, :y, true, Position.unify_coord(:ry, step.arc))

        angle = step.arc.angle
        large = step.arc.large
        sweep = step.arc.sweep

        {x, y} =
          cond do
            step.vertical != nil and step.horizontal != nil ->
              x =
                Position.build_coord(
                  box,
                  :x,
                  step.relative,
                  Position.unify_coord(:x, step.horizontal)
                )

              y =
                Position.build_coord(
                  box,
                  :y,
                  step.relative,
                  Position.unify_coord(:y, step.vertical)
                )

              {x, y}

            step.vertical != nil ->
              x = if(step.relative, do: 0, else: current_x)

              y =
                Position.build_coord(
                  box,
                  :y,
                  step.relative,
                  Position.unify_coord(:y, step.vertical)
                )

              {x, y}

            step.horizontal != nil ->
              x =
                Position.build_coord(
                  box,
                  :x,
                  step.relative,
                  Position.unify_coord(:x, step.horizontal)
                )

              y = if(step.relative, do: 0, else: current_y)

              {x, y}

            true ->
              x = if(step.relative, do: 0, else: current_x)
              y = if(step.relative, do: 0, else: current_y)

              {x, y}
          end

        {"#{SvgPath.svg_command(:arc, step.relative)} #{rx} #{ry} #{angle} #{if(sweep, do: 1, else: 0)} #{if(large, do: 1, else: 0)}  #{x} #{y}",
         SvgPath.svg_move(step.relative, current_pos, {x, y})}

      step.vertical != nil and step.horizontal != nil ->
        x =
          Position.build_coord(box, :x, step.relative, Position.unify_coord(:x, step.horizontal))

        y = Position.build_coord(box, :y, step.relative, Position.unify_coord(:y, step.vertical))

        {"#{SvgPath.svg_command(:diagonal, step.relative)} #{x} #{y}",
         SvgPath.svg_move(step.relative, current_pos, {x, y})}

      step.vertical != nil ->
        y = Position.build_coord(box, :y, step.relative, Position.unify_coord(:y, step.vertical))

        {"#{SvgPath.svg_command(:vertical, step.relative)} #{y}",
         SvgPath.svg_move(step.relative, current_pos, {nil, y})}

      step.horizontal != nil ->
        x =
          Position.build_coord(box, :x, step.relative, Position.unify_coord(:x, step.horizontal))

        {"#{SvgPath.svg_command(:horizontal, step.relative)} #{x}",
         SvgPath.svg_move(step.relative, current_pos, {x, nil})}

      true ->
        {SvgPath.svg_command(:close, step.relative), start_pos}
    end
  end
end
