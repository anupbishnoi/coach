_.each Collection.list(), (name) ->
  Meteor.publish name, -> Find.cursor name

Meteor.startup ->
  dummyDb()
  #refreshDb()
