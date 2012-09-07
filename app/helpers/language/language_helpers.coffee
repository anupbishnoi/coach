Str = _.str
Str.printable = (thing) ->
  if its "string", thing
    Str.titleize Str.humanize thing
  else if its "number", thing
    "#{thing}"
  else if its "array", thing
    _.map thing
    , Str.printable
  else if its "object", thing
    _.map (_.keys thing)
    , (key) ->
        field: key
        value: Str.printable thing[key]
  else
    ""
Str.uptilFirst = (char, str) ->
  try str.split(char)[0] catch e
    ""
Str.afterFirst = (char, str) ->
  try str.split(char)[1..].join(char) catch e
    ""

Json = (obj, ugly_print) ->
  try
    if _.isString obj
      obj
    else
      obj = _.toArray obj if _.isArguments obj
      if ugly_print is true
        JSON.stringify obj
      else 
        JSON.stringify obj
        , null
        , 2
  catch exception
    obj

Log = (obj, pretty) ->
  str = Json obj
        , not pretty
  console.log str
  str

Ensure = (->
  types = {}
  from_underscore = [
    "null"
    "undefined"
    "empty"
    "string"
    "boolean"
    "array"
    "arguments"
    "function"
    "date"
  ]
  _.each from_underscore, (type) ->
    types[type] =
      name: "#{type} (says underscore)"
      check: (value) -> _["is#{Str.capitalize type}"] value

  more_types =
    "defined":
      name: "defined (neither null nor undefined)"
      check: (v) -> v?
    "true":
      name: "true"
      check: (v) -> v is true
    "false":
      name: "false"
      check: (v) -> v is false
    "falsey":
      name: "falsy"
      check: (v) -> not v
    "truthy":
      name: "truthy"
      check: (v) -> not (types.falsey.check v)
    "non_empty_string":
      name: "a non-empty string"
      check: (s) -> (types.string.check s) and
                   (not Str.isBlank s)
    "string_if_defined":
      name: "a string, if defined"
      check: (s) -> (not types.defined.check s) or
                   (types.string.check s)
    "non_empty_string_if_defined":
      name: "a non-empty string, if defined"
      check: (s) -> (not types.defined.check s) or
                   (types.non_empty_string.check s)
    "blank":
      name: "a blank string"
      check: (s) -> (types.string.check s) and
                   (Str.isBlank s)
    "number":
      name: "a number"
      check: (n) -> (_.isNumber n) and (not _.isNaN n)
    "integer":
      name: "an integer"
      check: (n) -> (types.number.check n) and
                   ((parseFloat n) is (parseInt n))
    "decimal":
      name: "a decimal number"
      check: (n) -> (types.number.check n) and
                   not (types.integer.check n)
    "numeric":
      name: "a numeric value (can be a string representation)"
      check: (n) -> (not isNaN parseFloat n) and
                   (isFinite n)
    "positive_number":
      name: "a positive number"
      check: (n) -> (types.number.check n) and
                   (n > 0)
    "negative_number":
      name: "a negative number"
      check: (n) -> (types.number.check n) and
                   (n < 0)
    "positive_integer":
      name: "a positive integer"
      check: (n) -> (types.integer.check n) and
                   (n > 0)
    "negative_integer":
      name: "a negative integer"
      check: (n) -> (types.integer.check n) and
                   (n < 0)
    "boolean_if_defined":
      name: "a boolean, if defined"
      check: (b) -> (not types.defined.check b) or
                   (types.boolean.check b)
    "object":
      name: "an object"
      check: (obj) -> (types.defined.check obj) and
                     (typeof obj is "object") and
                     not (types.array.check obj)
    "non_empty_object":
      name: "a non-empty object"
      check: (obj) -> (types.object.check obj) and
                     (not _.isEmpty obj)
    "type":
      name: "a value type"
      check: (type) -> (types.string.check type) and
                      (types.defined.check types[type])
  _.extend types
  , more_types

  e = (type, message) ->
    @type = type
    @message = message
  e::toString = ->
    @type + (if @message then ": #{@message}" else "")

  xor = (one, two) ->
    if one and two
      false
    else if not one and not two
      false
    else
      true

  getException = (type, value, inverse, exception_type) ->
    if not types.defined.check types[type]
      new e "EnsureException"
          , "No matching checking type found for: #{Json type}"
    else if xor (inverse isnt true), (types[type].check value)
      new e exception_type

  fn = (what, value, message, exception_type, inverse, just_checking) ->
    exception = null

    if types.function.check message
      message_func = message
      exception_type ?= "AssertException"
    else if types.non_empty_string.check message
      message_func = -> message
      exception_type ?= "AssertException"
    else if not types.defined.check message
      message_func = -> "#{Json value} is not: #{Json what}"
      exception_type ?= "TypeException"
    else
      exception ?= new e "EnsureException"
                       , "Exception message needs to be a string or function: #{Json message}"

    unless exception?
      if types.array.check what
        for item in what
          exception = getException item, value, inverse, exception_type
          break if not exception
      else if types.string.check what
        exception ?= getException what, value, inverse, exception_type
      else
        exception ?= new e "EnsureException"
                         , "Invalid checking type name: #{Json what}"

    if exception?
      if just_checking is true
        false
      else
        exception.message = "#{message_func()}\n#{Json fn.stack 5}"
        throw exception
    else
      true

  fn.not = (what, value, message, exception_type) ->
    fn what
    , value
    , message
    , exception_type
    , true
    , false

  fn.test = (what, value, inverse) ->
    result = fn what
             , value
             , null
             , null
             , null
             , true
    result = not result if inverse is true
    result

  fn.test.not = (what, value) ->
    fn.test what
    , value
    , true

  fn.error = (message) ->
    if types.function.check message
      message = message()
    if types.non_empty_string.check message
      throw new e "AssertException", "#{message}\n\n#{fn.stack 2}"
    else
      throw new e "EnsureException"
                , "Error message needs to be a string or function: #{Json message}\n\n#{fn.stack 2}"

  fn.types = (type, obj) ->
    fn "non_empty_string", type
    , -> "Type name needs to be a non-empty string: #{Json type}"
    if fn.test "function", obj
      obj =
        name: (Str.titleize Str.humanize type)
        check: obj
    else
      fn "object", obj
      , -> "No valid type definition specified for: #{type}"
      obj.name ?= (Str.titleize Str.humanize type)
      fn "non_empty_string", obj.name
      , -> "Type name needs to be a non-empty string: #{obj.name}"
      fn "function", obj.check
      , -> "Need a type checking function for type: #{type}"

    fn.not "defined", types[type]
    , -> "Proposed type already exists: #{type}"

    { name, check } = obj
    check = _.wrap check
    , (check, v) ->
        try
          check(v)
        catch exception
          throw new e "TypeException"
                    , "#{Json v} is not: #{types[type].name}"
    types[type] = { name, check }
    true

  stack = []
  stack.max_size = 100

  fn.inside = (func_identifier, args) ->
    str = "inside: #{Json func_identifier}"
    if types.defined.check args
      args = _.toArray args unless fn.test "array", args
      str += "\nwith: #{Json args}"
    stack = [ str ].concat stack
    if stack.length > stack.max_size
      stack.length -= 1
    true

  fn.stack = (how_many) ->
    how_many = 20 unless _.isNumber how_many
    stack[0...how_many].join "\n-----\n"

  fn.stack.size = (size) ->
    if fn.test "positive_integer", size
      stack.max_size = size
      if stack.length > stack.max_size
        stack.length = stack.max_size
        true
    else
      stack.length

  fn.stack.forget = (how_many) ->
    how_many = 1 unless _.isNumber how_many
    stack = stack[how_many..]

  fn.stack.empty = ->
    stack = []
    true

  fn
)()
its = Ensure.test

