defmodule RenewexIconset.SvgPath do
  def svg_command(:close, true), do: "z"
  def svg_command(:close, false), do: "Z"
  def svg_command(:vertical, true), do: "v"
  def svg_command(:vertical, false), do: "V"
  def svg_command(:horizontal, true), do: "h"
  def svg_command(:horizontal, false), do: "H"
  def svg_command(:diagonal, true), do: "l"
  def svg_command(:diagonal, false), do: "L"
  def svg_command(:move, true), do: "m"
  def svg_command(:move, false), do: "M"
  def svg_command(:arc, true), do: "a"
  def svg_command(:arc, false), do: "A"

  def svg_move(true, {old_x, old_y}, {nil, arg_y}) when not is_nil(arg_y),
    do: {old_x, old_y + arg_y}

  def svg_move(true, {old_x, old_y}, {arg_x, nil}) when not is_nil(arg_x),
    do: {old_x + arg_x, old_y}

  def svg_move(true, {old_x, old_y}, {arg_x, arg_y})
      when not is_nil(arg_x) and not is_nil(arg_y),
      do: {old_x + arg_x, old_y + arg_y}

  def svg_move(false, {old_x, _old_y}, {nil, arg_y}) when not is_nil(arg_y), do: {old_x, arg_y}
  def svg_move(false, {_old_x, old_y}, {arg_x, nil}) when not is_nil(arg_x), do: {arg_x, old_y}

  def svg_move(false, {_old_x, _old_y}, {arg_x, arg_y})
      when not is_nil(arg_x) and not is_nil(arg_y),
      do: {arg_x, arg_y}
end
