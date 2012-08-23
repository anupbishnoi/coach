refreshdb = ->
  Collection.reset()

  # Meta
  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "org"
  org = Find "doc_type/org"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "center"
  center = Find "doc_type/center"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "batch"
  batch = Find "doc_type/batch"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "due_installment"
  due_installment = Find "doc_type/due_installment"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "group"
  group = Find "doc_type/group"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "room"
  room = Find "doc_type/room"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "subject"
  subject = Find "doc_type/subject"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "topic"
  topic = Find "doc_type/topic"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "study_material_type"
  study_material_type = Find "doc_type/study_material_type"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "study_material"
  study_material = Find "doc_type/study_material"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "person"
  person = Find "doc_type/person"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_head"
  center_head = Find "doc_type/center_head"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "vendor"
  vendor = Find "doc_type/vendor"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_staff"
  center_staff = Find "doc_type/center_staff"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_coordinator"
  center_coordinator = Find "doc_type/center_coordinator"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "teacher"
  teacher = Find "doc_type/teacher"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "in_out"
  in_out = Find "doc_type/in_out"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "applicant"
  applicant = Find "doc_type/applicant"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "applicant_discount"
  applicant_discount = Find "doc_type/applicant_discount"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "applicant_receipt"
  applicant_receipt = Find "doc_type/applicant_receipt"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "student"
  student = Find "doc_type/student"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "student_discount"
  student_discount = Find "doc_type/student_discount"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "student_receipt"
  student_receipt = Find "doc_type/student_receipt"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "accrual"
  accrual = Find "doc_type/accrual"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "refund"
  refund = Find "doc_type/refund"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "question"
  question = Find "doc_type/question"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "solution"
  solution = Find "doc_type/solution"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "question_paper"
  question_paper = Find "doc_type/question_paper"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "admission_test"
  admission_test = Find "doc_type/admission_test"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "study_class"
  study_class = Find "doc_type/study_class"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "absent"
  absent = Find "doc_type/absent"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "duty_type"
  duty_type = Find "doc_type/duty_type"

  (Collection "doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_coordinator_duty"
  center_coordinator_duty = Find "doc_type/center_coordinator_duty"

  # Main
  (Collection "org").insert
    doc_id: "org/vmc"

    doc_type: org.doc_id
    id: "vmc"

    doc_name: "Vidyamandir Classes"
    active: true
  vmc = Find.one "org", doc_id: "org/vmc"

  (Collection "center").insert
    doc_id: "center/vmc/pp"

    doc_type: center.doc_id
    org: vmc.doc_id
    id: "pp"

    doc_name: "Pitampura"
    address: "3rd Floor, Aggarwal Corporate Heights, NSP"
    active: true
  pp = Find.one "center", doc_id: "center/vmc/pp"

  (Collection "batch").insert
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
  xiip05 = Find.one "batch", doc_id: "batch/vmc/12p2005"

  (Collection "due_installment").insert
    doc_id: "due_installment/vmc/12p2005/1"

    doc_type: due_installment.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "1"

    amount: 110000
    on: (new Date 2004, 11, 31, 18).getTime()
    active: true
  due1 = Find.one "due_installment", doc_id: "due_installment/vmc/12p2005/1"

  (Collection "due_installment").insert
    doc_id: "due_installment/vmc/12p2005/2"

    doc_type: due_installment.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "2"

    amount: 15000
    on: (new Date 2005, 2, 31, 18).getTime()
    active: true
  due2 = Find.one "due_installment", doc_id: "due_installment/vmc/12p2005/2"

  (Collection "group").insert
    doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"

    doc_type: group.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    id: "1"
    
    doc_name: "XIIth Pass 1"
    active: true
  xiip1 = Find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"

  (Collection "group").insert
    doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/2"

    doc_type: group.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    id: "2"
    
    doc_name: "XIIth Pass 2"
    active: true
  xiip2 = Find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/2"

  (Collection "room").insert
    doc_id: "room/vmc/pp/3"
    
    doc_type: room.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "3"

    doc_name: "Room 3"
    capacity: 45
    floor: "3rd Floor"
    active: true
  room = Find.one "room", doc_id: "room/vmc/pp/3"

  (Collection "subject").insert
    doc_id: "subject/vmc/physics"

    doc_type: subject.doc_id
    org: vmc.doc_id
    id: "physics"

    doc_name: "Physics"
    public: true
    active: true
  physics = Find.one "subject", doc_id: "subject/vmc/physics"

  (Collection "topic").insert
    doc_id: "topic/vmc/physics/force_and_momentum"

    doc_type: topic.doc_id
    org: vmc.doc_id
    subject: physics.doc_id
    id: "force_and_momentum"

    doc_name: "Force and Momentum"
    level: "advanced" # could make a TopicLevel object
    public: true
    active: true
  f_and_m = Find.one "topic", doc_id: "topic/vmc/physics/force_and_momentum"

  (Collection "study_material_type").insert
    doc_id: "study_material_type/vmc/module"

    doc_type: study_material_type.doc_id
    org: vmc.doc_id
    id: "module"

    doc_name: "Module"
    active: true
  module = Find.one "study_material_type",
    doc_id: "study_material_type/vmc/module"

  (Collection "study_material").insert
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
  physics_module = Find.one "study_material",
    doc_id: "study_material/vmc/[vmc/12p2005].[vmc/physics].[vmc/module]/1"

  # Personnel
  (Collection "person").insert
    doc_id: "person/1"

    doc_type: person.doc_id
    id: "1"

    doc_name: "Sandeep Mehta"
    timestamp: (new Date 2012, 4, 26, 19, 0, 0, 0).getTime()
    phone: ["+91-9953001820"]
    email: ["sandeep@vidyamandir.com"]
  sandeep_person = Find.one "person",
    doc_id: "person/1"

  (Collection "person").insert
    doc_id: "person/2"

    doc_type: person.doc_id
    id: "2"

    doc_name: "Pradeep Singh"
    timestamp: (new Date 2012, 4, 26, 19, 5, 0, 0).getTime()
    phone: ["+91-8588801202"]
  psingh_person = Find.one "person",
    doc_id: "person/2"

  (Collection "person").insert
    doc_id: "person/3"

    doc_type: person.doc_id
    id: "3"

    doc_name: "Sujeet Shivhare"
    timestamp: (new Date 2012, 4, 26, 19, 10, 0, 0).getTime()
    phone: ["+91-8588801214", "+91-9013926056"]
    email: ["sujeet.shivhare@vidyamandir.com"]
  sujeet_person = Find.one "person",
    doc_id: "person/3"

  (Collection "person").insert
    doc_id: "person/4"

    doc_type: person.doc_id
    id: "4"

    doc_name: "Ajay Pathak"
    timestamp: (new Date 2012, 4, 26, 19, 12, 0, 0).getTime()
    phone: ["+91-8588801213"]
    email: ["pathak@vidyamandir.com"]
  pathak_person = Find.one "person",
    doc_id: "person/4"

  (Collection "person").insert
    doc_id: "person/5"

    doc_type: person.doc_id
    id: "5"

    doc_name: "Deepak"
    timestamp: (new Date 2012, 4, 26, 19, 15, 0, 0).getTime()
    phone: ["+91-9717556926"]
  deepak_person = Find.one "person",
    doc_id: "person/5"

  (Collection "person").insert
    doc_id: "person/6"

    doc_type: person.doc_id
    id: "6"

    doc_name: "Divik Jain"
    timestamp: (new Date 2012, 4, 26, 19, 22, 0, 125).getTime()
    phone: ["+91-9582999301"]
    email: ["divik.jain@gmail.com"]
  divik_person = Find.one "person",
    doc_id: "person/6"

  (Collection "person").insert
    doc_id: "person/7"

    doc_type: person.doc_id
    id: "7"

    doc_name: "Anirudh Mendiratta"
    timestamp: (new Date 2012, 4, 26, 19, 22, 10, 125).getTime()
    phone: ["+91-9818394025"]
    email: ["anirudh@gmail.com"]
  anirudh_person = Find.one "person",
    doc_id: "person/7"

  (Collection "person").insert
    doc_id: "person/8"

    doc_type: person.doc_id
    id: "8"

    doc_name: "Anup Bishnoi"
    timestamp: (new Date 2012, 4, 26, 19, 20, 0, 125).getTime()
    dob: (new Date 1986, 7, 21).getTime()
    phone: ["+91-9868768262", "+91-11-27517704"]
    email: [ "pixelsallover@gmail.com"
           , "anup.bishnoi@vidyamandir.com"
           ]
    address: "39/H-33, Sector-3, Rohini, Delhi - 110085"
  anup_person = Find.one "person",
    doc_id: "person/8"

  (Collection "center_head").insert
    doc_id: "center_head/vmc/pp/1"

    doc_type: center_head.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "1"

    doc_name: "Sandeep Bhaiya"
    person: sandeep_person.doc_id
    active: true
  sandeep_head = Find.one "center_head", doc_id: "center_head/vmc/pp/1"

  (Collection "vendor").insert
    doc_id: "vendor/vmc/1"

    doc_type: vendor.doc_id
    org: vmc.doc_id
    id: "1"

    doc_name: "Pradeep Singh"
    person: psingh_person.doc_id
    active: true
  psingh_vendor = Find.one "vendor", doc_id: "vendor/vmc/1"

  (Collection "center_staff").insert
    doc_id: "center_staff/vmc/pp/1"

    doc_type: center_staff.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "1"

    doc_name: "Deepak"
    intime: "9 AM"
    outtime: "8 PM"
    person: deepak_person.doc_id
    active: true
  deepak_staff = Find.one "center_staff", doc_id: "center_staff/vmc/pp/1"

  (Collection "center_staff_in_out").insert
    doc_id: "in_out/vmc/pp/1/1"

    doc_type: in_out.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_staff: deepak_staff.doc_id
    id: "1"

    in: (new Date 2012, 4, 26, 9, 30).getTime()
    out: (new Date 2012, 4, 26, 7, 30).getTime()
  in_out1 = Find.one "center_staff_in_out", doc_id: "in_out/vmc/pp/1/1"

  (Collection "center_coordinator").insert
    doc_id: "center_coordinator/vmc/pp/2"

    doc_type: center_coordinator.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "2"

    person: sujeet_person.doc_id
    active: true
  sujeet_coordinator = Find.one "center_coordinator", doc_id: "center_coordinator/vmc/pp/2"

  (Collection "teacher").insert
    doc_id: "teacher/vmc/1"
    
    doc_type: teacher.doc_id
    org: vmc.doc_id
    id: "1"

    doc_name: "Anirudh Bhaiya"
    subject: [physics.doc_id]
    person: anirudh_person.doc_id
    active: true
  anirudh_teacher = Find.one "teacher", doc_id: "teacher/vmc/1"
  
  (Collection "applicant").insert
    doc_id: "applicant/vmc/12p2005/1/pp3010"

    doc_type: applicant.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    # because admission_test hasn't been initialised yet
    admission_test: "admission_test/vmc/12p2005/1" # repeated thrice in this file
    id: "pp3010"

    center: pp.doc_id # enrollment center
    person: anup_person.doc_id
    test:
      admit_card: "attach pdf link"
      center: pp.doc_id
    registration:
      time: (new Date 2004, 4, 4, 9).getTime()
      center: pp.doc_id # registration center
      slot: "1"
      discount: "20%"
    active: true
  anup_applicant = Find.one "applicant", doc_id: "applicant/vmc/12p2005/1/pp3010"

  (Collection "applicant_discount").insert
    doc_id: "applicant_discount/vmc/12p2005/1/pp3010/1"

    doc_type: applicant_discount.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    admission_test: "admission_test/vmc/12p2005/1"
    applicant: anup_applicant.doc_id
    id: "1"

    center: pp.doc_id
    amount: 200
    on: (new Date 2004, 1, 20, 10, 45).getTime()
    by: sandeep_head.doc_id
    reason: "NTSE Scholar"
    proof: "attach proof"
  adm_discount = Find.one "applicant_discount",
    doc_id: "applicant_discount/vmc/12p2005/1/pp3010/1"

  (Collection "applicant_receipt").insert
    doc_id: "applicant_receipt/vmc/12p2005/1/pp3010/1"

    doc_type: applicant_receipt.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    admission_test: "admission_test/vmc/12p2005/1"
    applicant: anup_applicant.doc_id
    id: "1"

    center: pp.doc_id
    amount: 500
    on: (new Date 2004, 1, 20, 11).getTime()
    proof: "scanned photo of receipt (and cheque)"
  adm_receipt = Find.one "applicant_receipt",
    doc_id: "applicant_receipt/vmc/12p2005/1/pp3010/1"

  (Collection "student").insert
    doc_id: "student/vmc/12p05zz1234"

    doc_type: student.doc_id
    org: vmc.doc_id
    id: "12p05zz1234"

    center: pp.doc_id # allotted center
    batch: xiip05.doc_id
    group: xiip1.doc_id # can be an array
    applicant: anup_applicant.doc_id
    person: anup_person.doc_id
    active: true
  anup_student = Find.one "student", doc_id: "student/vmc/12p05zz1234"

  (Collection "student_discount").insert
    doc_id: "student_discount/vmc/12p05zz1234/1"

    doc_type: student_discount.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10000
    on: (new Date 2004, 5, 10, 10).getTime()
    by: sandeep_head.doc_id
    reason: "just realised he's awesome. wakau!"
    proof: "attach proof of awesomeness"
  stud_discount = Find.one "student_discount",
    doc_id: "student_discount/vmc/12p05zz1234/1"

  (Collection "student_receipt").insert
    doc_id: "student_receipt/vmc/12p05zz1234/1"

    doc_type: student_receipt.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 40000
    on: (new Date 2004, 4, 5, 11, 30).getTime()
    cheque:
      favorof: "Vidyamandir Classes"
      branch: "blah"
      deposited:
        by: deepak_staff.doc_id
        on: (new Date 2004, 4, 7, 10).getTime()
    proof: "attached scanned link"
  stud_receipt = Find.one "student_receipt",
    doc_id: "student_receipt/vmc/12p05zz1234/1"

  (Collection "accrual").insert
    doc_id: "accrual/vmc/12p05zz1234/1"

    doc_type: accrual.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10212
    on: (new Date 2004, 5, 1, 10, 30).getTime()
  accr1 = Find.one "accrual", doc_id: "accrual/vmc/12p05zz1234/1"

  (Collection "accrual").insert
    doc_id: "accrual/vmc/12p05zz1234/2"

    doc_type: accrual.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "2"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 13235
    on: (new Date 2004, 6, 1, 10, 30).getTime()
  accr2 = Find.one "accrual", doc_id: "accrual/vmc/12p05zz1234/2"

  (Collection "refund").insert
    doc_id: "refund/vmc/12p05zz1234/1"

    doc_type: refund.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    on: (new Date 2004, 6, 25, 17).getTime()
    by: sandeep_head.doc_id
    amount: 8023
    reason: "Don't like his face"
    proof: "photograph?"
  refund1 = Find.one "refund", doc_id: "refund/vmc/12p05zz1234"
