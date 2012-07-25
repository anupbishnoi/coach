_.mixin _.str.exports()

_.mixin
  json: (obj, ugly_print)->
    try
      if _.isString obj
        obj
      else
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
      "undefined"
      "null"
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
      "not_defined":
        name: "not defined (either null or undefined)"
        check: (v)-> (types.null.check v) or
                     (types.undefined.check v)
      "defined":
        name: "defined (neither null nor undefined)"
        check: (v)-> not (types.not_defined.check v)
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
        check: (s)-> (types.undefined.check s) or
                     (types.string.check s)
      "non_empty_string_if_defined":
        name: "a non-empty string, if defined"
        check: (s)-> (types.undefined.check s) or
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
        check: (b)-> (types.undefined.check b) or
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

    stack = []
    stack.max_size = 1000

    [ EnsureException, AssertException, TypeException ] = (->
      constructor_function = (type)->
        (problem)->
          this.type = type
          this.message = problem

      toString_function = ->
        this.type + (if this.message then ": #{this.message}" else "")

      exceptions =
        _.map [ "EnsureException"
                "AssertException"
                "TypeException" ]
        , constructor_function

      _.each exceptions
      , (exception)-> exception.prototype.toString = toString_function
      exceptions
    )()

    checkItem = (item, value, message, exception, inverse)->
      unless types.non_empty_string.check item
        throw new EnsureException "Invalid checking type name: #{_.json item}"
      unless types.defined.check types[item]
        throw new EnsureException "No matching checking type found for: #{item}"
      unless types.string_if_defined.check message
        throw new EnsureException "Exception message should be a string: #{message}"
      if types.defined.check message
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
              checkItem item
              , value
              , message
              , exception
              , inverse
            catch e
              es.push e
          unless es.length < what.length
            throw es[0]
        else
          checkItem what
          , value
          , message
          , exception
          , inverse
        true
      catch exception
        exception.message += "\n\n" + _.json fn.stack()
        throw exception

    fn.not = (what, value, message, exception)->
      fn what
      , value
      , message
      , exception
      , true

    fn.test = (what, value, inverse)->
      succeeded = if inverse is true then false else true
      try
        fn what
        , value
        succeeded
      catch exception
        not succeeded

    fn.test.not = (what, value)->
      fn.test what
      , value
      , true

    fn.error = (message)->
      fn "false"
      , true
      , message

    fn.types = (type, obj)->
      fn "string", type
      fn "defined", obj
      fn "string", obj.name
      fn "function", obj.check

      fn "undefined", types[type]
      , "Proposed type already exists: #{type}"

      {name, check} = obj
      check = _.wrap check
      , (check, v)->
        try
          check(v)
        catch exception
          throw new TypeException "#{_.json v}" +
            " is not: #{types[type].name}"
      types[type] = {name, check}
      true

    fn.inside = (function_name, args)->
      fn "non_empty_string", function_name

      str = "function: #{function_name}"
      unless types.undefined.check args
        fn "arguments", args
        str += "\narguments: #{_.json _.toArray args}"
      stack.push str
      if stack.length > stack.max_size
        stack.splice(0, 1)
      undefined

    fn.stack = (how_many)->
      unless _.isNumber how_many
        how_many = 20
      stack[stack.length-how_many...stack.length].join "\n-----\n"

    fn.stack.last = -> _.last stack

    fn.stack.size = (size)->
      if fn.test "positive_number", size
        stack.max_size = size
        if stack.length > stack.max_size
          stack.splice(0, stack.length - stack.max_size)
          undefined
      else
        stack.length

    fn.stack.empty = ->
      stack = []
      undefined

    fn
  )()

