refreshMain = ->
  collection.remove({}) for collection in [
    Org
    Center
    Batch
    Group
    Room
    DayType
    DutyType

    Subject
    Topic
    StudyMaterialType
    StudyMaterial
    QuestionPaper
    AdmissionTest
  ]

  Org.insert
    doc_id: "vmc"

    id: "vmc"

    doc_name: "Vidyamandir Classes"
    active: true
  vmc = Org.findOne doc_id: "vmc"

  Center.insert
    doc_id: "vmc/center/pp"

    org: vmc.doc_id
    doc_type: "center"
    id: "pp"

    doc_name: "Pitampura"
    address: "3rd Floor, Aggarwal Corporate Heights, NSP"
    active: true
  pp = Center.findOne doc_id: "vmc/center/pp"

  Batch.insert
    doc_id: "vmc/batch/12p2005"

    org: vmc.doc_id
    doc_type: "batch"
    id: "12p2005"

    doc_name: "XIIth Pass 2005"
    duration: "1 year"
    fee: 125000
    accrual_per_month: 125000/10 # accrual stops end of march, classes almost over
    active: true
  xiip05 = Batch.findOne doc_id: "vmc/batch/12p2005"

  Group.insert
    doc_id: "vmc/group/pp/12p2005/1"

    org: vmc.doc_id
    doc_type: "group"
    center: pp.doc_id
    batch: xiip05.doc_id
    id: 1
    
    doc_name: "XIIth Pass 1"
    active: true
  xiip1 = Group.findOne doc_id: "vmc/group/pp/12p2005/1"

  Group.insert
    doc_id: "vmc/group/pp/12p2005/2"

    org: vmc.doc_id
    doc_type: "group"
    center: pp.doc_id
    batch: xiip05.doc_id
    id: 2
    
    doc_name: "XIIth Pass 2"
    active: true
  xiip2 = Group.findOne doc_id: "vmc/group/pp/12p2005/2"

  Room.insert
    doc_id: "vmc/room/pp/3"
    
    org: vmc.doc_id
    doc_type: "room"
    center: pp.doc_id
    id: 3

    doc_name: "Room 3"
    capacity: 45
    floor: "3rd Floor"
    active: true
  room = Room.findOne doc_id: "vmc/room/pp/3"

  DayType.insert
    doc_id: "vmc/day_type/working_day"

    org: vmc.doc_id
    doc_type: "day_type"
    id: "working_day"

    doc_name: "Working Day"
    description: "Non-holiday working days for Vidyamandir Classes"
    #todo: describe/list the holidays
  working_day = DayType.findOne
    doc_id: "vmc/day_type/working_day"

  Subject.insert
    doc_id: "vmc/subject/physics"

    org: vmc.doc_id
    doc_type: "subject"
    id: "physics"

    doc_name: "Physics"
    public: true
  physics = Subject.findOne doc_id: "vmc/subject/physics"

  Topic.insert
    doc_id: "vmc/topic/physics/force_and_momentum"

    org: vmc.doc_id
    doc_type: "topic"
    subject: physics.doc_id
    id: "force_and_momentum"

    doc_name: "Force and Momentum"
    level: "advanced" # could make a TopicLevel object
    public: true
  topic = Topic.findOne doc_id: "vmc/topic/physics/force_and_momentum"

  StudyMaterialType.insert
    doc_id: "vmc/study_material_type/module"

    org: vmc.doc_id
    doc_type: "study_material_type"
    id: "module"

    doc_name: "Module"
  module_type = StudyMaterialType.findOne
    doc_id: "vmc/study_material_type/module"

  StudyMaterial.insert
    doc_id: "vmc/study_material/12p2005/physics/module/1"

    org: vmc.doc_id
    doc_type: "study_material"
    batch: xiip05.doc_id
    subject: physics.doc_id
    type: module_type.doc_id
    id: 1

    doc_name: "Physics - Module 1"
    contents: [ topic.doc_id ]
    scanned: []
  physics_module = StudyMaterial.findOne
    doc_id: "vmc/study_material/12p2005/physics/module/1"

  QuestionPaper.insert
    doc_id: "vmc/question_paper/pp/359"

    org: vmc.doc_id
    doc_type: "question_paper"
    center: pp.doc_id
    id: 359

    questions: []
  question_paper = QuestionPaper.findOne
    doc_id: "vmc/question_paper/pp/359"

  AdmissionTest.insert
    doc_id: "vmc/admission_test/12p2005/1"

    org: vmc.doc_id
    doc_type: "admission_test"
    batch: xiip05.doc_id
    id: 1

    doc_name: "Vidyamandir XIIth Pass Admission Test for IITJEE - 2005"
    on: "29 February 2004"
    from: "3:00 PM"
    to: "6:00 PM"
    duration: "3 hours"
    sections: [] # marking scheme and total marks are part of sections
    instructions: []
    styling: {}
    question_paper: question_paper.doc_id
  admtest = AdmissionTest.findOne doc_id: "vmc/admission_test/12p2005/1"

