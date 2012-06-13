Template.search_input.placeholder = ->
  ensure.inside "Template.search_input.placeholder", arguments
  #str = get App.session.search_for
  #ensure "non_empty_string", str
  #(str.charAt 0).toUpperCase() + str.slice 1
  ""

Template.result_list.has_items = ->
  Template.result_list.items().count() isnt 0
Template.result_list.items = ->
  ensure.inside "Template.result_list.items"
  coll = _.find App.search_for_types, (c)-> c.type_id is Session.get "search_for"
  ensure "object", coll
  query = coll.type_query
  ensure "function", query
  argobj = App.look_in_obj Session.get "look_in/selected"
  query argobj

Template.search_for.items = ->
  _.map (_.filter App.search_for_types, (coll)-> coll.show_in_menu is true), (coll)->
    type_name: coll.type_name
    type_id: coll.type_id
    ui_active: if (Session.get "search_for") is coll.type_id then "active" else ""

Template.look_in.has_look_ins = ->
  (App.look_in_types[0].type_model.find active: true).count() isnt 0
Template.look_in.look_ins_selected = ->
  ensure.inside "Template.look_in.selected", arguments
  arr = (Session.get "look_in/selected").split "/"
  l = Math.min arr.length, App.look_in_types.length
  relevant_look_ins = App.look_in_types[0...l]
  _.map relevant_look_ins, (type, i)->
      doc_id = "#{Session.get "org"}/#{type.type_id}/#{arr[i]}"
      active = true
      doc = (type.type_model.findOne {doc_id, active}) or {doc_name: "lallu"}
      doc
Template.look_in.look_in_options = ->
  #ensure.inside "Template.look_in.option"
  #types = App.look_in_types
  #arr = ((Session.get "look_in/selected").split "/")[0...types.length]
  #ensure "true", arr.length <= types.length
  #argobj = active: true
  #org = Session.get "org"
  #link = "look_in/#{org}"
  #for i in [0...arr.length]
    #cb = types[i].id
    #argobj[cb] = "#{org}/#{cb}/#{arr[i]}"
    #link += "/#{arr[i]}"
  #if arr.length < types.length
    #look_ins = _.map (types[arr.length].model.find argobj).fetch(), (doc)->
      #k = if arr.length < types.length-1 then 2 else 4
      #doc.link = "#{link}/#{doc.doc_id.split("/")[k..].join "/"}"
      #doc.ui_active = ""
      #doc
  #else
    #look_ins = _.map (types[arr.length-1].model.find argobj).fetch(), (doc)->
      #link_arr = link.split "/"
      #doc_id_arr = doc.doc_id.split "/"
      #doc.link = "#{(_.initial link_arr).join "/"}/#{_.last doc_id_arr}"
      #doc.ui_active = if (_.last link_arr) is (_.last doc_id_arr) then "active" else ""
      #doc
  #log look_ins
  #look_ins
  [{doc_name: "hello"}]
