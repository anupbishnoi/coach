App.session.searchfor("student")
App.session.resultsview("center_manager")

WorkSpace = Backbone.Router.extend
  routes:
    "add/:entity":    "add"
    #"search/:query/:"
