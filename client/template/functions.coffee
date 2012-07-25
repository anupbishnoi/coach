((log, json, ensure, its, inside, error)->

  # search_input
  Template.search_input.placeholder = ->
    inside "Template.search_input.placeholder"
    {search_for} = App.session "navigation"
    _.printable search_for

  (->
    result_list = []
    Template.result_list.any = ->
      inside "Template.result_list.any"
      {search_for, view_as} = App.session "navigation"
      {look_in, query} = App.session "search"
      result_list = App.ui "result_list/#{search_for}/#{view_as}"
                    , {look_in, query}
      result_list.length isnt 0
    Template.result_list.item = -> result_list
  )()

  # search_for
  Template.search_for.item = ->
    inside "Template.search_for.item"
    {search_for, view_as} = App.session "navigation"
    App.ui "search_for/#{view_as}"
    , search_for

  (->
    selected = []
    options = []

    Template.look_in.any = ->
      inside "Template.look_in.any"
      {search_for, view_as} = App.session "navigation"
      {look_in} = App.session "search"
      selected = App.ui "look_in/selected/#{search_for}/#{view_as}"
                 , look_in
      options = App.ui "look_in/options/#{search_for}/#{view_as}"
                , selected
      selected.length + options.length > 0

    Template.look_in_selected.any = ->
      selected.length > 0
    Template.look_in_options.any = ->
      options.length > 0

    Template.look_in_selected.item = ->
      selected
    Template.look_in_options.item = ->
      options
  )()

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
