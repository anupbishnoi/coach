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
    look_in_selected.push Get "doc_id", this, true
    Update role_doc
    , "ui.look_in.selected"
    , look_in_selected
    false
    #mark
Template.search_input.events =
  "keypress #search_input": (e) ->
    switch e.which
      when 13, 32# , 8, 20, 40, 46 # Enter/Space/Backspace/Delete
        Log "lo"
        search_query = $(e.currentTarget).val()
        Session "search_query"
        , search_query
        if e.which is 13
          false
        else
          true
      else
        true

Template.search_for.events =
  "click .item": ->
    { role_doc } = UserDetails()
    search_for = Str.uptilFirst "/", Get "doc_id", this, true
    Update role_doc
    , "ui.search_for"
    , search_for
    false
