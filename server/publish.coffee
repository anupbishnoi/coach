Meteor.publish "student", (argobj)->
  ensure.inside "Meteor.publish student", arguments
  if argobj
    ensure "object", argobj
    {center, batch, group} = argobj
    ensure "center", center if center
    ensure "batch", batch if batch
    ensure "group", group if group
  self = this
  handle_student = Student.find().observe # can't do this
    added: (doc, i)->
      self.set("student", doc.doc_id, doc)
      self.flush()

  handle_person = Person.find().observe # can't do this, no no
    added: (doc, i)->
      person = doc.doc_id
      students = (Student.find {person}).fetch()
      _.forEach students, (student)->
        self.set("student", student.doc_id,
          doc_name: doc.doc_name
          address: doc.address
        )
        self.flush()
  self.onStop ->
    handle_person.stop()
    handle_student.stop()
    self.flush()

Meteor.publish "center", ->
  ensure.inside "Meteor.publish center", arguments
  self = this
  handle_center = Center.find().observe
    added: (doc, i)->
      self.set("center", doc.doc_id, doc)
      self.flush()
  self.onStop ->
    handle_center.stop()
    self.flush()

Meteor.publish "batch", ->
  ensure.inside "Meteor.publish batch", arguments
  self = this
  handle_batch = Batch.find().observe
    added: (doc, i)->
      self.set("batch", doc.doc_id, doc)
      self.flush()
  self.onStop ->
    handle_batch.stop()
    self.flush()

Meteor.publish "group", ->
  ensure.inside "Meteor.publish group", arguments
  self = this
  handle_group = Group.find().observe
    added: (doc, i)->
      self.set("group", doc.doc_id, doc)
      self.flush()
  self.onStop ->
    handle_group.stop()
    self.flush()

