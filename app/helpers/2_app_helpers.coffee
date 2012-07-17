App = {}

((log, json, ensure, its, inside, error)->
  App.org = (->
    #todo later: auth stuff here
    "vmc"
  )()

  App.docIds = (docs, allow_invalid)->
    inside "App.docIds", arguments
    ensure "array", docs
    _.map docs
    , (doc)->
      if allow_invalid is true
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
      ensure "non_empty_string", name
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

    checkSanityIn = (func_identifier, args, allow_invalid)->
      [func_identifier, args, allow_invalid] =
        _.args arguments
        , [ "string", "arguments", "boolean" ]
        , 2
        , "App.find#checkSanityIn"
      [what, selector, options, filter] =
        _.args args
        , [ "non_empty_string"
            "object"
            "object"
            "function" ]
        , 1
        , "App.find#{func_identifier}"
        , true
      selector or= {}
      options or= {}
      unless allow_invalid
        ensure "defined", App.collection(what)
        , "Invalid thing to be searching for: #{what}"
      if its "defined", defaults[what]
        selector = _.defaults (_.clone selector)
                   , defaults[what]
      [what, selector, options, filter]

    fn = (what, selector, options)->
      [what, selector, options] =
        checkSanityIn "", arguments
      App.collection(what)
         .find(selector, options)
         .fetch()

    fn.cursor = ->
      [what, selector, options] =
        checkSanityIn ".cursor", arguments
      App.collection(what)
         .find(selector, options)
    
    fn.if = ->
      [what, selector, options] =
        checkSanityIn ".if", arguments, true
      if its "defined", App.collection(what)
        fn what
        , selector
        , options
      else
        []

    fn.count = ->
      [what, selector, options] =
        checkSanityIn ".count", arguments
      fn.cursor(what, selector, options)
        .count()

    fn.one = ->
      [what, selector, options] =
        checkSanityIn ".one", arguments
      App.collection(what)
         .findOne(selector, options)

    fn.filter = ->
      [what, selector, options, func] =
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
                , (coparent)->
                  "[#{docId coparent, obj}]"
          "#{docId "org", obj}/#{ids.join "."}/#{obj[field]}"

    fn = (obj)->
      inside "App.docIdfy", arguments
      ensure "object", obj
      selector = _.clone obj
      fasterDocId = _.memoize docId
      fn.ff = fasterDocId
      for own field of selector
        value = fasterDocId field, obj
        if its "non_empty_string", value
          selector[field] = "#{field}/#{value}"
      selector
    fn.p = parent
    fn.addParent = _.keyValueAdder parent
                   , ["non_empty_string", "array"]
                   , "App.docIdfy.addParent"
    fn
  )()

  App.map = (->
    maps = {}

    recurse = (current, doc, initial, index_str)->
      [current, doc, initial, index_str] =
        _.args arguments
        , [ ["string", "object", "array"]
            "object"
            "object"
            "string" ]
        , 2
        , "App.map#recurse"
      if its "string", current
        if (_.startsWith current, "#")
          value = App.get current
                  , doc
        else
          value = current
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

    fn = (docs, index_str, include_original)->
      inside "App.map", arguments
      ensure "array", docs
      ensure "non_empty_string", index_str
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
      , (func)->
        its "function", func

      _.map mapped
      , (doc)->
        _.each map_funcs 
        , (func)->
          doc = func doc
        doc

    fn.add = _.keyValueAdder maps
             , [ "string"
                 "object"
                 "array" ]
             , "App.map.add"

    fn
  )()

  App.get = (->
    alternate = {}
    mapped_fields = {}

    deepValue = (field_str, doc)->
      _.findValue (field_str.split "/")
      , doc
      , (value, field)->
        App.find.one field, doc_id: value

    fn = (field, doc)->
      inside "App.get", arguments
      ensure "non_empty_string", field
      ensure "object", doc
      ensure "non_empty_string", doc.doc_type
      field = field[1..] if _.startsWith field, "#"
      order =
        [ (field, doc)->
            deepValue field
            , doc
        , (field, doc)->
            alternate_fields = mapped_fields[doc.doc_type]
            if (its "defined", alternate_fields) and
               (its "defined", alternate_fields[field])
              ensure "function", alternate_fields[field]
              , "App.get.addField for #{doc.doc_type} needs a function for: #{field}"
              alternate_fields[field](doc)
        , (field, doc)->
            alternate_doc_type = alternate[doc.doc_type]
            if its "defined", alternate_doc_type
              alternate_doc = App.find.one alternate_doc_type
                              , doc_id: doc[alternate_doc_type]
              alternate_doc and deepValue field
                                , alternate_doc
        ]
      for func, i in order
        v = func field
            , doc
        break if its "defined", v
      v

    fn.addAlternate = _.keyValueAdder alternate
                      , "non_empty_string"
                      , "App.get.addAlternate"
    fn.addField = _.keyValueAdder mapped_fields
                  , ["string", "object"]
                  , "App.get.addField"
    fn
  )()

  App.ui = (->
    funcs = {}

    fn = (index_str, args)->
      inside "App.ui", arguments
      ensure "non_empty_string", index_str
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

    fn = (query, func_identifier)->
      [query, func_identifier] =
        _.args arguments
        , ["string", "non_empty_string"]
        , 1
        , true
      query_items = _.keywords query
      if query_items.length is 0
        -> true
      else
        (doc)->
          inside "#{func_identifier}#filter", arguments
          list = searchables[doc.doc_type]
          ensure "defined", list
          found = no
          for field in list
            value = _.keywords App.get field, doc
            found = (_.intersect query_items
                     , value)
                    .length > 0
            break if found
          found

    fn.addSearchable = _.keyValueAdder searchables
                        , "array"
                        , "App.filter.addSearchable"
    fn
  )()

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
