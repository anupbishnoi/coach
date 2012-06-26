App.org = (->
  "vmc" #todo: auth stuff here
)()

App.find = (->
  find = (model)->
    (selector, options)->
      selector or= {}
      options or= {}
      model.find selector, options

  types =
    "student":
      name: "Student"
      query: find Student
      show: yes
      add_type: yes
    "teacher":
      name: "Teacher"
      query: find Teacher
      add_type: yes
    "center":
      name: "Study Center"
      query: find Center
      add_type: yes
    "batch":
      name: "Batch"
      query: find Batch
      add_type: yes
    "group":
      name: "Group"
      query: find Group
      add_type: yes

  for own id, type of types
    if type.add_type is true
      ensure.types id,
        name: type.name
        check: (doc_id)->
          ensure "string", doc_id
          (type.query {doc_id}).count() isnt 0

  fn = (what, selector, options)->
    ensure.inside "App.find", arguments
    ensure "exists", types[what],
      "Invalid thing to be searching for: #{what}"
    if ensure.test "object", selector
      selector = _.defaults (_.clone selector),
        active: true
        org: App.org
    types[what].query selector, options

  fn.count = (what, selector, options)->
    ensure.inside "App.find.count", arguments
    (fn what, selector, options).count()

  fn.fetch = (what, selector, options)->
    ensure.inside "App.find.fetch", arguments
    (fn what, selector, options).fetch()

  fn.one = (what, selector, options)->
    ensure.inside "App.find.one", arguments
    (fn.fetch what, selector, options)[0]

  fn.map = (what, selector, options, func)->
    ensure.inside "App.find.map", arguments
    if ensure.test "function", func
      (fn what, selector, options).map func
    else if ensure.test "function", options
      (fn what, selector).map options
    else if ensure.test "function", selector
      (fn what).map selector

  fn.types = (searching_for)->
    ensure.inside "App.find.types", arguments
    arr = []
    for own id, type of types
      if type.show is true
        arr.push
          type_id: id
          type_name: type.name
          ui_active: if searching_for is id then "active" else ""
    arr

  fn
)()

App.session = (key, value)->
  ensure.inside "App.session", arguments
  ensure "string", key, "Session variable key must be a string"

  format =
    "view_as": "string"
    "search_for": "string"
    "look_in": "object"
    "data.look_in_selected": "array"

  ensure "exists", format[key],
    "Invalid session variable, no such found: #{key}"
  if not ensure.test "exists", value
    value = Session.get key
    ensure format[key], value,
      "Invalid value stored in '#{key}': #{json value}"
    value
  else
    ensure format[key], value,
      "Invalid value specified for '#{key}': #{json value}" +
      "\nShould have been: #{format[key]}"
    Session.set key, value
    Session.get key

App.docIds = (docs)->
  ensure "array", docs
  _.map docs, (doc)->
    ensure "object", doc
    ensure "string", doc.doc_id
    _.last doc.doc_id.split "/"

App.docIdfy = (->
  schema =
    "center":     "id"
    "batch":      "id"
    "group":      "center/batch/id"
    "hello":      "group/batch/group/id"

  docId = (field, obj)->
    if ensure.test "exists", schema[field]
      if ensure.test "non_empty_string", obj[field]
        required = schema[field].split "/"
        ids = _.map required, (f)->
          if f is "id"
            obj[field]
          else
              ensure "non_empty_string", obj[f],
                "Required field '#{f}' not found in #{json obj}"
              docId f, obj
        ids.join "/"

  (obj)->
    ensure.inside "App.docIdfy", arguments
    ensure "object", obj
    selector = _.clone obj
    for own field of selector
      value = docId field, obj
      if ensure.test "non_empty_string", value
        selector[field] = "#{App.org}/#{field}/#{value}"
    selector
)()
