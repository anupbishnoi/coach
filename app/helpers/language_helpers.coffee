_s = _.str

assert = (exp, message, exception_type)->
  unless exp
    console.error assert.stack.join "\n"
    throw new (exception_type or AssertException) message
assert.stack = []

defaults = (argobj, defaults_obj)->
  defaulted = {}
  for own k of argobj
    defaulted[k] = argobj[k] or defaults_obj[k]
  defaulted

ensure = (->
  types =
    string:
      is: "a string"
      check: (s)-> typeof s is "string"
    non_empty_string:
      is: "a non-empty string"
      check: (s)->
        (types.string.check s) and (not _s.isBlank s)
    string_if_defined:
      is: "a string, if defined"
      check: (s)->
        not s or types.string.check s

  (type, v)->
    assert (types.string.check type),
      "type to ensure should be a string"
    assert types[type], "unrecognised type '#{type}'"
    assert (types[type].check v),
      "'#{v}' is not of type '#{type}'",
      TypeException
)()

get = (func)-> func()
