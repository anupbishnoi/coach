refreshDb = ->
  refreshMeta()
  refreshMain()
  refreshPersonnel()
  refreshContent()
  refreshClasses()
  refreshDuties()

Meteor.startup ->
  #if App.find.count("org") is 0
    refreshDb()
