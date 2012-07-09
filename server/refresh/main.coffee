refreshMain = ->
  App.collection(name).remove({}) for name in [
    "org"
    "center"
    "batch"
    "due_installment"
    "group"
    "room"

    "subject"
    "topic"
    "study_material_type"
    "study_material"
  ]

  org = App.find.one "doc_type", doc_id: "org"
  center = App.find.one "doc_type", doc_id: "center"
  batch = App.find.one "doc_type", doc_id: "batch"
  due_installment = App.find.one "doc_type", doc_id: "due_installment"
  group = App.find.one "doc_type", doc_id: "group"
  room = App.find.one "doc_type", doc_id: "room"
  subject = App.find.one "doc_type", doc_id: "subject"
  topic = App.find.one "doc_type", doc_id: "topic"
  study_material_type = App.find.one "doc_type", doc_id: "study_material_type"
  study_material = App.find.one "doc_type", doc_id: "study_material"

  App.collection("org").insert
    doc_id: "org/vmc"

    doc_type: org.doc_id
    id: "vmc"

    doc_name: "Vidyamandir Classes"
    active: true
  vmc = App.find.one "org", doc_id: "org/vmc"

  App.collection("center").insert
    doc_id: "center/vmc/pp"

    doc_type: center.doc_id
    org: vmc.doc_id
    id: "pp"

    doc_name: "Pitampura"
    address: "3rd Floor, Aggarwal Corporate Heights, NSP"
    active: true
  pp = App.find.one "center", doc_id: "center/vmc/pp"

  App.collection("batch").insert
    doc_id: "batch/vmc/12p2005"

    doc_type: batch.doc_id
    org: vmc.doc_id
    id: "12p2005"

    center: [pp.doc_id]
    doc_name: "XIIth Pass 2005"
    duration: "1 year"
    fee: 125000
    accrual_per_month: 125000/10 # accrual stops end of march, classes almost over
    active: true
  xiip05 = App.find.one "batch", doc_id: "batch/vmc/12p2005"

  App.collection("due_installment").insert
    doc_id: "due_installment/vmc/12p2005/1"

    doc_type: due_installment.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "1"

    amount: 110000
    on: new Date 2004, 11, 31, 18, 0, 0, 0
    active: true
  due1 = App.find.one "due_installment", doc_id: "due_installment/vmc/12p2005/1"

  App.collection("due_installment").insert
    doc_id: "due_installment/vmc/12p2005/2"

    doc_type: due_installment.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "2"

    amount: 15000
    on: new Date 2005, 2, 31, 18, 0, 0, 0
    active: true
  due2 = App.find.one "due_installment", doc_id: "due_installment/vmc/12p2005/2"

  App.collection("group").insert
    doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"

    doc_type: group.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    id: "1"
    
    doc_name: "XIIth Pass 1"
    active: true
  xiip1 = App.find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"

  App.collection("group").insert
    doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/2"

    doc_type: group.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    id: "2"
    
    doc_name: "XIIth Pass 2"
    active: true
  xiip2 = App.find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/2"

  App.collection("room").insert
    doc_id: "room/vmc/pp/3"
    
    doc_type: room.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "3"

    doc_name: "Room 3"
    capacity: 45
    floor: "3rd Floor"
    active: true
  room = App.find.one "room", doc_id: "room/vmc/pp/3"

  App.collection("subject").insert
    doc_id: "subject/vmc/physics"

    doc_type: subject.doc_id
    org: vmc.doc_id
    id: "physics"

    doc_name: "Physics"
    public: true
    active: true
  physics = App.find.one "subject", doc_id: "subject/vmc/physics"

  App.collection("topic").insert
    doc_id: "topic/vmc/physics/force_and_momentum"

    doc_type: topic.doc_id
    org: vmc.doc_id
    subject: physics.doc_id
    id: "force_and_momentum"

    doc_name: "Force and Momentum"
    level: "advanced" # could make a TopicLevel object
    public: true
    active: true
  f_and_m = App.find.one "topic", doc_id: "topic/vmc/physics/force_and_momentum"

  App.collection("study_material_type").insert
    doc_id: "study_material_type/vmc/module"

    doc_type: study_material_type.doc_id
    org: vmc.doc_id
    id: "module"

    doc_name: "Module"
    active: true
  module = App.find.one "study_material_type",
    doc_id: "study_material_type/vmc/module"

  App.collection("study_material").insert
    doc_id: "study_material/vmc/[vmc/12p2005].[vmc/physics].[vmc/module]/1"

    doc_type: study_material.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    subject: physics.doc_id
    type: module.doc_id
    id: "1"

    doc_name: "Physics - Module 1"
    contents: [ f_and_m.doc_id ]
    scanned: []
    active: true
  physics_module = App.find.one "study_material",
    doc_id: "study_material/vmc/[vmc/12p2005].[vmc/physics].[vmc/module]/1"
