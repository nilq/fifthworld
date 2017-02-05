project = (x, y, z) ->
  scale = @focal / (@focal + z)

  new_x = @vp_x + x * scale
  new_y = @vp_y + y * scale

  new_x, new_y, scale

with love.graphics
  circle = (mode, x, y, z, radius, segments) ->
    x, y, scale = project x, y, z
    .circle mode, x, y, radius * scale, segments

  line = (width, style, x1, y1, z1, x2, y2, z2) ->
    x1, y1 = project x1, y1, z1
    x2, y2 = project x2, y2, z2

    .setLine width, style
    .line x1, y1, x2, y2

  draw = (drawable, x, y, z, r, sx, sy, ox, oy, is_scale) ->
    x, y, scale = project x, y, z

    if is_scale
      .draw drawable, x, y, r, sx * scale, sy * scale, ox, oy
    else
      .draw drawable, x, y, r, sx, sy, ox, oy

class
  new: (@focal, @vp_x, @vp_y) =>
    @graphics = {
      :circle
      :line
      :draw
    }

  rotate_x: (y, z, a_x, c_y, c_z) =>
    cos_x = math.cos a_x
    sin_x = math.sin a_x

    _z = z - c_z
    _y = y - c_y

    y1 = _y * cos_x - _z * sin_x
    z1 = _z * cos_x - _y * sin_x

    y1 + c_y, z1 + c_z

  rotate_y: (x, z, a_y, c_x, c_z) =>
    cos_y = math.cos a_y
    sin_y = math.sin a_y

    _z = z - c_z
    _x = x - c_x

    x1 = _x * cos_y - _z * sin_y
    z1 = _z * cos_y - _x * sin_y

    x1 + c_x, z1 + c_z

  rotate_y: (x, y, a_z, c_x, c_y) =>
    cos_z = math.cos a_z
    sin_z = math.sin a_z

    _x = x - c_x
    _y = y - c_y

    x1 = _x * cos_z - _y * sin_z
    y1 = _y * cos_z - _x * sin_z

    x1 + c_x, y1 + c_y

  z_sort: (point_t) =>
    table.sort point_t, (A, B) -> A.z > B.z
