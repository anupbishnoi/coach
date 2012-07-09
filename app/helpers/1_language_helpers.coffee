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
    "undefined":
      name: "undefined"
      check: (v)-> _.isUndefined v
    "null":
      name: "null"
      check: (v)-> _.isNull v
    "null_or_undefined":
      name: "null or undefined"
      check: (v)-> (types.null.check v) or
                   (types.undefined.check v)
    "exists":
      name: "neither null nor undefined"
      check: (v)-> not (types.null_or_undefined.check v)
    "empty":
      name: "empty (in the underscore sense)"
      check: (v)-> _.isEmpty v
    "true":
      name: "true"
      check: (v)-> v is true
    "false":
      name: "false"
      check: (v)-> v is false
    "falsey":
      name: "falsy"
      check: (v)-> not v
    "truthy":
      name: "truthy"
      check: (v)-> not (types.falsey.check v)

    "string":
      name: "a string"
      check: (s)-> _.isString s
    "non_empty_string":
      name: "a non-empty string"
      check: (s)-> (types.string.check s) and
                   (not _.isBlank s)
    "string_if_defined":
      name: "a string, if defined"
      check: (s)-> (types.undefined.check s) or
                   (types.string.check s)
    "non_empty_string_if_defined":
      name: "a non-empty string, if defined"
      check: (s)-> (types.undefined.check s) or
                   (types.non_empty_string.check s)
    
    "number":
      name: "a number"
      check: (n)-> (_.isNumber n) and (not _.isNaN n)
    "integer":
      name: "an integer"
      check: (n)-> (types.number.check n) and
                   ((parseFloat n) is (parseInt n))
    "decimal":
      name: "a decimal number"
      check: (n)-> (types.number.check n) and
                   not (types.integer.check n)
    "positive_number":
      name: "a positive number"
      check: (n)-> (types.number.check n) and
                   (n > 0)
    "negative_number":
      name: "a negative number"
      check: (n)-> (types.number.check n) and
                   (n < 0)

    "boolean":
      name: "a boolean"
      check: (b)-> _.isBoolean b
    "boolean_if_defined":
      name: "a boolean, if defined"
      check: (b)-> (types.undefined.check b) or
                   (types.boolean.check b)

    "array":
      name: "an array"
      check: (arr)-> _.isArray arr
    "arguments":
      name: "an arguments array"
      check: (arr)-> _.isArguments arr

    "function":
      name: "a function"
      check: (f)-> _.isFunction f

    "object":
      name: "an object"
      check: (obj)-> (types.exists.check obj) and
                     (typeof obj is "object") and
                     not (types.array.check obj)
    "non_empty_object":
      name: "a non-empty object"
      check: (obj)-> (types.object.check obj) and
                     (not _.isEmpty obj)

    "type":
      name: "a value type"
      check: (type)-> (types.string.check type) and
                      (types.exists.check types[type])

  stack = []
  stack.max_size = 10

  checkItem = (item, value, message, exception, inverse)->
    unless types.non_empty_string.check item
      throw new EnsureException "Invalid checking type name: #{json item}"
    unless types.exists.check types[item]
      throw new EnsureException "No matching checking type found for: #{item}"
    unless types.string_if_defined.check message
      throw new EnsureException "Exception message should be a string: #{message}"
    if types.exists.check message
      exception or= AssertException
    else
      exception or= TypeException
      message = "#{value} is not: #{types[item].name}"
    if inverse is true
      throw new exception message if types[item].check value
    else
      throw new exception message unless types[item].check value

  fn = (what, value, message, exception, inverse)->
    try
      if types.array.check what
        es = []
        for item in what
          try
            checkItem item, value, message, exception, inverse
          catch e
            es.push e
        unless es.length < what.length
          throw es[0]
      else
        checkItem what, value, message, exception, inverse
      true
    catch exception
      exception.message += "\n\n" + json ensure.stack()
      throw exception

  fn.not = (what, value, message, exception)->
    fn what, value, message, exception, true

  fn.test = (what, value, inverse)->
    succeeded = if inverse is true then false else true
    try
      fn what, value
      succeeded
    catch exception
      not succeeded

  fn.not.test = (what, value)->
    fn.test what, value, true

  fn.error = (message, args)->
    fn "false", true, message

  fn.types = (type, obj)->
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
      ensure "arguments", args

    stack.push "function: #{function_name}\narguments: #{json _.toArray args}"
    if stack.length > stack.max_size
      stack.splice(0, 1)
    undefined

  fn.stack = (how_many)->
    stack[0...how_many].join "\n-----\n"

  fn.stack.last = -> _.last stack

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

