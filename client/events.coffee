Template.look_in_edit.events =
  "click .edit": -> false #mark

Template.look_in_selected.events =
  "click .selected": ->
    Ensure.inside "Template.look_in_selected.events#click .selected"
    { look_in_selected, role_doc } = UserDetails()
    index = _.indexOf look_in_selected, Get "doc_id", this
    Ensure "false", index is -1
    , -> "Invalid doc_id in (#{Json this}), no match in ui.look_in.selected of role doc: #{Json role_doc}"
    Update role_doc
    , "ui.look_in.selected"
    , look_in_selected[0...index]
    false
    
Template.look_in_options.events =
  "click .option": ->
    { look_in_selected, role_doc } = UserDetails()
    look_in_selected.push Get "doc_id", this
    Update role_doc
    , "ui.look_in.selected"
    , look_in_selected
    false
    #mark
Template.search_input.events =
  "keypress #search_input": (e)->
    switch e.which
      when 13, 32 # Enter/Space
        search_query = Session "search_query"
        query = $(e.currentTarget).val()
        Session "search_query"
        , search_query
        if e.which is 32
          true
        else
          false
      else
        true

Template.search_for.events =
  "click .item": ->
    { role_doc } = UserDetails()
    [ search_for ] = (Get "doc_id", this).split "/"
    Update role_doc
    , "ui.search_for"
    , search_for
    false
