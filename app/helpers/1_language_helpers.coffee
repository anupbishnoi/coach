_.mixin _.str.exports()

_.mixin
  json: (obj, ugly_print)->
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

_.mixin
  log: (obj, pretty)->
    str = _.json obj
          , not pretty
    console.log str
    str

_.mixin
  ensure: (->
    types = {}
    from_underscore = [
      "empty"
      "string"
      "boolean"
      "array"
      "arguments"
      "function"
      "date"
    ]
    _.each from_underscore, (type)->
      types[type] =
        name: "#{type} (says underscore)"
        check: (value)-> _["is#{_.capitalize type}"] value

    more_types =
      "defined":
        name: "defined (neither null nor undefined)"
        check: (v)-> v?
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
      "non_empty_string":
        name: "a non-empty string"
        check: (s)-> (types.string.check s) and
                     (not _.isBlank s)
      "string_if_defined":
        name: "a string, if defined"
        check: (s)-> (not types.defined.check s) or
                     (types.string.check s)
      "non_empty_string_if_defined":
        name: "a non-empty string, if defined"
        check: (s)-> (not types.defined.check s) or
                     (types.non_empty_string.check s)
      "blank":
        name: "a blank string"
        check: (s)-> (types.string.check s) and
                     (_.isBlank s)
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
      "numeric":
        name: "a numeric value (can be a string representation)"
        check: (n)-> (not isNaN parseFloat n) and
                     (isFinite n)
      "positive_number":
        name: "a positive number"
        check: (n)-> (types.number.check n) and
                     (n > 0)
      "negative_number":
        name: "a negative number"
        check: (n)-> (types.number.check n) and
                     (n < 0)
      "positive_integer":
        name: "a positive integer"
        check: (n)-> (types.integer.check n) and
                     (n > 0)
      "negative_integer":
        name: "a negative integer"
        check: (n)-> (types.integer.check n) and
                     (n < 0)
      "boolean_if_defined":
        name: "a boolean, if defined"
        check: (b)-> (not types.defined.check b) or
                     (types.boolean.check b)
      "object":
        name: "an object"
        check: (obj)-> (types.defined.check obj) and
                       (typeof obj is "object") and
                       not (types.array.check obj)
      "non_empty_object":
        name: "a non-empty object"
        check: (obj)-> (types.object.check obj) and
                       (not _.isEmpty obj)
      "type":
        name: "a value type"
        check: (type)-> (types.string.check type) and
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

    fn = (what, value, message, exception_type, inverse, just_checking)->
      exception = null

      if types.function.check message
        message_func = message
        exception_type ?= "AssertException"
      else if types.non_empty_string.check message
        message_func = -> message
        exception_type ?= "AssertException"
      else if not types.defined.check message
        message_func = -> "#{_.json value} is not: #{_.json what}"
        exception_type ?= "TypeException"
      else
        exception ?= new e "EnsureException"
                         , "Exception message needs to be a string or function: #{_.json message}"

      getException = (item) ->
        if not types.defined.check types[item]
          new e "EnsureException"
              , "No matching checking type found for: #{_.json item}"
        else if xor (inverse isnt true), (types[item].check value)
          new e exception_type

      unless exception?
        if types.array.check what
          for item in what
            exception = getException item
            break if not exception
        else if types.string.check what
          exception ?= getException what
        else
          exception ?= new e "EnsureException"
                           , "Invalid checking type name: #{_.json what}"

      if exception?
        if just_checking is true
          false
        else
          exception.message = "#{message_func()}\n#{_.json fn.stack 5}"
          throw exception
      else
        true

    fn.not = (what, value, message, exception_type)->
      fn what
      , value
      , message
      , exception_type
      , true
      , false

    fn.test = fn.its = (what, value, inverse)->
      result = fn what
               , value
               , null
               , null
               , null
               , true
      result = not result if inverse is true
      result

    fn.test.not = (what, value)->
      fn.test what
      , value
      , true

    fn.error = (message)->
      if types.function.check message
        message = message()
      if types.non_empty_string.check message
        throw new e "AssertException", "#{message}\n\n#{fn.stack 2}"
      else
        throw new e "EnsureException"
                  , "Error message needs to be a string or function: #{_.json message}\n\n#{fn.stack 2}"

    fn.types = (type, obj)->
      fn "non_empty_string", type
      , -> "Type name needs to be a non-empty string: #{_.json type}"
      if fn.test "function", obj
        obj =
          name: (_s.titleize _s.humanize type)
          check: obj
      else
        fn "object", obj
        , -> "No valid type definition specified for: #{type}"
        obj.name ?= (_s.titleize _s.humanize type)
        fn "non_empty_string", obj.name
        , -> "Type name needs to be a non-empty string: #{obj.name}"
        fn "function", obj.check
        , -> "Need a type checking function for type: #{type}"

      fn.not "defined", types[type]
      , -> "Proposed type already exists: #{type}"

      { name, check } = obj
      check = _.wrap check
      , (check, v)->
          try
            check(v)
          catch exception
            throw new e "TypeException"
                      , "#{_.json v} is not: #{types[type].name}"
      types[type] = { name, check }
      true

    stack = []
    stack.max_size = 100

    fn.inside = (func_identifier, args)->
      str = "inside: #{_.json func_identifier}"
      if types.defined.check args
        args = _.toArray args unless fn.test "array", args
        str += "\nwith: #{_.json args}"
      stack = [ str ].concat stack
      if stack.length > stack.max_size
        stack.length -= 1
      true

    fn.stack = (how_many)->
      unless _.isNumber how_many
        how_many = 20
      stack[0...how_many].join "\n-----\n"

    fn.stack.size = (size)->
      if fn.test "positive_integer", size
        stack.max_size = size
        if stack.length > stack.max_size
          stack.length = stack.max_size
          true
      else
        stack.length

    fn.stack.empty = ->
      stack = []
      true
    fn
  )()

