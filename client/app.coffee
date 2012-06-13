App.search_for_types = [
  type_name: "Student"
  type_id: "student"
  type_query: (argobj)->
    Student.find argobj
  show_in_menu: yes
,
  type_name: "Teacher"
  type_id: "teacher"
  type_query: ->
]

App.look_in_types = [
  type_id: "center"
  type_name: "Study Center"
  type_model: Center
,
  type_id: "batch"
  type_name: "Batch"
  type_model: Batch
,
  type_id: "group"
  type_name: "Group"
  type_model: Group
]

(->
  add_type = (argobj)->
    {type_id, type_name, type_model} = argobj
    ensure.types type_id,
      type_name: type_name
      type_check: (doc_id)->
        ensure "string", doc_id
        (type_model.find {doc_id}).count() isnt 0
  add_type t for t in App.look_in_types
)()

App.look_in_obj = (selected)->
  [center, batch, group] = selected.split "/"
  ensure "string_if_defined", center
  ensure "string_if_defined", batch
  ensure "string_if_defined", group

  org = Session.get "org"
  obj = {}
  obj.center = "#{org}/center/#{center}" if center
  obj.batch = "#{org}/batch/#{batch}" if batch
  obj.group = "#{org}/group/#{center}/#{batch}/#{group}" if group
  obj