Match = (->
  matcher = (arr, spec) ->
    i = j = 0
    ret = []
    while arr[i]?
      if (not spec[j]?) or
         (its spec[j], arr[i])
        ret.push arr[i]
        i++
        j++
      else
        ret.push null
        j++
    ret

  fn = ->
    args = _.toArray arguments
    arr = args[0]
    arr = _.toArray arr if its "arguments", arr
    specs = []
    mins = []
    i = 1
    while its "array", args[i]
      specs.push args[i]
      i++
      if its "integer", args[i]
        mins.push args[i]
        i++
      else
        mins.push null
    if its "non_empty_string", args[i]
      func_identifier = args[i]
      i++
    if its "boolean", args[i]
      no_inside = args[i]
      i++
    unless no_inside
      if func_identifier
        Ensure.inside func_identifier, arr
        Log in: func_identifier, with: arr if debug
      else
        Ensure.inside "Match", arguments
        Log in: "Match", with: arguments if debug
    Ensure "defined", arr
    , -> "Need an array of arguments: #{Json arr}"
    matched = []
    for spec, index in specs
      matched = matcher arr, spec
      ok = true
      if mins[index] # so it would fail for 0 as well
        for i in [0...mins[index]]
          if (arr[i] isnt matched[i]) or
             (i >= arr.length) or
             (i >= matched.length)
            ok = false
            break
      break if ok
    if not ok
      str = "Invalid arguments"
      str += " to #{func_identifier}" if func_identifier
      str += "\nArguments: #{Json arr}"
      if specs.length is 1
        str += "\nShould've been: #{Json specs[0]}"
        str += "\nwith minimum initial arguments: #{mins[0]}" if mins[0]?
      else if specs.length > 1
        str += "\nShould've been one of: #{Json specs}"
        str += "\nwith minimum initial arguments: #{Json mins}"
      Ensure.error str
    if specs.length > 1
      [ index ].concat matched
    else
      matched

  debug = no
  fn.debug = -> debug = yes
  fn.debug.stop = -> debug = no

  fn
)()

