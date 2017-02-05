----------------------------------
-- convenience
----------------------------------
_rotation = ->
  util.randf -math.pi, math.pi

_reproduction_rate = (h, rep_c, rep_h) ->
  with util
    h * (.randf rep_c - 0.1, rep_h + 0.1) + (1 - h) * .randf rep_c - 0.1, rep_h + 0.1

----------------------------------
-- initialization functions
----------------------------------
randomize = (bound_x, bound_y=bound_x, bound_z=bound_x) =>
  with util
    x = .randf 0, bound_x
    y = .randf 0, bound_y
    z = .randf 0, bound_z

    a_x = _rotation!
    a_y = _rotation!
    a_z = _rotation!

    {
      :x, :y, :z

      :a_x
      :a_y
      :a_z
    }

set = (x, y, z, a_x=_rotation!, a_y=_rotation!, a_z=_rotation!) ->
  {
    :x, :y, :z

    :a_x
    :a_y
    :a_z
  }

----------------------------------
-- the agent
----------------------------------
class Agent
  new: (pos_func) =>
    @transform = pos_func world.bound_x, world.bound_y, world.bound_z

    @health = 1 + util.randf 0, 0.1
    @age    = 0 -- ticks

    with util
      @color = {
        r: .randf 0, 255
        g: .randf 0, 255
        b: .randf 0, 255
      }

    ----------------------------------
    -- food to donate
    ----------------------------------
    @dfood = 0

    ----------------------------------
    -- horizontal and vertical wheels
    ----------------------------------
    @w1_h = 0
    @w2_h = 0
    @w1_v = 0
    @w2_v = 0

    ----------------------------------
    -- sound multiplier
    ----------------------------------
    @sound_mul = 1

    ----------------------------------
    -- clocks at different frequencies
    ----------------------------------
    @clock_f1 = util.randf 5, 100
    @clock_f2 = util.randf 5, 100

    @boost = false -- use extra speed?

    @indicator = 0 -- type
    @gen_count = 0 -- generation

    ----------------------------------
    -- indicator color
    ----------------------------------
    @i_color = {
      r: 0
      g: 0
      b: 0
    }

    @hybrid    = false -- crossover
    @herbivore = util.randf 0, 1

    ----------------------------------
    -- how much to reproduce
    ----------------------------------
    @rep_count = _reproduction_rate @herbivore, world.rep_rate_c, world.rep_rate_h

    @id = 0

    @mut_rate1 = 0.003
    @mut_rate2 = 0.05

    @give = 0

    ----------------------------------
    -- TODO: BRAIN
    ----------------------------------
    @brain = "yes hello"

    @out = {}
    for i = 1, OUTPUT_SIZE
      @out[i] = 0

    @inp = {}
    for i = 1, INPUT_SIZE
      @inp[i] = 0

  init_rate: (size, r, g, b) =>
    @color = {
      :r,
      :g,
      :b,
    }

{
  :Agent
  ----------------------------------
  -- initializers
  ----------------------------------
  :randomize
  :set
}
