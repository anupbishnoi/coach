Template.look_in_edit.events
  "click .edit": -> false #todo later:

Template.look_in_selected.events
  "click .selected": ->
    Ensure.inside "Template.look_in_selected.events#click .selected"
    { role_doc, look_in_selected, search_for } = UserDetails()
    index = _.indexOf look_in_selected[search_for], Get "doc_id", this
    Ensure "false", index is -1
    , -> "Invalid doc_id in (#{Json this}), no match in ui.look_in.selected of role doc: #{Json role_doc}"
    look_in_selected[search_for] = look_in_selected[search_for][0...index]
    Update role_doc
    , $set: "ui.look_in_selected": look_in_selected
    UserDetails.reset()
    false
    
Template.look_in_options.events
  "click .option": ->
    { role_doc, look_in_selected, search_for } = UserDetails()
    look_in_selected[search_for] ?= []
    look_in_selected[search_for].push Get "doc_id", this, true
    Update role_doc
    , $set: "ui.look_in_selected": look_in_selected
    UserDetails.reset()
    false

Template.search_input.events
  "keypress #search_input": (e) ->
    switch e.which
      when 13, 32# , 8, 20, 40, 46 # Enter/Space/Backspace/Delete
        search_query = $(e.currentTarget).val()
        Session "search_query"
        , search_query
        if e.which is 13
          false
        else
          true
      else
        true

Template.search_for.events
  "click .item": ->
    { role_doc } = UserDetails()
    Update role_doc
    , $set: "ui.search_for": (Get "id", this, true)
    UserDetails.reset()
    false
