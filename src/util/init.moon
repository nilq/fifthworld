return_v = false
value_v  = 0

deep_copy = (org) ->
    org_type = type org
    copy
    if org_type == "table"
        copy = {}
        for k, v in next, org, nil
            copy[deep_copy k] = deep_copy org
        setmetatable copy, deep_copy getmetatable org
    else
        copy = org

    copy

gauss_random = ->
    if return_v
        return_v = false
        return value_v

    u = 2 * math.random! - 1
    v = 2 * math.random! - 1

    r = u^2 + v^2

    if r == 0 or r > 1
        return gauss_random!

    c = math.sqrt -2 * (math.log r) / r
    value_v = v * c

    u * c

randf = (a, b) ->
    (b - a) * math.random! + a

randi = (a, b) ->
    math.floor (b - a) * math.random! + a

randn = (mu, sigma) ->
    mu + gauss_random! * sigma

-- not really sign ... too late!
sign = (n) ->
    if n < 0
        return 0
    if n > 1
        return 1
    n

is_callable = (x) ->
  (nil != (getmetatable x).__call or "function" == type x)

combine = (...) ->
  _error = "expected either function or nil"

  n = select "#", ...

  return noop if n == 0

  if n == 1
    fn = select 1, ...

    return noop unless fn

    assert (is_callable fn), _error

    return fn

  funcs = {}

  for i = 1, n
    fn = select i, ...

    if fn != nil
      assert (is_callable fn), _error
      funcs[#funcs + 1] = fn

  (...) ->
    for f in *funcs
      f ...

{
  :is_callable
  :combine

  :gauss_random
  :randf
  :randi
  :randn
  :sign
  :deep_copy
}