{ log, json, ensure } = _
{ its } = ensure

_.mixin
  match: (->
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
          ensure.inside func_identifier, arr
        else
          ensure.inside "match", arguments
      ensure "defined", arr
      , -> "Need an array of arguments: #{json arr}"
      arr = _.toArray arr if its "arguments", arr
      matched = []
      for spec, index in specs
        matched = matcher arr, spec
        ok = true
        if mins[index]
          for i in [0...mins[index]]
            if (arr[i] isnt matched[i]) or
               (i >= arr.length)
              ok = false
              break
        break if ok
      if not ok
        str = "Invalid arguments"
        str += " to #{func_identifier}" if func_identifier
        str += "\nArguments: #{json arr}"
        if specs.length is 1
          str += "\nShould've been: #{json specs[0]}"
          str += "\nwith minimum initial arguments: #{mins[0]}" if mins[0]?
        else if specs.length > 1
          str += "\nShould've been one of: #{json specs}"
          str += "\nwith minimum initial arguments: #{json mins}"
        ensure.error str
      if specs.length > 1
        [ index ].concat matched
      else
        matched
    fn
  )()

_.mixin
  keyValueAdder: ->
    [ resource, value_type, func_identifier, overwrite, callback ] =
      _.match arguments
      , [ "object"
          [ "non_empty_string"
            "array" ]
          "non_empty_string"
          "boolean"
          "function" ]
      , 2
      , "key_value_adder"

    text = (msg, args)->
      msg += "\n#{func_identifier}\n#{json args}" if func_identifier?
      msg

    add = (key, value)->
      if (its "object", resource[key]) and
         (its "object", value)
        _.extend resource[key]
        , value
      else if resource[key]? and not overwrite
        ensure.error text "Key already exists: #{key}"
      else
        resource[key] = value
      callback key, value if callback?
      true

    confirmAndAdd = (key, value) ->
      if its value_type, value
        add key, value
      else if its "function", value
        v = value key
        ensure value_type, v
        , -> "Supplied function returned an invalid value: #{json v}"
        add key, v
      else
        ensure.error text "Value supplied (#{json value}) needs to be of type: #{json value_type}"

    (key, value)->
      ensure.inside (func_identifier or "some key-value adder"), arguments
      if its "non_empty_string", key
        if value?
          confirmAndAdd key, value
        else
          resource[key]
      else if its "array", key
        for k in key
          ensure "non_empty_string", k
          , -> "Key must be a string: #{json key}"
          confirmAndAdd k, value
      else if its "object", key
        for own k, v of key
          confirmAndAdd k, v
      else
        ensure.error text "Invalid argument format", arguments