KeyValueAdder = ->
  [ resource, value_type, func_identifier, overwrite, callback ] =
    Match arguments
    , [ "object"
        [ "non_empty_string"
          "null"
          "array" ]
        "non_empty_string"
        "boolean"
        "function" ]
    , 2
    , "KeyValueAdder"

  text = (msg, args) ->
    msg += "\n#{func_identifier}\n#{Json args}" if func_identifier?
    msg

  add = (key, value) ->
    if (its "object", resource[key]) and
       (its "object", value)
      _.extend resource[key]
      , value
    else if resource[key]? and not overwrite
      Ensure.error text "Key already exists: #{key}"
    else
      resource[key] = value
    callback key, resource if callback?
    true

  fn = (key, value) ->
    Ensure.inside (func_identifier or "some key-value adder"), arguments
    if its "non_empty_string", key
      if its value_type, value
        add key, value
      else if its "function", value
        v = value key
        Ensure value_type, v
        , -> "Supplied function returned an invalid value: #{Json v}"
        add key, v
      else
        Ensure.error text "Value supplied (#{Json value}) needs to be of type: #{Json value_type}"
    else if its "array", key
      for k in key
        Ensure "non_empty_string", k
        , -> "Key must be a string: #{Json key}"
        fn k, value
    else if its "object", key
      for own k, v of key
        fn k, v
    else
      Ensure.error text "Invalid argument format", arguments

Arr =
  initialDefined: ->
    [ arr ] = Match arguments, [ "array" ], 1, "Arr.initialDefined"
    i = 0
    i++ while arr[i]?
    arr[0...i]
  truthy: ->
    [ arr ] = Match arguments, [ "array" ], 1, "Arr.truthy"
    _.filter arr, _.identity
  sum: ->
    [ num_arr ] = Match arguments, [ "array" ], 1, "Arr.sum"
    sum = (total, num) ->
      Ensure "number", num
      , -> "Only numbers can be summed. Not a number: #{Json num}"
      total + num
    _.reduce num_arr, sum, 0
  evenOdd: ->
    [ arr ] = Match arguments, [ "array" ], 1, "Arr.evenOdd"
    [ (v for v in arr[0..] by 2)
      (v for v in arr[1..] by 2) ]
  objectify: ->
    [ keys, values, value_type, ensure_type ] =
      Match arguments
      , [ "array"
          "array"
          [ "string"
            "array"  ]
          "boolean" ]
      , 1
      , "Arr.objectify"
    obj = {}
    if not values
      [ keys, values ] = Arr.evenOdd keys
    for key, i in keys
      Ensure "string", key
      , -> "Key to objectify must be a string: #{Json key}"
      ok = true
      if value_type
        Ensure "type", value_type
        , -> "Invalid value type: #{Json value_type}"
        ok =
          if ensure_type
            Ensure value_type, values[i]
            , -> "#{Json values[i]} should've been of type: #{Json value_type}"
          else
            its value_type, values[i]
      obj[key] = values[i] if ok
    obj

Obj =
  breakApart: ->
    [ obj, key_name, value_name, allow_undefined ] =
      Match arguments
      , [ "object"
          "string"
          "string"
          "boolean" ]
      , 1
      , "Obj.breakApart"
    key_name ?= "key"
    value_name ?= "value"
    keys = _.keys obj
    objs = _.map keys
           , (key) ->
               if obj[key]? or allow_undefined 
                 o = {}
                 o[key_name] = key
                 o[value_name] = obj[key]
                 o
    _.compact objs

Keywords = (arg) ->
  breakString = (str) ->
    if its "string", str
      str = str.toLowerCase()
      _.filter (Str.words str.replace /[^A-Za-z0-9]/g, " ")
      , (word) -> word.length > 2
    else if its "boolean", str
      "#{str}"
    else if its "number", str
      Keywords "#{str}"
    else
      []

  if its "array", arg
    _.uniq _.flatten _.map arg
                     , Keywords
  else if its "object", arg
    _.uniq _.flatten [ Keywords _.keys arg
                       Keywords _.values arg ]
  else
    breakString arg
