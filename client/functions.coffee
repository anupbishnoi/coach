Template.search_input.placeholder = ->
  Ensure.inside "Template.search_input.placeholder"
  { search_for } = UserDetails()
  Str.printable search_for

Template.result_list.any = ->
  Ensure.inside "Template.result_list.any"

  { search_for, look_in_selected, look_in_order } = UserDetails()
  search_query = (Session "search_query") or ""
  selector = Arr.objectify look_in_order
             , look_in_selected
             , "non_empty_string"
  (Find.one search_for, selector, Docfilter search_query)?

Template.result_list.item = ->
  { view_as, search_for, look_in_selected, look_in_order } = UserDetails()
  search_query = (Session "search_query") or ""
  selector = Arr.objectify look_in_order
             , look_in_selected
             , "non_empty_string"
  docs = Find search_for
         , selector
         , Docfilter search_query
  breakApartInformation = (doc)->
    doc.information =
      Obj.breakApart doc.information
      , "field"
      , "value"
    doc
  stringifyArrays = (doc)->
    arr = _.map doc.identification.more
          , (item)->
              if its "array", item
                item.join ", "
              else
                item
    doc.identification.more = arr
    doc
  result_list = DocMap docs
                , "result_list/#{search_for}/#{view_as}"
                , breakApartInformation
                , stringifyArrays

# search_for
Template.search_for.item = ->
  Ensure.inside "Template.search_for.item"
  { search_for, search_for_list } = UserDetails()
  _.compact _.chain(search_for_list)
             .map((id) -> Find "doc_type/#{id}")
             .map((doc) ->
                    if doc.doc_id is search_for
                      doc.ui_active = "active"
                    doc)
             .value()

Template.look_in.editing = ->
  Ensure.inside "Template.look_in.editing"
  Session "look_in_editing"

Template.look_in_edit.any = ->
  Ensure.inside "Template.look_in_edit.any"
  { look_in_order } = UserDetails()
  look_in_order.length > 0

Template.look_in_edit.item = ->
  Ensure.inside "Template.look_in_edit.item"
  { look_in_order } = UserDetails()
  _.map look_in_order
  , (id) -> Find "doc_type/#{id}"

Template.look_in.any = ->
  Ensure.inside "Template.look_in.any"
  { look_in_order } = UserDetails()
  look_in_order.length > 0

Template.look_in_selected.any = ->
  Ensure.inside "Template.look_in_selected.any"
  { look_in_selected } = UserDetails()
  Find look_in_selected[0] if look_in_selected[0]?

Template.look_in_selected.item = ->
  Ensure.inside "Template.look_in_selected.item"
  { look_in_selected } = UserDetails()
  _.map look_in_selected
  , Find

Template.look_in_options.any = ->
  Ensure.inside "Template.look_in_options.any"
  { look_in_selected, look_in_order } = UserDetails()
  (Find.one look_in_order[look_in_selected.length]
   , Arr.objectify look_in_order
     , look_in_selected
     , "non_empty_string"
  )?

Template.look_in_options.item = ->
  Ensure.inside "Template.look_in_options.item"
  { look_in_selected, look_in_order } = UserDetails()
  Find look_in_order[look_in_selected.length]
  , Arr.objectify look_in_order
    , look_in_selected
    , "non_empty_string"
