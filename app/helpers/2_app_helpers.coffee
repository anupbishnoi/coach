App = {}

App.org = (->
  #todo: auth stuff here
  "vmc"
)()

App.docIds = (docs, allow_invalid)->
  ensure.inside "App.docIds", arguments
  ensure "array", docs
  _.map docs, (doc)->
    if allow_invalid is true
      doc or= {}
    else
      ensure "object", doc
      ensure "string", doc.doc_id
      ensure "string", doc.id
      ensure "true", (_.last doc.doc_id.split "/") is doc.id
    doc.id

App.collection = (->
  collections = {}

  add = (name)->
    ensure.test "non_empty_string", name
    ensure.not "exists", collections[name]
    collections[name] = new Meteor.Collection(name)
    ensure.types name,
      name: _.printable name
      check: (doc_id)->
        ensure "string", doc_id
        (App.find.count name, {doc_id}) isnt 0

  fn = (name)->
    ensure "non_empty_string", name
    ensure "exists", collections[name],
      "No such collection found: #{name}"
    collections[name]

  fn.add = (name)->
    if ensure.test "array", name
      for collection_name in name
        add collection_name
    else
      add name

  fn.list = -> _.keys collections

  fn
)()

App.find = (->
  defaults = {}

  boiler = (func_identifier, args, allow_invalid)->
    ensure.inside "App.find#{func_identifier}", args
    ensure "arguments", args
    [what, selector, options] = _.toArray args
    selector or= {}
    options or= {}
    unless allow_invalid
      ensure "exists", App.collection(what),
        "Invalid thing to be searching for: #{what}"
    if ensure.test "exists", defaults[what]
      selector = _.defaults (_.clone selector), defaults[what]
    [what, selector, options]

  fn = (what, selector, options)->
    [what, selector, options] = boiler ".", arguments
    App.collection(what).find(selector, options).fetch() or []

  fn.cursor = ->
    [what, selector, options] = boiler ".cursor", arguments
    App.collection(what).find(selector, options)
  
  fn.if = ->
    [what, selector, options] = boiler ".if", arguments, true
    if ensure.test "exists", App.collection(what)
      fn what, selector, options
    else
      []

  fn.count = ->
    [what, selector, options] = boiler ".count", arguments
    fn.cursor(what, selector, options).count()

  fn.one = ->
    [what, selector, options] = boiler ".one", arguments
    App.collection(what).findOne(selector, options)

  fn.addDefaults = addKeyValueGenerator defaults, "object", "App.find.addDefault"

  fn
)()

App.docIdfy = (->
  parent = {}

  docId = (field, obj)->
    ensure "string", field
    ensure "exists", obj[field],
      "Need '#{field}' to idfy #{json obj}"
    ret = if field is "org" or _.str.include obj[field], "/"
      obj[field]
    else
      parent = parent[field]
      ensure "exists", parent,
        "#{field} needs a parent"
      if ensure.test "string", parent
        "#{docId parent, obj}/#{obj[field]}"
      else
        ensure "array", parent,
          "Parent of #{field} must be either string or array: #{parent}"
        ids = _.map parent, (coparent)->
          "[#{docId coparent, obj}]"
        "#{docId "org", obj}/#{ids.join "."}/#{obj[field]}"
    ret

  fn = (obj)->
    ensure.inside "App.docIdfy", arguments
    ensure "object", obj
    selector = _.clone obj
    fasterDocId = _.memoize docId
    for own field of selector
      value = fasterDocId field, obj
      if ensure.test "non_empty_string", value
        selector[field] = "#{field}/#{value}"
    selector

  fn.addParent = addKeyValueGenerator parent, ["non_empty_string", "array"], "App.docIdfy.addParent"

  fn
)()

App.map = (->
  maps = {}

  recurse = (current, doc)->
    if ensure.test "string", current
      if _.startsWith current, "#"
        value = App.get current[1..], doc
      else
        value = current
    else if ensure.test "object", current
      obj = {}
      for own key, spec of current
        obj[key] = recurse spec, doc
      value = obj
    else if ensure.test "array", current
      value = _.map current, (spec)->
        recurse spec, doc

  fn = (docs, index_str, more_mapping_functions)->
    ensure.inside "App.map", arguments
    ensure "array", docs
    ensure "exists", maps[index_str],
      "No such map found: #{index_str}"
    mapped = _.map docs, (doc)->
      ensure "object", doc
      recurse maps[index_str], doc
    _.each (_.toArray arguments)[2..], (func)->
      if ensure.test "function", func
        mapped = _.map mapped, func
    mapped

  fn.add = (index_str, map_spec)->
    ensure.inside "App.map.add", arguments
    ensure "non_empty_string", index_str
    ensure ["string", "object", "array"], map_spec
    ensure.not "exists", maps[index_str],
      "A docs mapping called '#{index_str}' already exists. Can't overwrite."
    maps[index_str] = JSON.parse json map_spec

  fn
)()

App.get = (->
  alternate = {}
  mapped_fields = {}

  deepValue = (field_str, doc)->
    ensure "non_empty_string", field_str
    _.findValue (field_str.split "/"), doc,
      (value, field)-> App.find.one field, doc_id: value

  fn = (field, doc)->
    ensure.inside "App.get", arguments
    order = [
      (field, doc)->
        deepValue field, doc
    ,
      (field, doc)->
        alternate_fields = mapped_fields[doc.doc_type]
        if (ensure.test "exists", alternate_fields) and
           (ensure.test "exists", alternate_fields[field])
          ensure "function", alternate_fields[field],
            "App.get.addField for #{doc.doc_type} needs a function for: #{field}"
          alternate_fields[field](doc)
    ,
      (field, doc)->
        alternate_doc_type = alternate[doc.doc_type]
        if ensure.test "exists", alternate_doc_type
          alternate_doc = App.find.one alternate_doc_type,
            doc_id: doc[alternate_doc_type]
          alternate_doc and deepValue field, alternate_doc
    ]
    for func, i in order
      v = func field, doc
      break if ensure.test "exists", v
    v

  fn.addAlternate = addKeyValueGenerator alternate, "non_empty_string", "App.get.addAlternate"
  fn.addField = addKeyValueGenerator mapped_fields, ["string", "object"], "App.get.addField"
  fn.m = mapped_fields
  fn
)()
