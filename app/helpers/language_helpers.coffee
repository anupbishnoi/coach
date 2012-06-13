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
      type_name: "undefined"
      type_check: (v)-> _.isUndefined v
    null:
      type_name: "null"
      type_check: (v)-> _.isNull v
    null_or_undefined:
      type_name: "null or undefined"
      type_check: (v)-> (types.null.type_check v) or
                   (types.undefined.type_check v)
    exists:
      type_name: "neither null nor undefined"
      type_check: (v)-> not (types.null_or_undefined.type_check v)
    true:
      type_name: "true"
      type_check: (v)-> v is true
    false:
      type_name: "false"
      type_check: (v)-> v is false
    falsey:
      type_name: "falsy"
      type_check: (v)-> not v
    truthy:
      type_name: "truthy"
      type_check: (v)-> not (types.falsey.type_check v)

    string:
      type_name: "a string"
      type_check: (s)-> _.isString s
    non_empty_string:
      type_name: "a non-empty string"
      type_check: (s)-> (types.string.type_check s) and
                   (not _.isEmpty s)
    string_if_defined:
      type_name: "a string, if defined"
      type_check: (s)-> (types.undefined.type_check s) or
                   (types.string.type_check s)
    non_empty_string_if_defined:
      type_name: "a non-empty string, if defined"
      type_check: (s)-> (types.undefined.type_check s) or
                   (types.non_empty_string.type_check s)
    
    number:
      type_name: "a number"
      type_check: (n)-> (_.isNumber n) and (not _.isNaN n)
    integer:
      type_name: "an integer"
      type_check: (n)-> (types.number.type_check n) and
                   ((parseFloat n) is (parseInt n))
    decimal:
      type_name: "a decimal number"
      type_check: (n)-> (types.number.type_check n) and
                   not (types.integer.type_check n)
    positive_number:
      type_name: "a positive number"
      type_check: (n)-> (types.number.type_check n) and
                   (n > 0)
    negative_number:
      type_name: "a negative number"
      type_check: (n)-> (types.number.type_check n) and
                   (n < 0)

    boolean:
      type_name: "a boolean"
      type_check: (b)-> _.isBoolean b
    boolean_if_defined:
      type_name: "a boolean, if defined"
      type_check: (b)-> (types.undefined.type_check b) or
                   (types.boolean.type_check b)

    array:
      type_name: "an array"
      type_check: (arr)-> _.isArray arr
    arguments_array:
      type_name: "an arguments array"
      type_check: (arr)-> _.isArguments arr

    function:
      type_name: "a function"
      type_check: (f)-> _.isFunction f

    object:
      type_name: "an object"
      type_check: (obj)-> (types.exists.type_check obj) and
                     (typeof obj is "object") and
                     not (types.array.type_check obj)
    non_empty_object:
      type_name: "a non-empty object"
      type_check: (obj)-> (types.object.type_check obj) and
                     (not _.isEmpty obj)

  stack = []
  stack.max_size = 10

  fn = (what, value, message, exception)->
    try
      unless (types.string.type_check what)
        throw new EnsureException "Invalid checking type (should be a string): #{what}"
      unless (types.exists.type_check types[what])
        throw new EnsureException "No matching checking type found for: #{what}"
      unless (types.string_if_defined.type_check message)
        throw new EnsureException "Exception message should be a string: #{message}"

      if (types.exists.type_check message)
        exception or= AssertException
      else
        exception or= TypeException
        message = "#{value} is not: #{types[what].type_name}"

      unless (types[what].type_check value)
        throw new exception message
    catch exception
      exception.message += "\n\n" + log_str get ensure.stack
      throw exception

  fn.types = (type, obj)->
    ensure.inside "ensure.types", arguments

    ensure "string", type
    ensure "exists", obj
    ensure "string", obj.type_name
    ensure "function", obj.type_check

    ensure "undefined", types[type],
      "Proposed type already exists: #{type}"

    {type_name, type_check} = obj
    type_check = _.wrap type_check, (type_check, v)->
      try
        type_check(v)
      catch exception
        throw new TypeException "#{JSON.stringify v}" +
          " is not: #{types[type].type_name}"
    types[type] = {type_name, type_check}

  fn.inside = (function_name, args)->
    ensure "non_empty_string", function_name
    if types.undefined.type_check args
      args = []
    else
      ensure "arguments_array", args

    stack.push "function: #{function_name}\narguments: #{log_str _.toArray args}"
    if stack.length > stack.max_size
      stack.splice(0, 1)
    undefined

  fn.stack = (size)->
    if size
      ensure "positive_number", size
      stack.max_size = size
      if stack.length > stack.max_size
        stack.splice(0, stack.length - stack.max_size)
        undefined
    else
      (_.map stack, (v)-> v).join "\n-----\n"

  fn
)()

get = (func)->
  try
    func()
  catch exception
    ensure.inside "get", arguments
    throw new TypeError "wrong argument to `get`: #{func}"

log_str = (obj)->
  try
    if _.isString obj
      obj
    else
      JSON.stringify obj, null, 2
  catch exception
    obj
log = (obj)->
  str = log_str obj
  console.log str
  str
