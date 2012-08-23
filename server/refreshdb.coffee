refreshDb = ->
  Collection.reset()

  (Collection "doc_type").insert
    doc_id: "doc_type/org"

    doc_type: "doc_type"
    id: "org"
  org = Find "doc_type/org"

  (Collection "doc_type").insert
    doc_id: "doc_type/center"

    doc_type: "doc_type"
    id: "center"
  center = Find "doc_type/center"

  (Collection "doc_type").insert
    doc_id: "doc_type/batch"

    doc_type: "doc_type"
    id: "batch"
  batch = Find "doc_type/batch"

  (Collection "doc_type").insert
    doc_id: "doc_type/due_installment"

    doc_type: "doc_type"
    id: "due_installment"
  due_installment = Find "doc_type/due_installment"

  (Collection "doc_type").insert
    doc_id: "doc_type/group"

    doc_type: "doc_type"
    id: "group"
  group = Find "doc_type/group"

  (Collection "doc_type").insert
    doc_id: "doc_type/room"

    doc_type: "doc_type"
    id: "room"
  room = Find "doc_type/room"

  (Collection "doc_type").insert
    doc_id: "doc_type/subject"

    doc_type: "doc_type"
    id: "subject"
  subject = Find "doc_type/subject"

  (Collection "doc_type").insert
    doc_id: "doc_type/topic"

    doc_type: "doc_type"
    id: "topic"
  topic = Find "doc_type/topic"

  (Collection "doc_type").insert
    doc_id: "doc_type/study_material_type"

    doc_type: "doc_type"
    id: "study_material_type"
  study_material_type = Find "doc_type/study_material_type"

  (Collection "doc_type").insert
    doc_id: "doc_type/study_material"

    doc_type: "doc_type"
    id: "study_material"
  study_material = Find "doc_type/study_material"

  (Collection "doc_type").insert
    doc_id: "doc_type/person"

    doc_type: "doc_type"
    id: "person"
  person = Find "doc_type/person"

  (Collection "doc_type").insert
    doc_id: "doc_type/center_head"

    doc_type: "doc_type"
    id: "center_head"
  center_head = Find "doc_type/center_head"

  (Collection "doc_type").insert
    doc_id: "doc_type/center_manager"

    doc_type: "doc_type"
    id: "center_manager"
  center_manager = Find "doc_type/center_manager"

  (Collection "doc_type").insert
    doc_id: "doc_type/vendor"

    doc_type: "doc_type"
    id: "vendor"
  vendor = Find "doc_type/vendor"

  (Collection "doc_type").insert
    doc_id: "doc_type/center_staff"

    doc_type: "doc_type"
    id: "center_staff"
  center_staff = Find "doc_type/center_staff"

  (Collection "doc_type").insert
    doc_id: "doc_type/center_coordinator"

    doc_type: "doc_type"
    id: "center_coordinator"
  center_coordinator = Find "doc_type/center_coordinator"

  (Collection "doc_type").insert
    doc_id: "doc_type/teacher"

    doc_type: "doc_type"
    id: "teacher"
  teacher = Find "doc_type/teacher"

  (Collection "doc_type").insert
    doc_id: "doc_type/in_out"

    doc_type: "doc_type"
    id: "in_out"
  in_out = Find "doc_type/in_out"

  (Collection "doc_type").insert
    doc_id: "doc_type/applicant"

    doc_type: "doc_type"
    id: "applicant"
  applicant = Find "doc_type/applicant"

  (Collection "doc_type").insert
    doc_id: "doc_type/applicant_discount"

    doc_type: "doc_type"
    id: "applicant_discount"
  applicant_discount = Find "doc_type/applicant_discount"

  (Collection "doc_type").insert
    doc_id: "doc_type/applicant_receipt"

    doc_type: "doc_type"
    id: "applicant_receipt"
  applicant_receipt = Find "doc_type/applicant_receipt"

  (Collection "doc_type").insert
    doc_id: "doc_type/student"

    doc_type: "doc_type"
    id: "student"
  student = Find "doc_type/student"

  (Collection "doc_type").insert
    doc_id: "doc_type/student_discount"

    doc_type: "doc_type"
    id: "student_discount"
  student_discount = Find "doc_type/student_discount"

  (Collection "doc_type").insert
    doc_id: "doc_type/student_receipt"

    doc_type: "doc_type"
    id: "student_receipt"
  student_receipt = Find "doc_type/student_receipt"

  (Collection "doc_type").insert
    doc_id: "doc_type/accrual"

    doc_type: "doc_type"
    id: "accrual"
  accrual = Find "doc_type/accrual"

  (Collection "doc_type").insert
    doc_id: "doc_type/refund"

    doc_type: "doc_type"
    id: "refund"
  refund = Find "doc_type/refund"

  (Collection "doc_type").insert
    doc_id: "doc_type/question"

    doc_type: "doc_type"
    id: "question"
  question = Find "doc_type/question"

  (Collection "doc_type").insert
    doc_id: "doc_type/solution"

    doc_type: "doc_type"
    id: "solution"
  solution = Find "doc_type/solution"

  (Collection "doc_type").insert
    doc_id: "doc_type/question_paper"

    doc_type: "doc_type"
    id: "question_paper"
  question_paper = Find "doc_type/question_paper"

  (Collection "doc_type").insert
    doc_id: "doc_type/admission_test"

    doc_type: "doc_type"
    id: "admission_test"
  admission_test = Find "doc_type/admission_test"

  (Collection "doc_type").insert
    doc_id: "doc_type/study_class"

    doc_type: "doc_type"
    id: "study_class"
  study_class = Find "doc_type/study_class"

  (Collection "doc_type").insert
    doc_id: "doc_type/absent"

    doc_type: "doc_type"
    id: "absent"
  absent = Find "doc_type/absent"

  (Collection "doc_type").insert
    doc_id: "doc_type/duty_type"

    doc_type: "doc_type"
    id: "duty_type"
  duty_type = Find "doc_type/duty_type"

  (Collection "doc_type").insert
    doc_id: "doc_type/center_coordinator_duty"

    doc_type: "doc_type"
    id: "center_coordinator_duty"
  center_coordinator_duty = Find "doc_type/center_coordinator_duty"

  (Collection "org").insert
    doc_id: "org/vmc"

    doc_type: org.doc_id
    id: "vmc"

    doc_name: "Vidyamandir Classes"
    active: true
  vmc = Find "org/vmc"

  (Collection "center").insert
    doc_id: "center/vmc/pp"

    doc_type: center.doc_id
    org: vmc.doc_id
    id: "pp"

    doc_name: "Pitampura"
    address: "3rd Floor, Aggarwal Corporate Heights, NSP"
    active: true
  pp = Find "center/vmc/pp"

  (Collection "batch").insert
    doc_id: "batch/vmc/12p2005"

    doc_type: batch.doc_id
    org: vmc.doc_id
    id: "12p2005"

    center: [ pp.doc_id ]
    doc_name: "XIIth Pass 2005"
    duration: "1 year"
    fee: 125000
    accrual_per_month: 125000/10 # accrual stops end of march, classes almost over
    active: true
  xiip05 = Find "batch/vmc/12p2005"

  (Collection "due_installment").insert
    doc_id: "due_installment/vmc/12p2005/1"

    doc_type: due_installment.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "1"

    amount: 110000
    on: (moment.utc [2004, 11, 31, 18]).valueOf()
    active: true
  due1 = Find "due_installment/vmc/12p2005/1"

  (Collection "due_installment").insert
    doc_id: "due_installment/vmc/12p2005/2"

    doc_type: due_installment.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "2"

    amount: 15000
    on: (moment.utc [2005, 2, 31, 18]).valueOf()
    active: true
  due2 = Find "due_installment/vmc/12p2005/2"

  (Collection "group").insert
    doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"

    doc_type: group.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    id: "1"
    
    doc_name: "XIIth Pass 1"
    active: true
  xiip1 = Find "group/vmc/[vmc/pp].[vmc/12p2005]/1"

  (Collection "group").insert
    doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/2"

    doc_type: group.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    batch: xiip05.doc_id
    id: "2"
    
    doc_name: "XIIth Pass 2"
    active: true
  xiip2 = Find "group/vmc/[vmc/pp].[vmc/12p2005]/2"

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
  room_3 = Find "room/vmc/pp/3"

  (Collection "subject").insert
    doc_id: "subject/vmc/physics"

    doc_type: subject.doc_id
    org: vmc.doc_id
    id: "physics"

    doc_name: "Physics"
    public: true
    active: true
  physics = Find "subject/vmc/physics"

  (Collection "subject").insert
    doc_id: "subject/vmc/chemistry"

    doc_type: subject.doc_id
    org: vmc.doc_id
    id: "chemistry"

    doc_name: "Chemistry"
    public: true
    active: true
  chemistry = Find "subject/vmc/chemistry"

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
  f_and_m = Find "topic/vmc/physics/force_and_momentum"

  (Collection "study_material_type").insert
    doc_id: "study_material_type/vmc/module"

    doc_type: study_material_type.doc_id
    org: vmc.doc_id
    id: "module"

    doc_name: "Module"
    active: true
  module = Find "study_material_type/vmc/module"

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
  physics_module = Find "study_material/vmc/[vmc/12p2005].[vmc/physics].[vmc/module]/1"

  (Collection "person").insert
    doc_id: "person/1"

    doc_type: person.doc_id
    id: "1"

    doc_name: "Sandeep Mehta"
    timestamp: (moment.utc [2012, 4, 26, 19, 0, 0, 0]).valueOf()
    phone: [ "+91-9953001820" ]
    email: [ "sandeep@vidyamandir.com" ]
    role: [ "center_head/vmc/pp/1" ]
  sandeep_person = Find "person/1"

  (Collection "person").insert
    doc_id: "person/2"

    doc_type: person.doc_id
    id: "2"

    doc_name: "Pradeep Singh"
    timestamp: (moment.utc [2012, 4, 26, 19, 5, 0, 0]).valueOf()
    phone: ["+91-8588801202"]
    role: [ "vendor/vmc/1" ]
  psingh_person = Find "person/2"

  (Collection "person").insert
    doc_id: "person/3"

    doc_type: person.doc_id
    id: "3"

    doc_name: "Sujeet Shivhare"
    timestamp: (moment.utc [2012, 4, 26, 19, 10, 0, 0]).valueOf()
    phone: ["+91-8588801214", "+91-9013926056"]
    email: ["sujeet.shivhare@vidyamandir.com"]
    role: [ "center_coordinator/vmc/pp/2" ]
  sujeet_person = Find "person/3"

  (Collection "person").insert
    doc_id: "person/4"

    doc_type: person.doc_id
    id: "4"

    doc_name: "Ajay Pathak"
    timestamp: (moment.utc [2012, 4, 26, 19, 12, 0, 0]).valueOf()
    phone: ["+91-8588801213"]
    email: ["pathak@vidyamandir.com"]
    role: [ "center_coordinator/vmc/pp/1" ]
  pathak_person = Find "person/4"

  (Collection "person").insert
    doc_id: "person/5"

    doc_type: person.doc_id
    id: "5"

    doc_name: "Deepak"
    timestamp: (moment.utc [2012, 4, 26, 19, 15, 0, 0]).valueOf()
    phone: ["+91-9717556926"]
    role: [ "center_staff/vmc/pp/1" ]
  deepak_person = Find "person/5"

  (Collection "person").insert
    doc_id: "person/6"

    doc_type: person.doc_id
    id: "6"

    doc_name: "Divik Jain"
    timestamp: (moment.utc [2012, 4, 26, 19, 22, 0, 125]).valueOf()
    phone: ["+91-9582999301"]
    email: ["divik.jain@gmail.com"]
    role: [ "teacher/vmc/2" ]
  divik_person = Find "person/6"

  (Collection "person").insert
    doc_id: "person/7"

    doc_type: person.doc_id
    id: "7"

    doc_name: "Anirudh Mendiratta"
    timestamp: (moment.utc [2012, 4, 26, 19, 22, 10, 125]).valueOf()
    phone: ["+91-9818394025"]
    email: ["anirudh@gmail.com"]
    role: [ "teacher/vmc/1" ]
  anirudh_person = Find "person/7"

  (Collection "person").insert
    doc_id: "person/8"

    doc_type: person.doc_id
    id: "8"

    doc_name: "Anup Bishnoi"
    timestamp: (moment.utc [2012, 4, 26, 19, 20, 0, 125]).valueOf()
    dob: (moment.utc [1986, 7, 21]).valueOf()
    phone: ["+91-9868768262", "+91-11-27517704"]
    email: [ "pixelsallover@gmail.com"
             "anup.bishnoi@vidyamandir.com" ]
    address: "39/H-33, Sector-3, Rohini, Delhi - 110085"
    role: [ "student/vmc/12p05zz1234" ]
  anup_person = Find "person/8"

  (Collection "person").insert
    doc_id: "person/9"

    doc_type: person.doc_id
    id: "9"

    doc_name: "Madan Lal"
    timestamp: (moment.utc [2012, 6, 26, 18, 13, 47, 0]).valueOf()
    phone: [ "+91-8588801201"
             "+91-9871254479" ]
    email: [ "madan@vidyamandir.com" ]
    role: [ "center_manager/vmc/pp/1" ]
  madan_person = Find "person/9"

  (Collection "center_head").insert
    doc_id: "center_head/vmc/pp/1"

    doc_type: center_head.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "1"

    doc_name: "Sandeep Bhaiya"
    person: sandeep_person.doc_id
    active: true
  sandeep_head = Find "center_head/vmc/pp/1"

  (Collection "center_manager").insert
    doc_id: "center_manager/vmc/pp/1"

    doc_type: center_manager.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "1"

    doc_name: "Madan Bhaiya"
    person: madan_person.doc_id
    active: true
    can_search_for: [ "student"
                      "study_class"
                      "teacher"  ]
    ui:
      search_for: "student"
      look_in:
        order:
          "student": [ "batch"
                       "group" ]
        selected: [ "batch/vmc/12p2005" ]
  madan_manager = Find "center_manager/vmc/pp/1"

  (Collection "vendor").insert
    doc_id: "vendor/vmc/1"

    doc_type: vendor.doc_id
    org: vmc.doc_id
    id: "1"

    doc_name: "Pradeep Singh"
    person: psingh_person.doc_id
    active: true
  psingh_vendor = Find "vendor/vmc/1"

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
  deepak_staff = Find "center_staff/vmc/pp/1"

  (Collection "center_staff_in_out").insert
    doc_id: "in_out/vmc/pp/1/1"

    doc_type: in_out.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_staff: deepak_staff.doc_id
    id: "1"

    in: (moment.utc [2012, 4, 26, 9, 30]).valueOf()
    out: (moment.utc [2012, 4, 26, 7, 30]).valueOf()
  in_out1 = Find "in_out/vmc/pp/1/1"

  (Collection "center_coordinator").insert
    doc_id: "center_coordinator/vmc/pp/1"

    doc_type: center_coordinator.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "1"

    person: pathak_person.doc_id
    active: true
  pathak_coordinator = Find "center_coordinator/vmc/pp/1"

  (Collection "center_coordinator").insert
    doc_id: "center_coordinator/vmc/pp/2"

    doc_type: center_coordinator.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "2"

    person: sujeet_person.doc_id
    active: true
  sujeet_coordinator = Find "center_coordinator/vmc/pp/2"

  (Collection "teacher").insert
    doc_id: "teacher/vmc/1"
    
    doc_type: teacher.doc_id
    org: vmc.doc_id
    id: "1"

    doc_name: "Anirudh Bhaiya"
    subject: [ physics.doc_id ]
    person: anirudh_person.doc_id
    active: true
  anirudh_teacher = Find "teacher/vmc/1"

  (Collection "teacher").insert
    doc_id: "teacher/vmc/2"
    
    doc_type: teacher.doc_id
    org: vmc.doc_id
    id: "2"

    doc_name: "Divik Bhaiya"
    subject: [ chemistry.doc_id ]
    person: divik_person.doc_id
    active: true
  divik_teacher = Find "teacher/vmc/2"

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
      time: (moment.utc [2004, 4, 4, 9]).valueOf()
      center: pp.doc_id # registration center
      slot: "1"
      discount: "20%"
    active: true
  anup_applicant = Find "applicant/vmc/12p2005/1/pp3010"

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
    on: (moment.utc [2004, 1, 20, 10, 45]).valueOf()
    by: sandeep_head.doc_id
    reason: "NTSE Scholar"
    proof: "attach proof"
  adm_discount = Find "applicant_discount/vmc/12p2005/1/pp3010/1"

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
    on: (moment.utc [2004, 1, 20, 11]).valueOf()
    proof: "scanned photo of receipt (and cheque)"
  adm_receipt = Find "applicant_receipt/vmc/12p2005/1/pp3010/1"

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
  anup_student = Find "student/vmc/12p05zz1234"

  (Collection "student_discount").insert
    doc_id: "student_discount/vmc/12p05zz1234/1"

    doc_type: student_discount.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10000
    on: (moment.utc [2004, 5, 10, 10]).valueOf()
    by: sandeep_head.doc_id
    reason: "just realised he's awesome. wakau!"
    proof: "attach proof of awesomeness"
  stud_discount = Find "student_discount/vmc/12p05zz1234/1"

  (Collection "student_receipt").insert
    doc_id: "student_receipt/vmc/12p05zz1234/1"

    doc_type: student_receipt.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 40000
    on: (moment.utc [2004, 4, 5, 11, 30]).valueOf()
    cheque:
      favorof: "Vidyamandir Classes"
      branch: "blah"
      deposited:
        by: deepak_staff.doc_id
        on: (moment.utc [2004, 4, 7, 10]).valueOf()
    proof: "attached scanned link"
  stud_receipt = Find "student_receipt/vmc/12p05zz1234/1"

  (Collection "accrual").insert
    doc_id: "accrual/vmc/12p05zz1234/1"

    doc_type: accrual.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10212
    on: (moment.utc [2004, 5, 1, 10, 30]).valueOf()
  accr1 = Find "accrual/vmc/12p05zz1234/1"

  (Collection "accrual").insert
    doc_id: "accrual/vmc/12p05zz1234/2"

    doc_type: accrual.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "2"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 13235
    on: (moment.utc [2004, 6, 1, 10, 30]).valueOf()
  accr2 = Find "accrual/vmc/12p05zz1234/2"

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
  refund1 = Find "refund/vmc/12p05zz1234"

  (Collection "question").insert
    doc_id: "question/vmc/[vmc/physics].[vmc/1]/350"

    doc_type: question.doc_id
    org: vmc.doc_id
    subject: physics.doc_id
    teacher: anirudh_teacher.doc_id
    id: "350"

    question: "question here"
    answer: "B"
    topic: f_and_m.doc_id # can be an array
    difficulty: "easy"
    public: true
  question1 = Find "question/vmc/[vmc/physics].[vmc/1]/350"

  (Collection "solution").insert
    doc_id: "solution/vmc/[vmc/physics].[vmc/1]/350/2"

    doc_type: solution.doc_id
    org: vmc.doc_id
    subject: physics.doc_id
    question: question.doc_id
    id: "2"

    teacher: anirudh_teacher.doc_id
    solution: "big fatass solution"
    # no public declaration, hence the solution is private
  solution1 = Find "solution/vmc/[vmc/physics].[vmc/1]/350/2"

  (Collection "question_paper").insert
    doc_id: "question_paper/vmc/1/359"

    doc_type: question_paper.doc_id
    org: vmc.doc_id
    teacher: anirudh_teacher.doc_id
    id: "359"

    questions: []
  q_paper = Find "question_paper/vmc/1/359"

  (Collection "admission_test").insert
    doc_id: "admission_test/vmc/12p2005/1"

    doc_type: admission_test.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "1"

    doc_name: "Vidyamandir XIIth Pass Admission Test for IITJEE - 2005"
    from: (moment.utc [2004, 1, 29, 15]).valueOf()
    to: (moment.utc [2004, 1, 29, 18]).valueOf()
    duration: "3 hours"
    sections: [] # marking scheme and total marks are part of sections
    instructions: []
    styling: {}
    question_paper: question_paper.doc_id
  adm_test = Find "admission_test/vmc/12p2005/1"

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

    from: (moment.utc [2004, 4, 20, 15, 30]).valueOf()
    to: (moment.utc [2004, 4, 20, 18, 30]).valueOf()
    teacher: anirudh_teacher.doc_id
    room: room.doc_id
    active: true
  class1 = Find "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1"

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

    from: (moment.utc [2004, 4, 21, 15, 30]).valueOf()
    to: (moment.utc [2004, 4, 21, 18, 30]).valueOf()
    teacher: anirudh_teacher.doc_id
    room: room.doc_id
    active: true
  class2 = Find "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/2].[vmc/physics/force_and_momentum]/1"

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
  absent1 = Find "absent/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1/1"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/print"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "print"
    active: true
  print = Find "duty_type/vmc/print"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/arrange"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "arrange"
    active: true
  arrange = Find "duty_type/vmc/arrange"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/distribute"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "distribute"
    active: true
  distribute = Find "duty_type/vmc/distribute"

  (Collection "center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/print]/1"

    doc_type: center_coordinator_duty.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: print.doc_id
    id: "1"

    doc_name: "Print Attendance List for XIIth Pass 1 (Room 3)"
    on: class1.from
    done: false
    active: true
  duty_print = Find "center_coordinator_duty/[vmc/pp/2].[vmc/print]/1"

  # one time duty
  (Collection "center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/arrange]/2"

    doc_type: center_coordinator_duty.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: arrange.doc_id
    id: "2"

    doc_name: "Arrange 23 copies of Physics Module 1 (2005)"
    on: class1.from
    study_class: class1.doc_id
    group: xiip1.doc_id
    room: class1.room
    vendor: psingh_vendor.doc_id
    done: false
    active: true
  duty_arrange = Find "center_coordinator_duty/[vmc/pp/2].[vmc/arrange]/2"

  (Collection "center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/distribute]/1"

    doc_type: center_coordinator_duty.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: distribute.doc_id
    id: "1"

    doc_name: "Distribute Physics Module 1 (2005) in XIIth Pass 1 on 20 May 2004, 3:30 PM"
    study_material: physics_module.doc_id
    group: xiip1.doc_id
    study_class: class1.doc_id
    on: class1.from
    done: false
    active: true
  duty_distribute = Find "center_coordinator_duty/[vmc/pp/2].[vmc/distribute]/1"