((log, json, ensure, its, inside, error)->
  _.mixin
    match: (arr, spec, minimum_initial, func_identifier, func_inside)->
      if its "non_empty_string", minimum_initial
        func_valid = true
        func_inside = func_identifier
        func_identifier = minimum_initial
        minimum_initial = 0
      func_valid or= its "non_empty_string", func_identifier
      if func_valid and func_inside isnt false
        inside func_identifier, arr
      else
        inside "_.match", arguments
      arr = _.toArray arr if its "arguments", arr
      ensure "array", arr
      , "Need supplied arguments to be an array"
      ensure "array", spec
      , "Type specification must be an array"
      i = j = 0
      ret = []
      while its "defined", arr[i]
        if (its.not "defined", spec[j]) or
           (its spec[j], arr[i])
          ret.push arr[i]
          i++
          j++
        else
          ret.push null
          j++
      if its "positive_integer", minimum_initial
        str = "Invalid arguments"
        str += " to #{func_identifier}" if func_valid
        str += "\nArguments: #{json arr}" +
               "\nShould've been: #{json spec}" +
               "\nwith minimum initial arguments: #{minimum_initial}"
        ok = true
        for i in [0...minimum_initial]
          if (arr[i] isnt ret[i]) or
             (i >= arr.length)
            ok = false
            break
        ensure "true"
        , ok
        , str
      ret

  _.mixin
    keyValueAdder: ->
      [ resource, value_type, func_identifier, overwrite ] =
        _.match arguments
        , [ "object"
            [ "non_empty_string"
              "array" ]
            "string"
            "boolean" ]
        , 2
        , "_.keyValueAdder"

      text = (msg, args)->
        if its "non_empty_string", func_identifier
          msg += "\n#{func_identifier}\n#{json _.toArray args}"
        msg

      add = (key, value)->
        if (its "object", resource[key]) and
           (its "object", value)
          resource[key] = _.extend (_.clone resource[key])
                          , value
        else if (its "defined", resource[key]) and
                (overwrite is not true)
          error text "Key already exists: #{key}"
        else
          resource[key] = value
        true

      (key, value)->
        inside func_identifier, arguments if func_identifier
        if its value_type, value
          if its "non_empty_string", key
            add key
            , value
          else if its "array", key
            for k in key
              ensure "non_empty_string", k
              , "Key must be a string"
              add k
              , value
          else
            error text "Invalid argument format", arguments
        else if its "object", key
          for own k, v of key
            ensure value_type, v
            , "Value supplied needs to be of type: #{value_type}"
            add k
            , v
        else if its "non_empty_string", key
          ensure.not "defined", value
          , "Invalid type of value supplied for key: #{key}"
          resource[key]
        else
          error text "Invalid argument format" , arguments

  _.mixin
    initialDefined: ->
      [ arr ] = _.match arguments
                , [ "array" ]
                , 1
                , "_.initialDefined"
      i = 0
      i++ while its "defined", arr[i]
      arr[0...i]

    onlyDefined: ->
      [ arr ] = _.match arguments
                , [ "array" ]
                , 1
                , "_.onlyDefined"
      _.filter arr
      , (v)-> its "defined", v

    objectify: ->
      [ keys, values, value_type, ignore_exceptions ] =
        _.match arguments
        , [ "array"
            "array"
            [ "string"
              "array"  ]
            "boolean" ]
        , 1
        , "_.objectify"
      obj = {}
      if not values
        combined = keys
        keys = _.filter combined
        , (v, i)-> i % 2 is 0
        values = _.filter combined
        , (v, i)-> i % 2 is 1

      for key, i in keys
        ensure "string", key
        , "Key to objectify must be a string"
        ok = true
        if value_type
          ensure "type", value_type
          , "Invalide value type"
          ok =
            if ignore_exceptions is true
              its value_type, values[i]
            else
              ensure value_type, values[i]
              , "Value no. #{i} not of type: #{value_type}"
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
      key_name or= "key"
      value_name or= "value"
      keys = _.keys obj
      _.onlyDefined _.map keys
                    , (key)->
                        if allow_undefined is true or
                           its "defined", obj[key]
                          o = {}
                          o[key_name] = key
                          o[value_name] = obj[key]
                          o

    sum: ->
      [ num_arr ] = _.match arguments
                    , [ "array" ]
                    , 1
                    , "_.sum"
      sum = (total, num)->
        ensure "number", num
        , "Only numbers can be summed"
        total + num

      _.reduce num_arr, sum, 0

    printable: (thing)->
      if its "string", thing
        _.titleize _.humanize thing
      else if its "number", thing
        "#{thing}"
      else if its "array", thing
        _.map thing
        , (item)->
          _.printable item
      else if its "object", thing
        _.map (_.keys thing)
        , (key)->
          field: key
          value: _.printable thing[key]

    date: (d)->
      ensure [ "date", "integer" ], d
      if its "integer", d
        d = new Date d
      months = ["Jan","Feb","Mar","Apr","May","Jun"
               ,"Jul","Aug","Sep","Oct","Nov","Dec"]
      "#{d.getDate()} #{months[d.getMonth()]} #{d.getFullYear()}"
    time: (d, lower_case)->
      ensure [ "date", "integer" ], d
      if its "integer", d
        d = new Date d
      hour = d.getHours()
      minutes = d.getMinutes()
      ampm = "AM"
      ampm = "PM" if hour > 11
      ampm = ampm.toLowerCase() if lower_case is true
      hour -= 12 if hour > 12
      hour = 12 if hour is 0
      "#{hour}:#{if minutes < 10 then "0" else ""}#{minutes} #{ampm}"

    self: (arg)-> arg

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
      nextDoc or= _.self
      current_doc = doc
      for field, index in fields
        current_value = current_doc[field]
        if its "defined", current_value
          if fields.length > index + 1
            current_doc = nextDoc current_value, field
        else
          unless allow_invalid
            ensure.error "Path #{fields[0..index].join "."} " +
              "doesn't exist in doc:\n#{json doc}"
          break
      current_value = replace current_value if replace
      current_value

    keywords: (->
      breakString = (str)->
        if its "string", str
          str = str.toLowerCase()
          _.filter (_.words str.replace /[^A-Za-z0-9]/g, " ")
          , (word)-> word.length > 2
        else if its "boolean", str
          "#{str}"
        else if its "number", str
          _.keywords "#{str}"
        else
          []
      (arg)->
        if its "string", arg
          breakString arg
        else if its "array", arg
          _.uniq _.flatten _.map arg
                           , (item)->
                             breakString item
        else if its "object", arg
          _.uniq _.flatten [ _.keywords _.keys arg
                             _.keywords _.values arg ]
    )()

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
