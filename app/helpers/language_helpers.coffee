[EnsureException, AssertException, TypeException] = (->
  constructor_function = (type)->
    (problem)->
      this.type = type
      this.message = problem

  toString_function = ->
    this.type +
      (if this.message then ": #{this.message}" else "")

  exceptions =
    _.map ["EnsureException", "AssertException", "TypeException"],
      constructor_function

  _.each exceptions, (exception)->
    exception.prototype.toString = toString_function
  exceptions
)()

ensure = (->
  types =
    undefined:
      name: "undefined"
      check: (v)-> _.isUndefined v
    null:
      name: "null"
      check: (v)-> _.isNull v
    null_or_undefined:
      name: "null or undefined"
      check: (v)-> (types.null.check v) or
                   (types.undefined.check v)
    exists:
      name: "neither null nor undefined"
      check: (v)-> not (types.null_or_undefined.check v)
    true:
      name: "true"
      check: (v)-> v is true
    false:
      name: "false"
      check: (v)-> v is false
    falsey:
      name: "falsy"
      check: (v)-> not v
    truthy:
      name: "truthy"
      check: (v)-> not (types.falsey.check v)

    string:
      name: "a string"
      check: (s)-> _.isString s
    non_empty_string:
      name: "a non-empty string"
      check: (s)-> (types.string.check s) and
                   (not _.isEmpty s)
    string_if_defined:
      name: "a string, if defined"
      check: (s)-> (types.undefined.check s) or
                   (types.string.check s)
    non_empty_string_if_defined:
      name: "a non-empty string, if defined"
      check: (s)-> (types.undefined.check s) or
                   (types.non_empty_string.check s)
    
    number:
      name: "a number"
      check: (n)-> (_.isNumber n) and (not _.isNaN n)
    integer:
      name: "an integer"
      check: (n)-> (types.number.check n) and
                   ((parseFloat n) is (parseInt n))
    decimal:
      name: "a decimal number"
      check: (n)-> (types.number.check n) and
                   not (types.integer.check n)
    positive_number:
      name: "a positive number"
      check: (n)-> (types.number.check n) and
                   (n > 0)
    negative_number:
      name: "a negative number"
      check: (n)-> (types.number.check n) and
                   (n < 0)

    boolean:
      name: "a boolean"
      check: (b)-> _.isBoolean b
    boolean_if_defined:
      name: "a boolean, if defined"
      check: (b)-> (types.undefined.check b) or
                   (types.boolean.check b)

    array:
      name: "an array"
      check: (arr)-> _.isArray arr
    arguments_array:
      name: "an arguments array"
      check: (arr)-> _.isArguments arr

    function:
      name: "a function"
      check: (f)-> _.isFunction f

    object:
      name: "an object"
      check: (obj)-> (types.exists.check obj) and
                     (typeof obj is "object") and
                     not (types.array.check obj)
    non_empty_object:
      name: "a non-empty object"
      check: (obj)-> (types.object.check obj) and
                     (not _.isEmpty obj)

  stack = []
  stack.max_size = 100

  fn = (what, value, message, exception)->
    try
      unless (types.string.check what)
        throw new EnsureException "Invalid checking type (should be a string): #{what}"
      unless (types.exists.check types[what])
        throw new EnsureException "No matching checking type found for: #{what}"
      unless (types.string_if_defined.check message)
        throw new EnsureException "Exception message should be a string: #{message}"

      if (types.exists.check message)
        exception or= AssertException
      else
        exception or= TypeException
        message = "#{value} is not: #{types[what].name}"

      unless (types[what].check value)
        throw new exception message
    catch exception
      exception.message += "\n\n" + json get ensure.stack
      throw exception

  fn.test = (what, value)->
    try
      fn what, value
      true
    catch exception
      false

  fn.types = (type, obj)->
    ensure.inside "ensure.types", arguments

    ensure "string", type
    ensure "exists", obj
    ensure "string", obj.name
    ensure "function", obj.check

    ensure "undefined", types[type],
      "Proposed type already exists: #{type}"

    {name, check} = obj
    check = _.wrap check, (check, v)->
      try
        check(v)
      catch exception
        throw new TypeException "#{JSON.stringify v}" +
          " is not: #{types[type].name}"
    types[type] = {name, check}

  fn.inside = (function_name, args)->
    ensure "non_empty_string", function_name
    if types.undefined.check args
      args = []
    else
      ensure "arguments_array", args

    stack.push "function: #{function_name}\narguments: #{json _.toArray args}"
    if stack.length > stack.max_size
      stack.splice(0, 1)
    undefined

  fn.stack = ->
    (_.map stack, (v)-> v).join "\n-----\n"

  fn.stack.size = (size)->
    ensure "positive_number", size
    stack.max_size = size
    if stack.length > stack.max_size
      stack.splice(0, stack.length - stack.max_size)
      undefined

  fn.stack.empty = ->
    stack = []

  fn
)()

get = (func)->
  try
    func()
  catch exception
    ensure.inside "get", arguments
    throw new TypeError "wrong argument to `get`: #{func}"

json = (obj, ugly_print)->
  try
    if _.isString obj
      obj
    else
      if ugly_print is true
        JSON.stringify obj
      else 
        JSON.stringify obj, null, 2
  catch exception
    obj

log = (obj)->
  str = json obj, true
  console.log str
  str

_.mixin
  initialDefined: (arr)->
    ensure "array", arr
    i = 0
    i++ while ensure.test "exists", arr[i]
    arr[0...i]
  objectify: (keys, values)->
    ensure "array", keys
    ensure "array", values
    obj = {}
    for key, i in keys
      obj[key] = values[i] if ensure.test "non_empty_string", values[i]
    obj
