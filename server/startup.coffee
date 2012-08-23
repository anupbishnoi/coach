_.each Collection.list(), (name)->
  Meteor.publish name, ->
    Collection(name).find({})

Meteor.startup ->
  #if Find.count("org") is 0
    refreshDb()
