_.each Collection.list(), (name)->
  Meteor.publish name, -> Find.cursor name

Meteor.startup ->
  #if (Find.count "org") is 0
    refreshDb()
