#App = (->

  #session_variables =
    #org:
      #name: "Organisation"
    #center:
      #name: "Study Center"
    #view_as:
      #name: "View Results As"
      #type:
        #center_manager:
          #result_list:
            #identification: ["name", "address"]
            #information: ["rollno", "last_payment"]
            #actions: ["pay_installment", "print_receipt"]
    #search_for:
      #name: "Search For"
      #type:
        #student:
          #query: (argobj)->
            #StudentFull.find()
    #search_query:
      #name: "Search Query"

  #makeAppSessionHelper = (property)->
    #ensure "non_empty_string", property
    #sessionvar = session_variables[property]
    #ensure "exists", sessionvar,
      #"'#{property}' is not a valid session variable"
    #(v, justchecking)->
      #ensure "string_if_defined", v
      #ensure "boolean_if_defined", justchecking
      #if v
        #if sessionvar.type
          #ensure "exists", sessionvar.type[v],
            #"'#{v}' is not a valid type of #{property}"
        #if justchecking
          #Session.equals sessionvar.name, v
        #else
          #Session.set(sessionvar.name, v)
      #else
        #Session.get sessionvar.name

  #{
    ## get and set session variables
    #session: (->
      #app_session = {}
      #for own k, v of session_variables
        #app_session[k] = makeAppSessionHelper k
      #app_session
    #)()

    ## interface between search types and model queries
    #search_for: (entity, argobj, behavior)->
      #ensure.inside "App.search_for", arguments
      #argobj = _.defaults argobj,
          #view_as: (get App.session.view_as)
      #{view_as, search_query} = argobj

      #ensure "non_empty_string", entity
      #ensure "string", view_as
      #ensure "string_if_defined", search_query

      #ensure "exists",
        #session_variables.view_as.type[view_as],
        #"'#{view_as}' is not a valid view type"
      #ensure "exists",
        #session_variables.search_for.type[entity],
        #"'#{entity}' is not a valid 'search_for' type"

      #if behavior
        ##todo:
        #ensure "mongo_observe", behavior
      #else
        #session_variables.search_for.type[entity].query(argobj)
    #view_as: (role)->
      #ensure "exists", session_variables.view_as.type[role]
  #}
#)()
