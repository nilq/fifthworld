do
  vp_x = love.graphics\getWidth!  / 2
  vp_y = love.graphics\getHeight! / 2

  export stuff = (require "3D") 250, vp_x, vp_y

x, z = 0, 0
a    = 0
r    = 160

with love
  .update = (dt) ->
    a += dt * 2

    x = r * math.cos a
    z = r * math.sin a

  .draw = ->
    .graphics.setColor 255, 0, 255

    stuff.graphics.circle "fill", x, -100, z + 100, 50
