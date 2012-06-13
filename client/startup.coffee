Session.set "org", "vmc"
Session.set "view_as", "center_manager"
Session.set "search_for", "student"
Session.set "look_in/selected", "pp/12p2005"

AppRouter = Backbone.Router.extend
  routes:
    "add/:entity":                      "add"
    "search_for/:entity":               "search_for"
  add: (entity)->
    console.log entity
    console.log arguments
  search_for: (entity)->
    Session.set "search_for", entity

Meteor.startup ->
  App.router = new AppRouter()
  Backbone.history.start()
