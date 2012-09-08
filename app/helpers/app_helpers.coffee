flag = false
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
        parent_stuff =
          ("[#{docId coparent, selector, memo, true}]" for coparent in parent_type).join "."
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
                 , "DocIdfy.addParent"
  fn
)()

QueryFilter = (->
  searchables = {}

  fn = ->
    [ query, func_identifier ] =
      Match arguments
      , [ "string"
          "non_empty_string" ]
      , 1
      , "QueryFilter"
    func_identifier ?= "QueryFilter"
    query_items = _.uniq Keywords query
    memo = {}
    if query_items.length is 0
      -> true
    else
      (doc) ->
        Ensure.inside "#{func_identifier}#filter", arguments
        try doc_type = doc.doc_type or Str.uptilFirst "/", doc.doc_id
        Ensure "non_empty_string", doc_type
        , "Couldn't figure out doc_type of doc: #{Json doc}"
        Ensure "defined", searchables[doc_type]
        , "No searchables specified for doc_type: #{doc_type}"
        list = _.uniq _.flatten _.map searchables[doc_type]
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
                     , "QueryFilter.addSearchable"
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

Collection = (->
  collections = {}
  debug = false

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
  selector_filters = {}

  checkSanityIn = ->
    [ func_identifier, args, allow_invalid_collection ] =
      Match arguments
      , [ "string"
          "arguments"
          "boolean" ]
      , 2
      , "Find#checkSanityIn"
      , false

    [ index, arg1, arg2, arg3, arg4, filters... ] =
      Match args
      , [ "non_empty_string"
          "object"
          "object"
          "boolean"          ], 2
      , [ "non_empty_string"
          "non_empty_string"
          "boolean"          ], 2
      , [ "non_empty_string"
          "boolean"          ], 1
      , [ "object"
          "boolean"          ], 1
      , "Find#{func_identifier}"
    switch index
      when 0
        [ what, selector, options, enforce_found ] =
          [ arg1, (_.clone arg2), arg3, arg4 ]
      when 1
        [ what, id, enforce_found ] = [ arg1, arg2, arg3 ]
        if "/" in id
          selector = { doc_id: id }
        else
          selector = { id }
        filters = [ arg4 ].concat filters
      when 2
        what = Str.uptilFirst "/", arg1
        selector = doc_id: arg1 if "/" in arg1
        enforce_found = arg2
        filters = [ arg3, arg4 ].concat filters
      when 3
        { doc_id, doc_type } = arg1
        what = if doc_id? then Str.uptilFirst "/", doc_id else doc_type
        selector = if doc_id? then { doc_id } else _.clone arg1
        enforce_found = arg2
        filters = [ arg3, arg4 ].concat filters
    filters = _.filter (_.flatten filters), (func) -> its "function", func

    selector ?= {}
    options ?= {}
    unless allow_invalid_collection
      Ensure "defined", (Collection what)
      , -> "Invalid thing to be searching for: #{what}"
    if default_mappings[what]?
      _.defaults selector, default_mappings[what]
    DocIdfy selector

    if its "function", selector_filters[what]
      selector = selector_filters[what](selector)
    else if its "object", selector_filters[what]
      for own field of selector
        if its "function", selector_filters[what][field]
          filters.push selector_filters[what][field](selector)
          delete selector[field]
    [ index, what, selector, options, enforce_found, filters ]

  fn = ->
    [ index, what, selector, options, enforce_found, filters ] =
      checkSanityIn "" , arguments
    if selector.doc_id?
      ret = [ (Collection what).findOne selector, options ]
      ret = (_.filter ret, func) for func in filters
      ret = ret[0]
    else
      ret = (Collection what).find(selector, options).fetch()
      ret = (_.filter ret, func) for func in filters
    if enforce_found
      Ensure.not "empty", ret
      , -> "No #{what} documents found for the passed selector" +
             (if filters.length > 0 then "" else ": #{Json selector}")
    ret

  fn.one = ->
    [ index, what, selector, options, enforce_found, filters ] =
      checkSanityIn ".one" , arguments
    ret = [ (Collection what).findOne selector, options ]
    for func in filters
      ret = (_.filter ret, func) if its.not "empty", ret
    if enforce_found
      Ensure.not "empty", ret
      , -> "No #{what} documents were found for the passed selector"
    ret[0]

  fn.cursor = ->
    [ index, what, selector, options, enforce_found, filters ] =
      checkSanityIn ".cursor", arguments
    if filters.length > 0
      if enforce_found
        Ensure.error "Find.cursor cannot guarantee that the #{what} " +
          "documents returned will satisfy the given selector"
      else
        Log "Find.cursor may include some #{what} " +
          "documents that do not satisfy the given selector"
    (Collection what).find(selector, options)
  
  fn.count = ->
    [ index, what, selector, options, enforce_found, filters] =
      checkSanityIn ".count", arguments
    if filters.length > 0
      docs = fn what, selector, options, enforce_found, filters
      Ensure "true", docs.length > 0 or not enforce_found
      , -> "No #{what} document was found for given selector"
      docs.length
    else
      fn.cursor(what, selector, options).count()

  fn.addDefault = KeyValueAdder default_mappings
                  , "object"
                  , "Find.addDefault"
                  , (doc_type) ->
                      default_mappings[doc_type] =
                        _.clone default_mappings[doc_type]
                      DocIdfy default_mappings[doc_type]
  fn.addSelectorFilter = KeyValueAdder selector_filters
                         , [ "object", "function" ]
                         , "Find.addSelectorFilter"
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
    [ doc, modifier ] =
      Match arguments
      , [ [ "object"
            "non_empty_string" ]
          "object" ]
      , 2
      , "Update"

    doc = Find doc, true
    Ensure "defined", doc.doc_type
    , -> "Doc doesn't have a doc_type: #{Json doc}"

    try
      (Collection doc.doc_type).update { doc_id: doc.doc_id }
      , modifier
    catch e
      Ensure.error "Update failed with error: #{Json e}"
    true
  fn
)()
