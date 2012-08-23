App = {}

App.collection = (->
  collections = {}
  fn = (name)->
    [ name ] = _.match arguments, [ "non_empty_string" ], 1, "app.collection"
    ensure "defined", collections[name]
    , -> "No such collection found: #{name}"
    collections[name]

  ensure.types "meteor_collection"
  , (obj) -> obj instanceof Meteor.Collection

  fn.add = _.keyValueAdder collections
           , "meteor_collection"
           , "collection.add"
  fn.list = -> _.keys collections
  fn.reset = -> collections[name].remove({}) for name in fn.list()
  fn
)()

## Single document (if the selector gets a doc_id field)
# Find "doc_type/center"
# Find "center/vmc/pp"
# Find "center", { doc_id: "center/vmc/pp" }
# Find { doc_type: "center", doc_id: "center/vmc/pp" }
#
## Multiple documents (otherwise)
# Find "doc_type", "center"
# Find "center"
# Find "class", "1" (org: "vmc" will be added by the defaults configuration)
# Find {doc_type: "center"}
App.find = (->
  default_mappings = {}
  parent_types = {}

  checkSanityIn = ->
    [ func_identifier, args, allow_invalid ] =
      _.match arguments
      , [ "string"
          "arguments"
          "boolean" ]
      , 2
      , "app.find#checkSanityIn"
      , false
    [ index, arg1, arg2, arg3, arg4 ] =
      _.match args
      , [ "non_empty_string"
          "object"
          "object"
          "function"         ], 2
      , [ "non_empty_string"
          "non_empty_string"
          "function"         ], 2
      , [ "non_empty_string"
          "function"         ], 1
      , [ "object"
          "function"         ], 1
      , "app.find#{func_identifier}"
    switch index
      when 0
        [ what, selector, options, filter ] =
          [ arg1, (_.clone arg2), arg3, arg4 ]
      when 1
        [ what, id, filter ] = [ arg1, arg2, arg3 ]
        if "/" in id
          selector = { doc_id: id }
        else
          selector = { id }
      when 2
        [ what, rest... ] = arg1.split "/"
        selector = if rest.length > 0 then doc_id: arg1 else {}
        filter = arg2
      when 3
        { doc_id, doc_type } = arg1
        if its "non_empty_string", doc_id
          [ what ] = doc_id.split "/"
          selector = { doc_id }
        else if its "non_empty_string", doc_type
          what = doc_type
          selector = {}
        else
          ensure.error "Object argument needed either doc_id or doc_type: #{json arg1}"
        filter = arg2
    selector ?= {}
    options ?= {}
    unless allow_invalid
      ensure "defined", (App.collection what)
      , -> "Invalid thing to be searching for: #{what}"
    if default_mappings[what]?
      _.defaults selector, default_mappings[what]

    docId = (field)->
      ensure "non_empty_string", selector[field]
      , -> "Value not found for field: #{field} in: #{json selector}"
      if (field is "org") or ("/" in selector[field]) or (not parent_types[field]?)
        # note that even if 'org' wasn't specified, it was added by the _.defaults above
        selector[field]
      else
        parent_type = parent_types[field]
        ensure "defined", parent_type
        , -> "#{field} needs a parent type"
        if its "string", parent_type
          "#{docId parent_type}/#{selector[field]}"
        else
          ensure "array", parent_type
          , -> "Parent type of #{field} must either be string or array: #{json parent_type}"
          ids = ("[#{docId coparent}]" for coparent in parent_type)
          extra_parents =
            (parent_types[p] for p in parent_type when parent_types[p] isnt parent_types[parent_type[0]])
          if extra_parents.length isnt 0
            ensure.error "#{parent_type.join ", "} don't have a common parent"
          "#{docId parent_list[0]}/#{ids.join "."}/#{selector[field]}"
      for own field of selector
        selector[field] = "#{field}/#{docId field}"
    [ index, what, selector, options, filter ]

  fn = ->
    [ index, what, selector, options, filters... ] = checkSanityIn "" , arguments
    if selector.doc_id?
      ret = (App.collection what).findOne(selector, options)
    else
      ret = (App.collection what).find(selector, options).fetch()
      filters = _.filter filters
                , (f) -> its "function", f
      ret = (_.filter ret, f) for f in filters
    ret

  fn.one = ->
    [ index, what, selector, options ] = checkSanityIn ".one" , arguments
    (App.collection what).findOne(selector, options)

  fn.cursor = ->
    [ index, what, selector, options ] = checkSanityIn ".cursor", arguments
    (App.collection what).find(selector, options)
  
  fn.count = ->
    [ index, what, selector, options ] = checkSanityIn ".count", arguments
    fn.cursor(what, selector, options).count()

  fn.addDefaults = _.keyValueAdder default_mappings
                   , "object"
                   , "app.find.addDefaults"
  fn.addParent = _.keyValueAdder parent_types
                 , [ "non_empty_string", "array" ]
                 , "app.find.addParent"
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
      , "app.get#memoized"
    if rest_path?.length > 0
      key = "#{first_value}/#{rest_path.join "/"}"
      if memo?[key]?
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
      , "app.get#deepValue"
    path = field.split "/"
    value_in_doc = doc[path[0]]
    if its "non_empty_string", value_in_doc
      findFunc = ->
        _.findValue path
        , doc
        , App.find
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
      , "app.get"
    ensure "non_empty_string", doc.doc_type
    , -> "Doc needs a doc_type: #{json doc}"

    v = deepValue field
        , doc
        , memo

    unless v?
      mapped_obj = mapped_fields[doc.doc_type]
      v = mapped_obj[field](doc) if mapped_obj?[field]?

      unless v?
        alternate_doc_type = alternate[doc.doc_type]
        if alternate_doc_type
          v = deepValue "#{alternate_doc_type}/#{field}"
              , doc
              , memo
    v

  fn.addAlternate = _.keyValueAdder alternate
                    , "non_empty_string"
                    , "app.get.addAlternate"
  fn.addField = _.keyValueAdder mapped_fields
                , "object"
                , "app.get.addField"
  fn
)()