log = (obj, pretty)->
  str = json obj, not pretty
  console.log str
  str

addKeyValueGenerator = (resource, value_format, func_identifier)->
  ensure.inside "addKeyValueGenerator", arguments
  ensure ["non_empty_string", "array"], value_format

  errorText = (msg, args)->
    if ensure.test "non_empty_string", func_identifier
      msg += "\n#{func_identifier}\n#{json _.toArray args}"
    msg

  add = (key, value)->
    if (ensure.test "object", resource[key]) and
       (ensure.test "object", value)
      resource[key] = _.extend (_.clone resource[key]), value
    else if ensure.test "exists", resource[key]
      ensure.error errorText "Key already exists: #{key}"
    else
      resource[key] = value
    true

  (key, value)->
    ensure.inside func_identifier, arguments
    if ensure.test value_format, value
      if ensure.test "non_empty_string", key
        add key, value
      else if ensure.test "array", key
        for k in key
          ensure "non_empty_string", k
          add k, value
      else
        ensure.error errorText "Invalid argument format", arguments
    else if ensure.test "object", key
      for own k, v of key
        ensure value_format, v
        add k, v
    else if ensure.test "non_empty_string", key
      ensure.not "exists", value, "Invalid format of value supplied for key: #{key}"
      resource[key]
    else
      ensure.error errorText "Invalid argument format. Sab kuch hi galat hai", arguments

_.mixin _.str.exports()

_.mixin
  initialDefined: (arr)->
    ensure.inside "_.initialDefined", arguments
    ensure "array", arr
    i = 0
    i++ while ensure.test "exists", arr[i]
    arr[0...i]

  onlyDefined: (arr)->
    ensure.inside "_.onlyDefined", arguments
    ensure "array", arr
    _.filter arr, (v)-> ensure.test "exists", v

  objectify: (keys, values, value_format, ignore_exceptions)->
    ensure.inside "_.objectify", arguments
    ensure "array", keys
    ensure "array", values
    obj = {}
    for key, i in keys
      ensure "string", key
      ok = true
      if ensure.test "exists", value_format
        ensure "type", value_format
        ok =
          if ignore_exceptions is true
            ensure.test value_format, values[i]
          else
            ensure value_format, values[i]
      obj[key] = values[i] if ok
    obj

  breakApart: (obj, key_name, value_name, allow_undefined)->
    ensure.inside "_.breakApart", arguments
    ensure "non_empty_string_if_defined", key_name
    ensure "non_empty_string_if_defined", value_name
    key_name or= "key"
    value_name or= "value"
    keys = _.keys obj
    _.onlyDefined _.map keys, (key)->
      if allow_undefined is true or ensure.test "exists", obj[key]
        o = {}
        o[key_name] = key
        o[value_name] = obj[key]
        o

  sum: (num_arr)->
    ensure "array", num_arr
    sum = (total, num)->
      ensure "number", num
      total + num
    _.reduce num_arr, sum, 0

  printable: (thing)->
    if ensure.test "string", thing
      _.titleize _.humanize thing
    else if ensure.test "number", thing
      "#{thing}"
    else if ensure.test "array", thing
      (_.map (item)-> _.printable item)
    else if ensure.test "object", thing
      _.map (_.keys thing), (key)->
        field: key, value: _.printable thing[key]

  date: (d)->
    months = ["Jan","Feb","Mar","Apr","May","Jun",
              "Jul","Aug","Sep","Oct","Nov","Dec"]
    "#{d.getDate()} #{months[d.getMonth()]} #{d.getFullYear()}"

  self: (arg)-> arg
  findValue: (fields, doc, nextDoc, allow_invalid, replace)->
    ensure.inside "_.findValue", arguments
    ensure "array", fields
    ensure "object", doc
    if ensure.test "exists", nextDoc
      ensure "function", nextDoc
    else
      nextDoc = _.self
    current_doc = doc
    for field, index in fields
      current_value = current_doc[field]
      if fields.length > index + 1
        unless allow_invalid is true
          ensure "exists", current_value,
            "Path #{fields[0..index].join "."} doesn't exist in doc:\n#{json doc}"
        current_doc = nextDoc current_value, field
    if ensure.test "function", replace
      current_value = replace current_value
    current_value
