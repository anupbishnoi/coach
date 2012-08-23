refreshClasses = ->
  (Collection name).remove({}) for name in [
    "study_class"
    "absent"
  ]

  study_class = Find.one "doc_type", doc_id: "study_class"
  absent = Find.one "doc_type", doc_id: "absent"
  vmc = Find.one "org", doc_id: "org/vmc"
  pp = Find.one "center", doc_id: "center/vmc/pp"
  xiip05 = Find.one "batch", doc_id: "batch/vmc/12p2005"
  xiip1 = Find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"
  xiip2 = Find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/2"
  anirudh_teacher = Find.one "teacher", doc_id: "teacher/vmc/1"
  physics = Find.one "subject", doc_id: "subject/vmc/physics"
  f_and_m = Find.one "topic", doc_id: "topic/vmc/physics/force_and_momentum"
  room = Find.one "room", doc_id: "room/vmc/pp/3"
  anup_student = Find.one "student", doc_id: "student/vmc/12p05zz1234"

  (Collection "study_class").insert
    doc_id: "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1"

    doc_type: study_class.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    group: xiip1.doc_id
    subject: physics.doc_id
    topic: f_and_m.doc_id
    id: "1" # class no. for the same topic

    from: (new Date 2004, 4, 20, 15, 30).getTime()
    to: (new Date 2004, 4, 20, 18, 30).getTime()
    teacher: anirudh_teacher.doc_id
    room: room.doc_id
    active: true
  class1 = Find.one "study_class",
      doc_id: "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1"

  (Collection "study_class").insert
    doc_id: "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/2].[vmc/physics/force_and_momentum]/1"

    doc_type: study_class.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    group: xiip2.doc_id
    subject: physics.doc_id
    topic: f_and_m.doc_id
    id: "1" # class no. for the same topic (for this group)

    from: (new Date 2004, 4, 21, 15, 30).getTime()
    to: (new Date 2004, 4, 21, 18, 30).getTime()
    teacher: anirudh_teacher.doc_id
    room: room.doc_id
    active: true
  class2 = Find.one "study_class",
      doc_id: "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/2].[vmc/physics/force_and_momentum]/1"

  (Collection "absent").insert
    doc_id: "absent/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1/1"

    doc_type: absent.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    group: xiip1.doc_id
    subject: physics.doc_id
    topic: f_and_m.doc_id
    study_class: class1.doc_id
    id: "1"
    
    student: anup_student.doc_id
    reason: "class kyu ni aaya"
    rescheduled: class2.doc_id
  absent1 = Find.one "absent",
    doc_id: "absent/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1/1"
