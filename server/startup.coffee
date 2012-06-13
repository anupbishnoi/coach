refreshDb = ->
  refreshMain()
  refreshPersonnel()
  refreshContent()
  refreshClasses()
  refreshDuties()

Meteor.startup ->
  #if Org.find().count() is 0
    refreshDb()
