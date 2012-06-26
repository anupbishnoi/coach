App.session "view_as", "center_manager"
App.session "search_for", "student"
App.session "look_in", {}
App.session "data.look_in_selected", []

AppRouter = Backbone.Router.extend
  routes:
    "add/:entity":                      "add"
    "search_for/:entity":               "search_for"
    "look_in/*cbg":                     "look_in"
  add: (entity)->
    console.log entity
    console.log arguments
  search_for: (entity)->
    App.session "search_for", entity
  look_in: (cbg)->
    seq = ["center", "batch", "group"]
    selector = App.docIdfy _.objectify seq, cbg.split "/"
    App.session "look_in", selector

Meteor.startup ->
  App.router = new AppRouter()
  Backbone.history.start()
