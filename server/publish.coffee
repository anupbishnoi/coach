_.each App.collection.list(), (name)->
  Meteor.publish name, ->
    App.collection(name).find()
