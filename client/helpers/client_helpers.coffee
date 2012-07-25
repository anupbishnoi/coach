((log, json, ensure, its, inside, error)->

  App.session = (->
    ensure.types "session_search"
    , name: "session variable for search"
    , check: (obj)->
      if its "defined", obj
        ensure "object", obj
        ensure "string_if_defined", obj.look_in
        ensure "string_if_defined", obj.query

    ensure.types "session_navigation"
    , name: "session variable for navigation"
    , check: (obj)->
      ensure "object", obj
      ensure "non_empty_string_if_defined", obj.search_for
      ensure "non_empty_string_if_defined", obj.view_as

    keys = []

    fn = ->
      [ key, value ] =
        _.match arguments
        , [ "non_empty_string"
            null ]
        , 1
        , "App.session"

      if its "defined", value
        ensure "session_#{key}", value
        , "Invalid value specified for '#{key}': #{json value}" +
          "\nShould have been of type: session_#{key}"
        keys.push key
        Session.set key, value
      else
        value = Session.get key
        ensure "session_#{key}", value
        , "Invalid value stored in session variable '#{key}': #{json value}"
        value

    fn.all = -> _.objectify keys
                , (Session.get(k) for k in keys)
    fn
  )()

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
