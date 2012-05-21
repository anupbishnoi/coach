App = (->

  session_variables =
    resultsview:
      name: "Results View"
      type:
        center_manager:
          access: "accessobj"
    searchfor:
      name: "Search For"
      type:
        student:
          query: (argobj)->
            Person.find student: $exists: false
    searchquery:
      name: "Search Query"

  makeAppSessionHelper = (property)->
    ensure "non_empty_string", property
    sessionvar = session_variables[property]
    assert sessionvar, "'#{property}' is not a valid session variable"
    (v)->
      ensure "string_if_defined", v
      if v
        if sessionvar.type
          assert sessionvar.type[v], "'#{v}' is not a valid type of #{property}"
        Session.set(sessionvar.name, v)
      else
        Session.get sessionvar.name

  {
    session: (->
      app_session = {}
      for own k, v of session_variables
        app_session[k] = makeAppSessionHelper k
      app_session
    )()

    searchfor: (searchfor, argobj)->
      assert.stack.push "App.searchfor"
      argobj = defaults argobj,
          resultsview: (get App.session.resultsview)
      {resultsview, searchquery} = argobj

      ensure "non_empty_string", searchfor
      ensure "string", resultsview
      ensure "string_if_defined", searchquery

      assert session_variables.resultsview.type[resultsview],
        "'#{resultsview}' is not a valid view type"
      assert session_variables.searchfor.type[searchfor],
        "'#{searchfor}' is not a valid searchfor type"

      session_variables.searchfor.type[searchfor].query(argobj)
  }
)()
