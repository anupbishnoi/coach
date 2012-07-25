((log, json, ensure, its, inside, error)->

  Template.look_in_selected.events =
    "click .selected": ->
      {look_in, query} = App.session "search"
      id = App.get "id", this
      selected = look_in.split "/"
      ensure "true", _.include selected
                     , id
      selected[selected.indexOf id] = null
      look_in = (_.initialDefined selected)
                .join "/"
      App.session "search"
      , {look_in, query}
      false
      
  Template.look_in_options.events =
    "click .option": ->
      {look_in, query} = App.session "search"
      look_in += "/" unless its "blank", look_in
      look_in += App.get "id", this
      App.session "search"
      , {look_in, query}
      false

  Template.search_input.events =
    "keypress #search_input": (e)->
      switch e.which
        when 13, 32 # Enter/Space
          {look_in, query} = App.session "search"
          query = $(e.currentTarget).val()
          App.session "search"
          , {look_in, query}
          if e.which is 32
            true
          else
            false
        else
          true

  Template.search_for.events =
    "click .item": ->
      {look_in, query} = App.session "search"

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
