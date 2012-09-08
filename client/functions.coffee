Template.search_input.helpers
  placeholder: ->
    Ensure.inside "Template.search_input.placeholder"
    { search_for } = UserDetails()
    Str.printable search_for


Template.result_list.helpers
  any: ->
    Ensure.inside "Template.result_list.any"

    { search_for, look_in_selected, look_in_order } = UserDetails()
    search_query = (Session "search_query") or ""
    if look_in_selected?[search_for]? and look_in_order?[search_for]?
      selector = Arr.objectify look_in_order[search_for]
                 , look_in_selected[search_for]
                 , "non_empty_string"
      (Find.one search_for, selector, QueryFilter search_query)?

  item: ->
    { view_as_type, search_for, look_in_selected, look_in_order } = UserDetails()
    search_query = (Session "search_query") or ""
    selector = Arr.objectify look_in_order[search_for]
               , look_in_selected[search_for]
               , "non_empty_string"
    docs = Find search_for
           , selector
           , QueryFilter search_query
    breakApartInformation = (doc) ->
      doc.information =
        Obj.breakApart doc.information
        , "field"
        , "value"
      doc
    stringifyArrays = (doc) ->
      arr = _.map doc.identification.more
            , (item) ->
                if its "array", item
                  item.join ", "
                else
                  item
      doc.identification.more = arr
      doc
    DocMap "result_list/#{search_for}/#{view_as_type}"
    , docs
    , breakApartInformation
    , stringifyArrays


Template.search_for.helpers
  item: ->
    Ensure.inside "Template.search_for.item"
    { search_for, search_for_list } = UserDetails()
    _.compact _.chain(search_for_list)
               .map((id) -> Find "doc_type/#{id}")
               .map((doc) ->
                      doc.doc_name = Get "doc_name", doc, true
                      if doc.doc_id is "doc_type/#{search_for}"
                        doc.ui_active = "active"
                      doc)
               .value()


Template.look_in.helpers
  editing: ->
    Ensure.inside "Template.look_in.editing"
    Session "look_in_editing"

  any: ->
    Ensure.inside "Template.look_in.any"
    { look_in_order, search_for } = UserDetails()
    look_in_order?[search_for]?.length


Template.look_in_edit.helpers
  any: ->
    Ensure.inside "Template.look_in_edit.any"
    { look_in_order, search_for } = UserDetails()
    look_in_order?[search_for]?.length

  item: ->
    Ensure.inside "Template.look_in_edit.item"
    { look_in_order, search_for } = UserDetails()
    _.map look_in_order[search_for]
    , (id) -> Find "doc_type/#{id}"


Template.look_in_selected.helpers
  any: ->
    Ensure.inside "Template.look_in_selected.any"
    { look_in_selected, search_for } = UserDetails()
    if look_in_selected?[search_for]?
      (Find look_in_selected[search_for][0])?

  item: ->
    Ensure.inside "Template.look_in_selected.item"
    { look_in_selected, search_for } = UserDetails()
    _.map look_in_selected[search_for]
    , Find


Template.look_in_options.helpers
  any: ->
    Ensure.inside "Template.look_in_options.any"
    { look_in_selected, look_in_order, search_for } = UserDetails()
    if look_in_selected?[search_for]?.length and
       look_in_order?[search_for]?.length and
       look_in_order[search_for].length > look_in_selected[search_for].length
      order = look_in_order[search_for]
      selected = look_in_selected[search_for]
      (Find.one order[selected.length]
       , Arr.objectify order
         , selected
         , "non_empty_string"
      )?

  item: ->
    Ensure.inside "Template.look_in_options.item"
    { look_in_selected, look_in_order, search_for } = UserDetails()

    order = look_in_order[search_for]
    selected = look_in_selected[search_for]
    
    Find order[selected.length]
    , Arr.objectify order
      , selected
      , "non_empty_string"
