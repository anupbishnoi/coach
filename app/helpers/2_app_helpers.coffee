App = {}

((log, json, ensure, its, inside, error)->
  App.org = (->
    #todo later: auth stuff here
    "vmc"
  )()

  App.docIds = ->
    [ docs, allow_invalid ] =
      _.match arguments
      , [ "array"
          "boolean" ]
      , 1
      , "App.docIds"
    _.map docs
    , (doc)->
      if allow_invalid
        doc or= {}
      else
        ensure "object", doc
        ensure "non_empty_string", doc.doc_id
        ensure "non_empty_string", doc.id
        ensure "true"
        , (_.last doc.doc_id.split "/") is doc.id
      doc.id

  App.collection = (->
    collections = {}

    add = (name)->
      ensure "non_empty_string", name
      ensure.not "defined", collections[name]
      , "Collection '#{name}' already defined."
      collections[name] = new Meteor.Collection(name)
      ensure.types name
      , name: (_.printable name)
      , check: (doc_id)->
          ensure "string", doc_id
          (App.find.count name, {doc_id}) isnt 0

    fn = (name)->
      ensure "non_empty_string"
      , name
      , "Collection name needs to be a non-empty string"
      ensure "defined", collections[name]
      , "No such collection found: #{name}"
      collections[name]

    fn.add = (name)->
      if its "array", name
        for collection_name in name
          add collection_name
      else
        add name

    fn.list = -> _.keys collections

    fn
  )()

  App.find = (->
    defaults = {}

    checkSanityIn = ->
      [ func_identifier, args, allow_invalid ] =
        _.match arguments
        , [ "string"
            "arguments"
            "boolean" ]
        , 2
        , "App.find#checkSanityIn"
        , false
      [ what, selector, options, filter ] =
        _.match args
        , [ "non_empty_string"
            "object"
            "object"
            "function" ]
        , 1
        , "App.find#{func_identifier}"
      selector or= {}
      options or= {}
      unless allow_invalid
        ensure "defined", App.collection(what)
        , "Invalid thing to be searching for: #{what}"
      if its "defined", defaults[what]
        selector = _.defaults (_.clone selector)
                   , defaults[what]
      [ what, selector, options, filter ]

    fn = ->
      [ what, selector, options ] =
        checkSanityIn "" , arguments
      App.collection(what)
         .find(selector, options)
         .fetch()

    fn.cursor = ->
      [ what, selector, options ] =
        checkSanityIn ".cursor", arguments
      App.collection(what)
         .find(selector, options)
    
    fn.if = ->
      [ what, selector, options ] =
        checkSanityIn ".if", arguments, true
      if its "defined", App.collection(what)
        fn what
        , selector
        , options
      else
        []

    fn.count = ->
      [ what, selector, options ] =
        checkSanityIn ".count", arguments
      fn.cursor(what, selector, options)
        .count()

    fn.one = ->
      [ what, selector, options ] =
        checkSanityIn ".one", arguments
      App.collection(what)
         .findOne(selector, options)

    fn.filter = ->
      [ what, selector, options, func ] =
        checkSanityIn ".filter", arguments
      ensure "defined", func
      _.filter (fn what
                , selector
                , options)
      , func

    fn.addDefaults = _.keyValueAdder defaults
                     , "object"
                     , "App.find.addDefault"
    fn
  )()

  App.docIdfy = (->
    parent = {}

    docId = (field, obj)->
      if _.str.include obj[field], "/"
        obj[field]
      else if field is "org"
        if its "defined", obj[field]
          obj[field]
        else
          App.org
      else
        parent_type = parent[field]
        ensure "defined", parent_type
        , "#{field} needs a parent type"
        if its "string", parent_type
          "#{docId parent_type, obj}/#{obj[field]}"
        else
          ensure "array", parent_type
          , "Parent type of #{field} must be either string or array: #{parent_type}"
          ids = _.map parent_type
                , (coparent)-> "[#{docId coparent, obj}]"
          "#{docId "org", obj}/#{ids.join "."}/#{obj[field]}"

    fn = (obj)->
      [ obj ] = _.match arguments
                , [ "object" ]
                , 1
                , "App.docIdfy"
      selector = _.clone obj
      fasterDocId = _.memoize docId

      for own field of selector
        value = fasterDocId field, obj
        if its "non_empty_string", value
          selector[field] = "#{field}/#{value}"
      selector

    fn.addParent = _.keyValueAdder parent
                   , [ "non_empty_string", "array" ]
                   , "App.docIdfy.addParent"
    fn
  )()

  App.map = (->
    maps = {}

    recurse = ->
      [ current, doc, initial, index_str ] =
        _.match arguments
        , [ [ "string"
              "object"
              "array" ]
            "object"
            "object"
            "string" ]
        , 2
        , "App.map#recurse"
        , false
      if its "string", current
        if (_.startsWith current, "'") and
           (_.endsWith current, "'")
          value = current[1...-1]
        else
          value = App.get current
                  , doc
      else if its "object", current
        obj = initial or {}
        for own key, spec of current
          obj[key] = recurse spec
                     , doc
                     , index_str
        value = obj
      else if its "array", current
        value = _.map current
                , (spec)->
                    recurse spec
                    , doc
                    , index_str

    fn = ->
      [ docs, index_str, include_original ] =
        _.match arguments
        , [ "array"
            "non_empty_string"
            "boolean" ]
        , 2
        , "App.map"
      ensure "defined", maps[index_str]
      , "No such map found: #{index_str}"
      mapped = _.map docs
      , (doc)->
          ensure "object", doc
          if include_original is true
            recurse maps[index_str]
            , doc
            , doc
            , index_str
          else
            recurse maps[index_str]
            , doc
            , index_str
      map_funcs = _.filter (_.toArray arguments)[2..]
                  , (func)-> its "function", func
      _.map mapped
      , (doc)->
          _.each map_funcs 
          , (func)-> doc = func doc
          doc

    fn.add =
      _.keyValueAdder maps
      , [ "non_empty_string"
          "object"
          "array" ]
      , "App.map.addMapper"
    fn
  )()


  App.get = (->
    alternate = {}
    mapped_fields = {}

    memoized = ->
      [ calculate, first_value, rest_path, memo ] =
        _.match arguments
        , [ "function"
            "non_empty_string"
            "array"
            "object" ]
        , 2
        , "App.get#memoized"
      if rest_path and rest_path.length > 0
        key = "#{first_value}/#{rest_path.join "/"}"
        if memo and its "defined", memo[key]
          memo[key]
        else
          v = calculate()
          memo[key] = v if memo
          v
      else
        calculate()

    deepValue = ->
      [ field, doc, memo ] =
        _.match arguments
        , [ "string"
            "object"
            "object" ]
        , 2
        , "App.get#deepValue"
      path = field.split "/"
      value_in_doc = doc[path[0]]
      if its "non_empty_string", value_in_doc
        findFunc = ->
          _.findValue path
          , doc
          , (value, field)->
              App.find.one field
              , doc_id: value
          , true
        memoized findFunc
        , value_in_doc
        , path[1..]
        , memo

    fn = ->
      [ field, doc, memo ] =
        _.match arguments
        , [ "non_empty_string"
            "object"
            "object" ]
        , 2
        , "App.get"
      ensure "non_empty_string", doc.doc_type
      , "Doc needs a doc_type: #{json doc}"

      v = deepValue field
          , doc
          , memo

      if its.not "defined", v
        mapped_obj = mapped_fields[doc.doc_type]
        if mapped_obj and mapped_obj[field]
          v = mapped_obj[field](doc)

        if its.not "defined", v
          alternate_doc_type = alternate[doc.doc_type]
          if alternate_doc_type
            v = deepValue "#{alternate_doc_type}/#{field}"
                , doc
                , memo
      v

    fn.addAlternate = _.keyValueAdder alternate
                      , "non_empty_string"
                      , "App.get.addAlternate"
    fn.addField = _.keyValueAdder mapped_fields
                  , "object"
                  , "App.get.addField"
    fn
  )()

  App.ui = (->
    funcs = {}

    fn = ->
      [ index_str, args ] =
        _.match arguments
        , [ "non_empty_string"
            null ]
        , 1
        , "App.ui"
      ensure "defined", funcs[index_str]
      , "No saved ui function found for: #{index_str}"
      funcs[index_str] args

    fn.add = _.keyValueAdder funcs
             , "function"
             , "App.ui.add"
    fn
  )()

  App.filter = (->
    searchables = {}

    fn = ->
      [ query, func_identifier ] =
        _.match arguments
        , [ "string"
            "non_empty_string" ]
        , 1
        , "App.filter"
      query_items = _.uniq _.keywords query
      memo = {}
      if query_items.length is 0
        -> true
      else
        (doc)->
          inside "#{func_identifier}#filter", arguments
          list = _.uniq _.flatten _.map searchables[doc.doc_type]
                                  , (field)->
                                      _.keywords App.get field
                                                 , doc
                                                 , memo
          found = []
          for item in query_items
            if _.include list, item
              found.push true
          found.length is query_items.length

    fn.addSearchable = _.keyValueAdder searchables
                       , "array"
                       , "App.filter.addSearchable"
    fn
  )()

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