App.docMap = (->
  doc_maps = {}

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
      , "app.docMap#recurse"
      , false
    if its "string", current
      if (_.startsWith current, "'") and
         (_.endsWith current, "'")
        value = current[1...-1]
      else
        value = App.get current, doc
    else if its "object", current
      obj = initial or {}
      for own key, spec of current
        obj[key] = recurse spec
                   , doc
                   , index_str
      value = obj
    else if its "array", current
      value = (recurse spec, doc, index_str for spec in current)

  fn = ->
    [ docs, index_str, include_original, map_funcs... ] =
      _.match arguments
      , [ "array"
          "non_empty_string"
          "boolean" ]
      , 2
      , "app.docMap"
    ensure "defined", doc_maps[index_str]
    , -> "No such doc map found: #{index_str}"
    mapped = _.map docs
             , (doc)->
                 ensure "object", doc
                 , -> "doc needs to be an object: #{json doc}"
                 if include_original is true
                   recurse doc_maps[index_str]
                   , doc
                   , doc
                   , index_str
                 else
                   recurse doc_maps[index_str]
                   , doc
                   , index_str
    map_funcs = func for func in map_funcs when its "function", func
    _.map mapped
    , (doc)->
        _.each map_funcs 
        , (func)-> doc = func doc
        doc

  fn.add = _.keyValueAdder doc_maps
           , [ "non_empty_string"
               "object"
               "array" ]
           , "app.docMap.add"
  fn
)()

App.docFilter = (->
  searchables = {}

  fn = ->
    [ query, func_identifier ] =
      _.match arguments
      , [ "string"
          "non_empty_string" ]
      , 1
      , "app.docFilter"
    query_items = _.uniq _.keywords query
    memo = {}
    if query_items.length is 0
      -> true
    else
      (doc)->
        ensure.inside "#{func_identifier}#filter", arguments
        list = _.uniq _.flatten _.map searchables[doc.doc_type]
                                , (field)->
                                    _.keywords App.get field
                                               , doc
                                               , memo
        found = []
        for item in query_items
          found.push true if item in list
        (_.difference query_items, list).length is 0

  fn.addSearchable = _.keyValueAdder searchables
                     , "array"
                     , "app.docFilter.addSearchable"
  fn
)()
