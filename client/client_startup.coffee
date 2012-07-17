((log, json, ensure, its, inside, error)->

  App.session "navigation"
  , view_as: "center_manager"
  , search_for: "student"

  App.session "search"
  , look_in: ""
  , query: ""

  AppRouter = Backbone.Router.extend
    routes:
      "navigate/*query": "navigate"
    navigate: (query)->
      parts = query.split "&"
      combined = _.flatten _.map parts
                           , (part)->
                             [k, v] = part.split "="
                             [k, v]
      parsed = _.objectify combined
               , "non_empty_string"
               , true

      App.session "search"
      , look_in: ""
      , query: ""

      $("search_input").val("")

      App.session "navigation"
      , parsed

  Meteor.startup ->
    App.router = new AppRouter()
    Backbone.history.start()

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
