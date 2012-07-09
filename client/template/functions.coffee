# search_input
Template.search_input.placeholder = ->
  ensure.inside "Template.search_input.placeholder"
  _.printable App.session "search_for"

# result_list
Template.result_list.any = ->
  ensure.inside "Template.result_list.any"
  (App.find.count (App.session "search_for"),
                  (App.session "look_in")) isnt 0

Template.result_list.item = ->
  ensure.inside "Template.result_list.item"
  docs = App.find (App.session "search_for"), (App.session "look_in")
  App.map docs, "result_list/student/center_manager", (doc)->
    doc.information = _.breakApart doc.information, "field", "value"
    try doc.identification.more[0] = doc.identification.more[0].join ", "
    doc

# search_for
Template.search_for.item = ->
  ensure.inside "Template.search_for.item"
  docs = _.onlyDefined _.map ["student", "study_class", "teacher"], (doc_id)->
    App.find.one "doc_type", {doc_id}
  App.map docs, "search_for/student/center_manager"

# look_in
Template.look_in.any = ->
  ensure.inside "Template.look_in.any"
  (App.find.count "center") isnt 0

# look_in_selected
Template.look_in_selected.any = ->
  ensure.inside "Template.look_in_selected.any"
  selector = App.session "look_in"
  [center_doc, batch_doc, group_doc] =
    _.map ["center", "batch", "group"], (field)->
      doc_id = selector[field]
      App.find.one field, {doc_id} if ensure.test "non_empty_string", doc_id
  selected = _.initialDefined [center_doc, batch_doc, group_doc]
  App.session "data.look_in_selected", selected
  selected.length > 0

Template.look_in_selected.item = ->
  ensure.inside "Template.look_in_selected.item"
  selected = App.session "data.look_in_selected"
  seq = ["center", "batch", "group"]
  _.map selected, (doc, i)->
    ids = App.docIds selected[0...i]
    doc.doc_link = "#look_in/#{ids.join "/"}"
    doc

# look_in_options
Template.look_in_options.any = ->
  ensure.inside "Template.look_in_options.any"
  (App.session "data.look_in_selected").length isnt 3
  
Template.look_in_options.item = ->
  ensure.inside "Template.look_in_options.item"
  selected = App.session "data.look_in_selected"
  seq = ["center", "batch", "group"]
  selector = {}
  #for v, i in selected
    #selector[seq[i]] = selected[i].doc_id
  #App.find.map seq[selected.length], selector, {doc_name: 1}, (doc, i)->
    #ids = (App.docIds selected[0..i]).concat (App.docIds [doc])
    #doc.doc_link = "#look_in/#{ids.join "/"}"
    #doc
  []
