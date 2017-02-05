export stuff = (require "3D") 180, 640, 480

x, z = 0, 0
a    = 0
r    = 300

with love
  .update = (dt) ->
    a += dt * 2

    x = r * math.cos a
    z = r * math.sin a

  .draw = ->
    .graphics.setColor 255, 0, 255

    stuff.graphics.circle "fill", x - 300, -300, z + 200, 50