_.mixin
  initialDefined: ->
    [ arr ] = _.match arguments, [ "array" ], 1, "_.initialDefined"
    i = 0
    i++ while arr[i]?
    arr[0...i]
  truthy: ->
    [ arr ] = _.match arguments, [ "array" ], 1, "_.truthy"
    _.filter arr, _.identity

  sum: ->
    [ num_arr ] = _.match arguments, [ "array" ], 1, "sum"
    sum = (total, num)->
      ensure "number", num
      , -> "Only numbers can be summed. Not a number: #{json num}"
      total + num
    _.reduce num_arr, sum, 0
  evenOdd: ->
    [ arr ] = _.match arguments, [ "array" ], 1, "evenOdd"
    [ (v for v in arr[0..] by 2)
      (v for v in arr[1..] by 2) ]

_.mixin
  objectify: ->
    [ keys, values, value_type, ensure_type ] =
      _.match arguments
      , [ "array"
          "array"
          [ "string"
            "array"  ]
          "boolean" ]
      , 1
      , "objectify"
    obj = {}
    if not values
      [ keys, values ] = _.evenOdd keys
    for key, i in keys
      ensure "string", key
      , -> "Key to objectify must be a string: #{json key}"
      ok = true
      if value_type
        ensure "type", value_type
        , -> "Invalid value type: #{json value_type}"
        ok =
          if ensure_type
            ensure value_type, values[i]
            , -> "#{json values[i]} should've been of type: #{json value_type}"
          else
            its value_type, values[i]
      obj[key] = values[i] if ok
    obj

  breakApart: ->
    [ obj, key_name, value_name, allow_undefined ] =
      _.match arguments
      , [ "object"
          "string"
          "string"
          "boolean" ]
      , 1
      , "_.breakApart"
    key_name ?= "key"
    value_name ?= "value"
    keys = _.keys obj
    objs = _.map keys
           , (key)->
               if obj[key]? or allow_undefined 
                 o = {}
                 o[key_name] = key
                 o[value_name] = obj[key]
                 o
    _.compact objs

_.mixin
  printable: (thing)->
    if its "string", thing
      _s.titleize _s.humanize thing
    else if its "number", thing
      "#{thing}"
    else if its "array", thing
      _.map thing
      , _.printable
    else if its "object", thing
      _.map (_.keys thing)
      , (key)->
          field: key
          value: _.printable thing[key]
    else
      ""

  keywords: (arg) ->
    breakString = (str) ->
      if its "string", str
        str = str.toLowerCase()
        _.filter (_s.words str.replace /[^A-Za-z0-9]/g, " ")
        , (word)-> word.length > 2
      else if its "boolean", str
        "#{str}"
      else if its "number", str
        _.keywords "#{str}"
      else
        []
    if its "array", arg
      _.uniq _.flatten _.map arg
                       , _.keywords
    else if its "object", arg
      _.uniq _.flatten [ _.keywords _.keys arg
                         _.keywords _.values arg ]
    else
      breakString arg

  findValue: ->
    [ fields, doc, nextDoc, allow_invalid, replace ] =
      _.match arguments
      , [ "array"
          "object"
          "function"
          "boolean"
          "function" ]
      , 2
      , "_.findValue"
    nextDoc ?= _.identity
    current_doc = doc
    for field, i in fields
      ensure "defined", current_doc
      , -> "findValue#nextDoc returned nothing"
      if "." in field
        path = field.split "."
        current_value = _.findValue (field.split ".")
                        , current_doc
                        , true
      else
        field = (+field) if its "numeric", field
        current_value = current_doc[field]
      if current_value?
        if fields.length > i + 1
          current_doc = nextDoc current_value, field
      else
        unless allow_invalid
          ensure.error ->
            "Value #{fields[0..i].join " -> "} doesn't exist for doc:\n#{json doc}"
        break
    current_value = replace current_value if replace
    current_value

