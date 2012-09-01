Collection = (->
  collections = {}
  fn = (name) ->
    [ name ] = Match arguments, [ "non_empty_string" ], 1, "Collection"
    Ensure "defined", collections[name]
    , -> "No such collection found: #{name}"
    collections[name]

  Ensure.types "meteor_collection"
  , (obj) -> obj instanceof Meteor.Collection

  fn.add = KeyValueAdder collections
           , [ "undefined", "boolean" ]
           , "Collection.add"
           , (name) ->
               collections[name] =
                 new Meteor.Collection (if collections[name] is true then null else name)
               Ensure.types name
               , (doc_id) ->
                   Ensure [ "non_empty_string", "object" ], doc_id
                   , -> "Invalid doc_id/object (#{Json doc_id}) to the check function of: #{name}"
                   (Find name, doc_id: (doc_id.doc_id or doc_id))?
  fn.list = -> _.keys collections
  fn.reset = ->
    [ name ] = Match arguments, [ "non_empty_string" ], 1, "Collection.reset"
    collections[name].remove({})
  fn.reset.all = -> collections[name].remove({}) for name in fn.list()

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
Find = (->
  default_mappings = {}

  checkSanityIn = ->
    [ func_identifier, args, allow_invalid ] =
      Match arguments
      , [ "string"
          "arguments"
          "boolean" ]
      , 2
      , "Find#checkSanityIn"
      , false
    [ index, arg1, arg2, arg3, arg4 ] =
      Match args
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
      , "Find#{func_identifier}"
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
        what = Str.uptilFirst "/", arg1
        selector = doc_id: arg1 if "/" in arg1
        filter = arg2
      when 3
        { doc_id, doc_type } = arg1
        what = if doc_id? then Str.uptilFirst "/", doc_id else doc_type
        selector = _.clone arg1
        filter = arg2
    selector ?= {}
    options ?= {}
    unless allow_invalid
      Ensure "defined", (Collection what)
      , -> "Invalid thing to be searching for: #{what}"
    if default_mappings[what]?
      _.defaults selector, default_mappings[what]
    DocIdfy selector
    [ index, what, selector, options, filter ]

  fn = ->
    [ index, what, selector, options, filters... ] = checkSanityIn "" , arguments
    if selector.doc_id?
      ret = (Collection what).findOne(selector, options)
    else
      ret = (Collection what).find(selector, options).fetch()
      filters = _.filter filters
                , (f) -> its "function", f
      ret = (_.filter ret, f) for f in filters
    ret

  fn.one = ->
    [ index, what, selector, options ] = checkSanityIn ".one" , arguments
    (Collection what).findOne(selector, options)

  fn.cursor = ->
    [ index, what, selector, options ] = checkSanityIn ".cursor", arguments
    (Collection what).find(selector, options)
  
  fn.count = ->
    [ index, what, selector, options ] = checkSanityIn ".count", arguments
    fn.cursor(what, selector, options).count()

  fn.addDefaults = KeyValueAdder default_mappings
                   , "object"
                   , "Find.addDefaults"
                   , (doc_type) ->
                       default_mappings[doc_type] = _.clone default_mappings[doc_type]
                       DocIdfy default_mappings[doc_type]
  fn
)()

Get = (->
  alternate = {}
  mapped_fields = {}

  deepValue = ->
    [ path, doc, memo ] =
      Match arguments
      , [ "array"
          "object"
          "object" ]
      , 2
      , "Get#deepValue"
    value_in_doc = doc
    for key, i in path[0].split "."
      if its "numeric", key
        key = +(key)
      value_in_doc = value_in_doc[key]
      break if not value_in_doc?
    if not value_in_doc?
      value_in_doc
    else if path.length is 1
      value_in_doc
    else if (its "non_empty_string", value_in_doc) and
            ("/" in value_in_doc)
      deepValue path[1..]
      , (memo[value_in_doc] or (memo[value_in_doc] = Find value_in_doc))
      , memo
    else
      Ensure.error "Expected a doc_id to Find next: #{value_in_doc}"

  fn = ->
    [ field, doc, memo, ensure_defined ] =
      Match arguments
      , [ "non_empty_string"
          "object"
          "object"
          "boolean" ]
      , 2
      , "Get"
    memo ?= {}
    Ensure "non_empty_string", doc.doc_type
    , -> "Doc needs a doc_type: #{Json doc}"

    v = deepValue (field.split "/")
        , doc
        , memo
    if not v?
      mapped_obj = mapped_fields[doc.doc_type]
      v = mapped_obj[field](doc) if mapped_obj?[field]?
    if not v?
      alternate_doc_type = alternate[doc.doc_type]
      if alternate_doc_type
        v = deepValue ([ alternate_doc_type ].concat field.split "/")
            , doc
            , memo

    if ensure_defined and not v?
      Ensure.error "Couldn't find '#{field}' of doc: #{Json doc}"
    v

  fn.addAlternate = KeyValueAdder alternate
                    , "non_empty_string"
                    , "Get.addAlternate"
  fn.addField = KeyValueAdder mapped_fields
                , "object"
                , "Get.addField"
  fn
)()

Update = (->
  fn = ->
    [ doc, field, value ] =
      Match arguments
      , [ [ "object"
            "non_empty_string" ]
          "non_empty_string"
          null ]
  fn
)()

DocIdfy = (->
  parent_types = {}
  
  docId = (field, selector, memo, first_call) ->
    Ensure "defined", selector[field]
    , -> "Value not found for field (#{field}) in: #{Json selector}"
    prefix = if first_call then "#{field}/" else ""
    if memo[field]?
      "#{prefix}#{memo[field]}"
    else if (not parent_types[field]?) or ("/" in selector[field])
      selector[field]
      # note that even if 'org' wasn't specified, it was added by the _.defaults above
    else if (parent_types[field] is "doc_type")
      memo[field] = selector[field]
      "#{prefix}#{selector[field]}"
    else
      parent_type = parent_types[field]
      if its "non_empty_string", parent_type
        parent_stuff = docId parent_type, selector, memo
        if (Str.uptilFirst "/", parent_stuff) is parent_type
          parent_stuff = (Str.afterFirst "/", parent_stuff)
      else
        Ensure "array", parent_type
        , -> "Parent type of #{field} must either be string or array: #{Json parent_type}"
        parent_stuff = ("[#{docId coparent, selector, memo, true}]" for coparent in parent_type).join "."
      memo[field] = "#{parent_stuff}/#{selector[field]}"
      "#{prefix}#{memo[field]}"

  fn =  ->
    [ selector, field, memo ] =
      Match arguments
      , [ "object"
          "non_empty_string"
          "object" ]
      , 1
      , "DocIdfy"
    memo ?= {}
    if field?
      selector[field] = docId field, selector, memo, true
    else
      for own field of selector
        selector[field] = docId field, selector, memo, true
    selector

  fn.addParent = KeyValueAdder parent_types
                 , [ "non_empty_string", "array" ]
                 , "Find.addParent"
  fn
)()

DocMap = (->
  doc_maps = {}

  recurse = ->
    [ current, doc, initial ] =
      Match arguments
      , [ [ "string"
            "object"
            "array" ]
          "object"
          "object"
          "string" ]
      , 2
      , "DocMap#recurse"
      , false
    if its "string", current
      if (Str.startsWith current, "'") and
         (Str.endsWith current, "'")
        value = current[1...-1]
      else
        value = Get current, doc
    else if its "object", current
      obj = initial or {}
      for own key, spec of current
        obj[key] = recurse spec, doc
      value = obj
    else if its "array", current
      value = (recurse spec, doc for spec in current)

  fn = ->
    [ index_str, docs, include_original, map_funcs... ] =
      Match arguments
      , [ "non_empty_string"
          "array"
          "boolean" ]
      , 2
      , "DocMap"
    Ensure "defined", doc_maps[index_str]
    , -> "No such doc map found: #{index_str}"
    mapped = _.map docs
             , (doc) ->
                 Ensure "object", doc
                 , -> "Doc needs to be an object: #{Json doc}"
                 if include_original is true
                   recurse doc_maps[index_str]
                   , doc
                   , doc
                 else
                   recurse doc_maps[index_str]
                   , doc
    map_funcs = (func for func in map_funcs when its "function", func)
    _.each map_funcs
    , (func) -> mapped = _.map mapped, func
    mapped

  fn.add = KeyValueAdder doc_maps
           , [ "non_empty_string"
               "object"
               "array" ]
           , "DocMap.add"
  fn
)()

DocFilter = (->
  searchables = {}

  fn = ->
    [ query, func_identifier ] =
      Match arguments
      , [ "string"
          "non_empty_string" ]
      , 1
      , "DocFilter"
    query_items = _.uniq Keywords query
    memo = {}
    if query_items.length is 0
      -> true
    else
      (doc) ->
        Ensure.inside "#{func_identifier}#filter", arguments
        list = _.uniq _.flatten _.map searchables[doc.doc_type]
                                , (field) ->
                                    Keywords Get field
                                             , doc
                                             , memo
        found = []
        for item in query_items
          found.push true if item in list
        (_.difference query_items, list).length is 0

  fn.addSearchable = KeyValueAdder searchables
                     , "array"
                     , "DocFilter.addSearchable"
  fn
)()
