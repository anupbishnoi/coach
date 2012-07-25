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
      parts = query.split "/"
      keys = _.filter parts, (part, i)-> i % 2 is 0
      values = _.filter parts, (part, i)-> i % 2 is 1
      parsed = _.objectify keys
               , values
               , "non_empty_string"
               , true
      $("search_input").val("")

      App.session "navigation"
      , parsed

      App.session "search"
      , look_in: ""
      , query: ""

  Meteor.startup ->
    App.router = new AppRouter()
    Backbone.history.start()

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
