do
  vp_x = love.graphics\getWidth!  / 2
  vp_y = love.graphics\getHeight! / 2

  export stuff = (require "3D") 250, vp_x, vp_y
  export util  = (require "util")

  require "util/deepcopy"

  export agent_conf = {
    input_size:  20
    output_size: 9
    conns:       3
    brain_size:  100
    ----------------------------------
    -- look
    ----------------------------------
    radius: 10
  }

  export world = {
    bound_x:  800
    bound_y:  400
    bound_z:  800
    ----------------------------------
    -- entities and stuff
    ----------------------------------
    agents: {}
    ----------------------------------
    -- configurations
    ----------------------------------
    rep_rate_c: 7
    rep_rate_h: 7
  }

  export Brain = require "entities/dwraon_brain"

a = 0

with love
  .update = (dt) ->
    a += dt

  .draw = ->
    for x = 1, 300, 10
      for y = 1, 300, 10
        for z = 1, 300, 10
          stuff.graphics.circle "fill", x, y, z, 5
