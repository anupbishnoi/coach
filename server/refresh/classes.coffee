refreshClasses = ->
  collection.remove({}) for collection in [
    Class
    Absent
  ]

  vmc = Org.findOne doc_id: "vmc"
  pp = Center.findOne doc_id: "vmc/center/pp"
  xiip05 = Batch.findOne doc_id: "vmc/batch/12p2005"
  xiip1 = Group.findOne doc_id: "vmc/group/pp/12p2005/1"
  xiip2 = Group.findOne doc_id: "vmc/group/pp/12p2005/2"
  anirudh_teacher = Teacher.findOne doc_id: "vmc/teacher/pp/physics/1"
  physics = Subject.findOne doc_id: "vmc/subject/physics"
  topic = Topic.findOne doc_id: "vmc/topic/physics/force_and_momentum"
  room = Room.findOne doc_id: "vmc/room/pp/3"
  anup_student = Student.findOne doc_id: "vmc/student/12p05zz1234"

  Class.insert
    doc_id: "vmc/class/pp/12p2005/1/physics/force_and_momentum/1"

    org: vmc.doc_id
    doc_type: "class"
    group: xiip1.doc_id
    subject: physics.doc_id
    topic: topic.doc_id
    id: 1 # class no. for the same topic

    center: pp.doc_id
    batch: xiip05.doc_id
    from: "20 May 2004, 3:30 PM"
    to: "20 May 2004, 6:30 PM"
    teacher: anirudh_teacher.doc_id
    room: room.doc_id
  class1 = Class.findOne
      doc_id: "vmc/class/pp/12p2005/1/physics/force_and_momentum/1"

  Class.insert
    doc_id: "vmc/class/pp/12p2005/2/physics/force_and_momentum/1"

    org: vmc.doc_id
    doc_type: "class"
    group: xiip2.doc_id
    subject: physics.doc_id
    topic: topic.doc_id
    id: 1 # class no. for the same topic

    center: pp.doc_id
    batch: xiip05.doc_id
    from: "21 May 2004, 3:30 PM"
    to: "21 May 2004, 6:30 PM"
    teacher: anirudh_teacher.doc_id
    room: room.doc_id
  class2 = Class.findOne
      doc_id: "vmc/class/pp/12p2005/2/physics/force_and_momentum/1"

  Absent.insert
    doc_id: "vmc/absent/pp/12p2005/1/physics/force_and_momentum/1/12p05zz1234"

    org: vmc.doc_id
    doc_type: "absent"
    class: class1.doc_id
    rollno: anup_student.doc_id

    reason: "class kyu ni aaya"
    rescheduled: class2.doc_id
  absent = Absent.findOne
    doc_id: "vmc/absent/12p05zz1234/pp/12p2005/1/physics/force_and_momentum/1"
