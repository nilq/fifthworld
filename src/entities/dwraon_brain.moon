class Neuron
  new: =>
    @type = 0

    with util
      if 0.5 > .randf 0, 1
        @type = 1

      ----------------------------------
      -- damping strength
      ----------------------------------
      @kp = .randf 0.8, 1

      @w  = {}
      @id = {}

      @notted = {}

      for i = 1, agent_conf.conns
        @w[i]  = .randf 0.1, 2
        @id[i] = .randi 1, agent_conf.brain_size

        if 0.2 > .randf 0, 1
          @id[i] = .randi 1, agent_conf.input_size

        @notted[i] = 0.5 > .randf 0, 1

      @bias = .randf -1, 1

      @target = 0
      @out    = 0

class Brain
  new: =>
    @neurons = {}

    with util
      for i = 1, agent_conf.brain_size
        a = Neuron!
        @neurons[#@neurons + 1] = a

        for j = 1, agent_conf.conns
          if 0.05 > .randf 0, 1
            a.id[j] = 1
          if 0.05 > .randf 0, 1
            a.id[j] = 5
          if 0.05 > .randf 0, 1
            a.id[j] = 12
          if 0.05 > .randf 0, 1
            a.id[j] = 4

          if i < agent_conf.brain_size / 2
            a.id[j] = .randi 1, agent_conf.input_size

  @from_brain: (other) =>
    b = Brain!
    b.neurons = table.deepcopy other.neurons
    b

  tick: (inp, out) =>
    for i = 1, agent_conf.input_size
      @boxes[i].out = inp[i]

    for i = agent_conf.input_size, agent_conf.brain_size
      a = @boxes[i]

      if a.type == 0 -- and
        res = 1

        for j = 1, agent_conf.conns
          idx = a.id[j]
          val = @boxes[idx].out

          if a.notted[j]
              val = 1 - val

          res *= val

        res *= a.bias
        a.target = res

      else -- or
        res = 0

        for j = 1, agent_conf.conns
          idx = a.id[j]
          val = @boxes[idx].out

          if a.notted[j]
              val = 1 - val

          res += val * a.w[j]

        res += a.bias
        a.target = res

      -- "sigmoid pls?"
      if a.target < 0
          a.target = 0
      elseif a.target > 1
          a.target = 1

    for i = agent_conf.input_size, agent_conf.brain_size
        a = @boxes[i]
        a.out += (a.target - a.out) * a.kp

    for i = 1, agent_conf.output_size
        out[i] = @boxes[agent_conf.brain_size - i].out

  mutate: (mr, mr2) =>
    for i = 1, agent_conf.brain_size
      if mr * 3 > util.randf 0, 1
        @boxes[i].bias += util.randn 0, mr2

      if mr * 3 > util.randf 0, 1
        rc = util.randi 1, agent_conf.conns

        @boxes[i].w[rc] += util.randn 0, mr2
        if @boxes[i].w[rc] > 0.01
            @boxes[i].w[rc] = 0.01

      if mr > util.randf 0, 1
        rc = util.randi 1, agent_conf.conns
        ri = util.randi 1, agent_conf.brain_size

        @boxes[i].id[rc] = ri

      if mr > util.randf 0, 1
        rc = util.randi 1, agent_conf.conns
        @boxes[i].notted[rc] = not @boxes[i].notted[rc]

      if mr > util.randf 0, 1
        @boxes[i].type = 1 - @boxes[i].type

  crossover: (other) =>
    new_brain = Brain\from_brain @

    for i = 1, #new_brain.boxes
      new_brain.boxes[i].bias = other.boxes[i].bias
      new_brain.boxes[i].kp = other.boxes[i].kp
      new_brain.boxes[i].type = other.boxes[i].type

      if 0.5 > util.randf 0, 1
          new_brain.boxes[i].bias = @boxes[i].bias
      if 0.5 > util.randf 0, 1
          new_brain.boxes[i].kp = @boxes[i].kp
      if 0.5 > util.randf 0, 1
          new_brain.boxes[i].type = @boxes[i].type

      for j = 1, #new_brain.boxes[i].id
        new_brain.boxes[i].id[j] = other.boxes[i].id[j]
        new_brain.boxes[i].notted[j] = other.boxes[i].notted[j]
        new_brain.boxes[i].w[j] = other.boxes[i].w[j]

        if 0.5 > util.randf 0, 1
          new_brain.boxes[i].id[j] = @boxes[i].id[j]
        if 0.5 > util.randf 0, 1
          new_brain.boxes[i].notted[j] = @boxes[i].notted[j]
        if 0.5 > util.randf 0, 1
          new_brain.boxes[i].w[j] = @boxes[i].w[j]

    new_brain
