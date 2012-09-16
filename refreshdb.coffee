cbgFrom100p = (obj) ->
  { batch, batch_100p, group_100p } = obj
  switch batch_100p
    when "Regular"
      center = "center/vmc/pitampura"
      group_name = group_100p
    when "ECC Punjabi Bagh"
      center = "center/vmc/pitampura"
      group_name = group_100p
    when "ECC Anand Vihar"
      center = "center/vmc/anand_vihar"
      group_name = group_100p
    when "VCC Ludhiana 12THP13 VMC"
      center = "center/vmc/ludhiana"
      group_name = "VCC"
    when "VCC Moradabad 12THP13 VMC"
      center = "center/vmc/moradabad"
      group_name = "VCC"
    when "VCC Dehradun 12THP13 VMC"
      center = "center/vmc/dehradun"
      group_name = "VCC"
    when "VCC Bhatinda 12THP13 VMC"
      center = "center/vmc/bhatinda"
      group_name = "VCC"
    else
      center = null
      group_name = null
  if group_name?
    doc_name = group_name
    group_doc = Find.one "group", { center, batch, doc_name }
    if not group_doc?
      group_id = "#{(Find.count "group", { center, batch }, true) + 1}"
      group = "group/[#{center}].[#{batch}]/#{group_id}"
      (Collection "group").insert
        doc_id: group
        doc_type: "group"
        org: "org/vmc"
        center: center
        batch: batch
        id: group_id
        doc_name: group_name
        active: true
  [ center, batch, group ]

refreshDb = ->
  Log "Refreshing Database:"
  Collection.reset.all()

  Log "> Meta"
  for type in Collection.list()
    (Collection "doc_type").insert
      doc_id: "doc_type/#{type}"
      doc_type: "doc_type"
      id: type

  Log "> Main"
  (Collection "org").insert
    doc_id: "org/vmc"
    doc_type: "org"
    id: "vmc"
    doc_name: "Vidyamandir Classes"

  all_centers = [
    "pitampura"
    "anand_vihar"
    "ludhiana"
    "moradabad"
    "bhatinda"
    "dehradun"
  ]
  for center in all_centers
    (Collection "center").insert
      doc_id: "center/vmc/#{center}"
      doc_type: "center"
      org: "org/vmc"
      id: center

  (Collection "batch").insert
    doc_id: "batch/vmc/12p2013"
    doc_type: "batch"
    org: "org/vmc"
    id: "12p2013"
    doc_name: "XIIth Pass 2013"
    duration: "1 year"

  (Collection "rank_range").insert
    doc_id: "rank_range/vmc/top_50"
    doc_type: "rank_range"
    org: "org/vmc"
    id: "top50"
    from: 1
    to: 50

  (Collection "rank_range").insert
    doc_id: "rank_range/vmc/top_100"
    doc_type: "rank_range"
    org: "org/vmc"
    id: "top100"
    from: 1
    to: 100

  sandeep_person_id = "#{(Find.count "person", true) + 1}"
  sandeep_person = "person/#{sandeep_person_id}"
  (Collection "person").insert
    doc_id: sandeep_person
    doc_type: "person"
    id: sandeep_person_id
    doc_name: "Sandeep Mehta"
    timestamp: (new Date).getTime()
    phone: [ "+91-9953001820" ]
    email: [ "sandeep@vidyamandir.com" ]
    role: [ "center_head/vmc/pitampura/1" ]

  sandeep_head_id = (Find.count "center_head", true) + 1
  (Collection "center_head").insert
    doc_id:         "center_head/vmc/pitampura/#{sandeep_head_id}"
    doc_type:       "center_head"
    org:            "org/vmc"
    center:         "center/vmc/pitampura"
    id:             "1"
    doc_name:       "Sandeep Bhaiya"
    person:         sandeep_person
    active:         true
    can_search_for:         [ "student"
                              "batch_test"
                              "teacher"           ]
    ui:
      search_for:           "student"
      look_in_order:
        "student":          [ "batch"
                              "group"           ]
        "batch_test":       [ "batch"
                              "batch_test_type" ]
      look_in_selected:
        "batch_test_marks": [ "marks_type/vmc/total" ]

  (Collection "marks_type").insert
    doc_id: "marks_type/vmc/total"
    doc_type: "marks_type"
    org: "org/vmc"
    id: "total"
    doc_name: "Total Marks"

  (Collection "batch_test_type").insert
    doc_id: "batch_test_type/vmc/test_series"
    doc_type: "batch_test_type"
    org: "org/vmc"
    id: "test_series"

  ts1 = "batch_test/[batch/vmc/12p2013].[batch_test_type/vmc/test_series]/1"
  (Collection "batch_test").insert
    doc_id: ts1
    doc_type: "batch_test"
    org: "org/vmc"
    batch: "batch/vmc/12p2013"
    batch_test_type: "batch_test_type/vmc/test_series"
    id: "1"
    doc_name: "XIIth Pass Test Series 1"
    papers: [
      {
        name: "Paper - 1"
        sections: []
        total: 210
        instructions: []
        styling: {}
        questions: []
      }
      {
        name: "Paper - 2"
        sections: []
        total: 210
        instructions: []
        styling: {}
        questions: []
      }
    ]

  Log "> Per student records"
  ts1_total_12p = d3.csv.parse db_data_strings[0].data
  for obj in ts1_total_12p
    for own k of obj
      obj[k] = Str.clean obj[k]
    obj["name"] = Str.titleize obj["name"].toLowerCase()

  for obj in ts1_total_12p
    student_doc = Find.one "student", org: "vmc", id: obj["rollno"]
    if not student_doc
      person_id = "#{(Find.count "person", true) + 1}"
      person = "person/#{person_id}"
      (Collection "person").insert
        doc_id: person
        doc_type: "person"
        id: "1"
        doc_name: obj["name"]
        timestamp: (new Date).getTime()

      obj.batch = "batch/vmc/12p2013"
      [ center, batch, group ] = cbgFrom100p obj
      continue if not (center and batch and group)
      id = obj["rollno"]
      student = "student/vmc/#{id}"
      (Collection "student").insert
        doc_id: student
        doc_type: "student"
        org: "org/vmc"
        id: id
        center: center
        batch: batch
        group: group
        person: person
      student_doc = Find student
      Update person
      , $set: role: [ student ]
    else
      { id, center, batch, group, person } = student_doc
      student = student_doc.doc_id
        
    (Collection "batch_test_marks").insert
      doc_id: "batch_test_marks/[#{ts1}].[marks_type/vmc/paper1]/#{id}"
      doc_type: "batch_test_marks"
      batch_test: ts1
      marks_type: "marks_type/vmc/paper1"
      id: id
      student: "student/vmc/#{id}"
      marks: +(obj["paper1"])
      center: center
      batch: batch
      group: group
      org: "org/vmc"

    (Collection "batch_test_marks").insert
      doc_id: "batch_test_marks/[#{ts1}].[marks_type/vmc/paper2]/#{id}"
      doc_type: "batch_test_marks"
      batch_test: ts1
      marks_type: "marks_type/vmc/paper2"
      id: id
      student: "student/vmc/#{id}"
      marks: +(obj["paper2"])
      center: center
      batch: batch
      group: group
      org: "org/vmc"

    (Collection "batch_test_marks").insert
      doc_id: "batch_test_marks/[#{ts1}].[marks_type/vmc/total]/#{id}"
      doc_type: "batch_test_marks"
      batch_test: ts1
      marks_type: "marks_type/vmc/total"
      id: id
      student: "student/vmc/#{id}"
      marks: (+obj["paper1"]) + (+obj["paper2"])
      center: center
      batch: batch
      group: group
      org: "org/vmc"

  Session "user_name", "Sandeep Mehta"
  Session "user_details", {}

dummyDb = ->
  Log "Resetting Collections:"
  Collection.reset.all()

  Log "> Meta"
  for type in Collection.list()
    (Collection "doc_type").insert
      doc_id: "doc_type/#{type}"
      doc_type: "doc_type"
      id: type

  Log "> Main"
  (Collection "org").insert
    doc_id: "org/vmc"

    doc_type: "org"
    id: "vmc"

    doc_name: "Vidyamandir Classes"
  vmc = Find "org/vmc"

  (Collection "center").insert
    doc_id: "center/vmc/pitampura"

    doc_type: "center"
    org: vmc.doc_id
    id: "pitampura"

    address: "3rd Floor, Aggarwal Corporate Heights, NSP"
  pitampura = Find "center/vmc/pitampura"

  (Collection "batch").insert
    doc_id: "batch/vmc/12p2005"

    doc_type: "batch"
    org: vmc.doc_id
    id: "12p2005"

    doc_name: "XIIth Pass 2005"
    duration: "1 year"
    fee: 125000
    accrual_per_month: 125000/10 # accrual stops end of march, classes almost over
  xiip05 = Find "batch/vmc/12p2005"

  (Collection "due_installment").insert
    doc_id: "due_installment/vmc/12p2005/1"

    doc_type: "due_installment"
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "1"

    amount: 110000
    on: (moment.utc [2004, 11, 31, 18]).valueOf()
  due1 = Find "due_installment/vmc/12p2005/1"

  (Collection "due_installment").insert
    doc_id: "due_installment/vmc/12p2005/2"

    doc_type: "due_installment"
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "2"

    amount: 15000
    on: (moment.utc [2005, 2, 31, 18]).valueOf()
  due2 = Find "due_installment/vmc/12p2005/2"

  (Collection "group").insert
    doc_id: "group/[center/vmc/pitampura].[batch/vmc/12p2005]/1"

    doc_type: "group"
    org: vmc.doc_id
    center: pitampura.doc_id
    batch: xiip05.doc_id
    id: "1"
    
    doc_name: "XIIth Pass 1"
    active: true
  xiip1 = Find "group/[center/vmc/pitampura].[batch/vmc/12p2005]/1"

  (Collection "group").insert
    doc_id: "group/[center/vmc/pitampura].[batch/vmc/12p2005]/2"

    doc_type: "group"
    org: vmc.doc_id
    center: pitampura.doc_id
    batch: xiip05.doc_id
    id: "2"
    
    doc_name: "XIIth Pass 2"
    active: true
  xiip2 = Find "group/[center/vmc/pitampura].[batch/vmc/12p2005]/2"

  (Collection "room").insert
    doc_id: "room/vmc/pitampura/3"
    
    doc_type: "room"
    org: vmc.doc_id
    center: pitampura.doc_id
    id: "3"

    doc_name: "Room 3"
    capacity: 45
    floor: "3rd Floor"
    active: true
  room_3 = Find "room/vmc/pitampura/3"

  (Collection "subject").insert
    doc_id: "subject/vmc/physics"

    doc_type: "subject"
    org: vmc.doc_id
    id: "physics"

    doc_name: "Physics"
    public: true
  physics = Find "subject/vmc/physics"

  (Collection "subject").insert
    doc_id: "subject/vmc/chemistry"

    doc_type: "subject"
    org: vmc.doc_id
    id: "chemistry"

    doc_name: "Chemistry"
    public: true
  chemistry = Find "subject/vmc/chemistry"

  (Collection "topic").insert
    doc_id: "topic/vmc/physics/force_and_momentum"

    doc_type: "topic"
    org: vmc.doc_id
    subject: physics.doc_id
    id: "force_and_momentum"

    doc_name: "Force and Momentum"
    level: "advanced" # could make a TopicLevel object
    public: true
  f_and_m = Find "topic/vmc/physics/force_and_momentum"

  (Collection "study_material_type").insert
    doc_id: "study_material_type/vmc/module"

    doc_type: "study_material_type"
    org: vmc.doc_id
    id: "module"

    doc_name: "Module"
  module = Find "study_material_type/vmc/module"

  (Collection "study_material").insert
    doc_id: "study_material/[batch/vmc/12p2005].[subject/vmc/physics].[study_material_type/vmc/module]/1"

    doc_type: "study_material"
    org: vmc.doc_id
    batch: xiip05.doc_id
    subject: physics.doc_id
    study_material_type: module.doc_id
    id: "1"

    doc_name: "Physics - Module 1"
    contents: [ f_and_m.doc_id ]
    scanned: []
  physics_module = Find "study_material/[batch/vmc/12p2005].[subject/vmc/physics].[study_material_type/vmc/module]/1"

  (Collection "rank_range").insert
    doc_id: "rank_range/vmc/top50"

    doc_type: "rank_range"
    org: vmc.doc_id
    id: "top50"

    doc_name: "Top 50"
    from: 1
    to: 50
  top100 = Find "rank_range/vmc/top50"

  (Collection "rank_range").insert
    doc_id: "rank_range/vmc/top100"

    doc_type: "rank_range"
    org: vmc.doc_id
    id: "top100"
    from: 1
    to: 100

    doc_name: "Top 100"
  top100 = Find "rank_range/vmc/top100"

  (Collection "batch_test_type").insert
    doc_id: "batch_test_type/vmc/test_series"
    doc_type: "batch_test_type"
    org: vmc.doc_id
    id: "test_series"

    doc_name: "Test Series"
  ts = Find "batch_test_type/vmc/test_series"

  Log "> Personnel"
  (Collection "person").insert
    doc_id: "person/1"

    doc_type: "person"
    id: "1"

    doc_name: "Sandeep Mehta"
    timestamp: (moment.utc [2012, 4, 26, 19, 0, 0, 0]).valueOf()
    phone: [ "+91-9953001820" ]
    email: [ "sandeep@vidyamandir.com" ]
    role: [ "center_head/vmc/pitampura/1" ]
  sandeep_person = Find "person/1"

  (Collection "person").insert
    doc_id: "person/2"

    doc_type: "person"
    id: "2"

    doc_name: "Pradeep Singh"
    timestamp: (moment.utc [2012, 4, 26, 19, 5, 0, 0]).valueOf()
    phone: ["+91-8588801202"]
    role: [ "vendor/vmc/1" ]
  psingh_person = Find "person/2"

  (Collection "person").insert
    doc_id: "person/3"

    doc_type: "person"
    id: "3"

    doc_name: "Sujeet Shivhare"
    timestamp: (moment.utc [2012, 4, 26, 19, 10, 0, 0]).valueOf()
    phone: ["+91-8588801214", "+91-9013926056"]
    email: ["sujeet.shivhare@vidyamandir.com"]
    role: [ "center_coordinator/vmc/pitampura/2" ]
  sujeet_person = Find "person/3"

  (Collection "person").insert
    doc_id: "person/4"

    doc_type: "person"
    id: "4"

    doc_name: "Ajay Pathak"
    timestamp: (moment.utc [2012, 4, 26, 19, 12, 0, 0]).valueOf()
    phone: ["+91-8588801213"]
    email: ["pathak@vidyamandir.com"]
    role: [ "center_coordinator/vmc/pitampura/1" ]
  pathak_person = Find "person/4"

  (Collection "person").insert
    doc_id: "person/5"

    doc_type: "person"
    id: "5"

    doc_name: "Deepak"
    timestamp: (moment.utc [2012, 4, 26, 19, 15, 0, 0]).valueOf()
    phone: ["+91-9717556926"]
    role: [ "center_staff/vmc/pitampura/1" ]
  deepak_person = Find "person/5"

  (Collection "person").insert
    doc_id: "person/6"

    doc_type: "person"
    id: "6"

    doc_name: "Divik Jain"
    timestamp: (moment.utc [2012, 4, 26, 19, 22, 0, 125]).valueOf()
    phone: ["+91-9582999301"]
    email: ["divik.jain@gmail.com"]
    role: [ "teacher/vmc/2" ]
  divik_person = Find "person/6"

  (Collection "person").insert
    doc_id: "person/7"

    doc_type: "person"
    id: "7"

    doc_name: "Anirudh Mendiratta"
    timestamp: (moment.utc [2012, 4, 26, 19, 22, 10, 125]).valueOf()
    phone: ["+91-9818394025"]
    email: ["anirudh@gmail.com"]
    role: [ "teacher/vmc/1" ]
  anirudh_person = Find "person/7"

  (Collection "person").insert
    doc_id: "person/8"

    doc_type: "person"
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

    doc_type: "person"
    id: "9"

    doc_name: "Madan Lal"
    timestamp: (moment.utc [2012, 6, 26, 18, 13, 47, 0]).valueOf()
    phone: [ "+91-8588801201"
             "+91-9871254479" ]
    email: [ "madan@vidyamandir.com" ]
    role: [ "center_manager/vmc/pitampura/1" ]
  madan_person = Find "person/9"

  (Collection "center_head").insert
    doc_id: "center_head/vmc/pitampura/1"

    doc_type: "center_head"
    org: vmc.doc_id
    center: pitampura.doc_id
    id: "1"

    doc_name: "Sandeep Bhaiya"
    person: sandeep_person.doc_id
    active: true
  sandeep_head = Find "center_head/vmc/pitampura/1"

  (Collection "center_manager").insert
    doc_id: "center_manager/vmc/pitampura/1"

    doc_type: "center_manager"
    org: vmc.doc_id
    center: pitampura.doc_id
    id: "1"

    doc_name: "Madan Bhaiya"
    person: madan_person.doc_id
    active: true
    menu: [ "search"
            "fee_collection"
            "courier" ]
    can_search_for: [ "student"
                      "study_class"  ]
    ui:
      search_for: "student"
      look_in_order:
        "student": [ "batch"
                     "group" ]
        "study_class": [ "group" ]
      look_in_selected:
        "student": [ "batch/vmc/12p2005" ]
  madan_manager = Find "center_manager/vmc/pitampura/1"

  (Collection "vendor").insert
    doc_id: "vendor/vmc/1"

    doc_type: "vendor"
    org: vmc.doc_id
    id: "1"

    doc_name: "Pradeep Singh"
    person: psingh_person.doc_id
    active: true
  psingh_vendor = Find "vendor/vmc/1"

  (Collection "center_staff").insert
    doc_id: "center_staff/vmc/pitampura/1"

    doc_type: "center_staff"
    org: vmc.doc_id
    center: pitampura.doc_id
    id: "1"

    doc_name: "Deepak"
    intime: "9 AM"
    outtime: "8 PM"
    person: deepak_person.doc_id
    active: true
  deepak_staff = Find "center_staff/vmc/pitampura/1"

  (Collection "center_staff_in_out").insert
    doc_id: "center_staff_in_out/vmc/pitampura/1/1"

    doc_type: "center_staff_in_out"
    org: vmc.doc_id
    center: pitampura.doc_id
    center_staff: deepak_staff.doc_id
    id: "1"

    in: (moment.utc [2012, 4, 26, 9, 30]).valueOf()
    out: (moment.utc [2012, 4, 26, 7, 30]).valueOf()
  in_out1 = Find "center_staff_in_out/vmc/pitampura/1/1"

  (Collection "center_coordinator").insert
    doc_id: "center_coordinator/vmc/pitampura/1"

    doc_type: "center_coordinator"
    org: vmc.doc_id
    center: pitampura.doc_id
    id: "1"

    person: pathak_person.doc_id
    active: true
  pathak_coordinator = Find "center_coordinator/vmc/pitampura/1"

  (Collection "center_coordinator").insert
    doc_id: "center_coordinator/vmc/pitampura/2"

    doc_type: "center_coordinator"
    org: vmc.doc_id
    center: pitampura.doc_id
    id: "2"

    person: sujeet_person.doc_id
    active: true
  sujeet_coordinator = Find "center_coordinator/vmc/pitampura/2"

  (Collection "teacher").insert
    doc_id: "teacher/vmc/1"
    
    doc_type: "teacher"
    org: vmc.doc_id
    id: "1"

    doc_name: "Anirudh Bhaiya"
    subject: [ physics.doc_id ]
    person: anirudh_person.doc_id
    active: true
  anirudh_teacher = Find "teacher/vmc/1"

  (Collection "teacher").insert
    doc_id: "teacher/vmc/2"
    
    doc_type: "teacher"
    org: vmc.doc_id
    id: "2"

    doc_name: "Divik Bhaiya"
    subject: [ chemistry.doc_id ]
    person: divik_person.doc_id
    active: true
  divik_teacher = Find "teacher/vmc/2"

  (Collection "applicant").insert
    doc_id: "applicant/vmc/12p2005/1/pp3010"

    doc_type: "applicant"
    org: vmc.doc_id
    batch: xiip05.doc_id
    # because admission_test hasn't been initialised yet
    admission_test: "admission_test/vmc/12p2005/1"
    id: "pp3010"

    center: pitampura.doc_id # enrollment center
    person: anup_person.doc_id
    test:
      admit_card: "attach pdf link"
      center: pitampura.doc_id
    registration:
      time: (moment.utc [2004, 4, 4, 9]).valueOf()
      center: pitampura.doc_id # registration center
      slot: "1"
      discount: "20%"
  anup_applicant = Find "applicant/vmc/12p2005/1/pp3010"

  (Collection "applicant_discount").insert
    doc_id: "applicant_discount/vmc/12p2005/1/pp3010/1"

    doc_type: "applicant_discount"
    org: vmc.doc_id
    batch: xiip05.doc_id
    admission_test: "admission_test/vmc/12p2005/1"
    applicant: anup_applicant.doc_id
    id: "1"

    center: pitampura.doc_id
    amount: 200
    on: (moment.utc [2004, 1, 20, 10, 45]).valueOf()
    by: sandeep_head.doc_id
    reason: "NTSE Scholar"
    proof: "attach proof"
  adm_discount = Find "applicant_discount/vmc/12p2005/1/pp3010/1"

  (Collection "applicant_receipt").insert
    doc_id: "applicant_receipt/vmc/12p2005/1/pp3010/1"

    doc_type: "applicant_receipt"
    org: vmc.doc_id
    batch: xiip05.doc_id
    admission_test: "admission_test/vmc/12p2005/1"
    applicant: anup_applicant.doc_id
    id: "1"

    center: pitampura.doc_id
    amount: 500
    on: (moment.utc [2004, 1, 20, 11]).valueOf()
    proof: "scanned photo of receipt (and cheque)"
  adm_receipt = Find "applicant_receipt/vmc/12p2005/1/pp3010/1"

  (Collection "student").insert
    doc_id: "student/vmc/12p05zz1234"

    doc_type: "student"
    org: vmc.doc_id
    id: "12p05zz1234"

    center: pitampura.doc_id # allotted center
    batch: xiip05.doc_id
    group: xiip1.doc_id
    applicant: anup_applicant.doc_id
    person: anup_person.doc_id
  anup_student = Find "student/vmc/12p05zz1234"

  (Collection "student_discount").insert
    doc_id: "student_discount/vmc/12p05zz1234/1"

    doc_type: "student_discount"
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pitampura.doc_id
    batch: xiip05.doc_id
    amount: 10000
    on: (moment.utc [2004, 5, 10, 10]).valueOf()
    by: sandeep_head.doc_id
    reason: "just realised he's awesome. wakau!"
    proof: "attach proof of awesomeness"
  stud_discount = Find "student_discount/vmc/12p05zz1234/1"

  (Collection "student_receipt").insert
    doc_id: "student_receipt/vmc/12p05zz1234/1"

    doc_type: "student_receipt"
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pitampura.doc_id
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

    doc_type: "accrual"
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pitampura.doc_id
    batch: xiip05.doc_id
    amount: 10212
    on: (moment.utc [2004, 5, 1, 10, 30]).valueOf()
  accr1 = Find "accrual/vmc/12p05zz1234/1"

  (Collection "accrual").insert
    doc_id: "accrual/vmc/12p05zz1234/2"

    doc_type: "accrual"
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "2"

    center: pitampura.doc_id
    batch: xiip05.doc_id
    amount: 13235
    on: (moment.utc [2004, 6, 1, 10, 30]).valueOf()
  accr2 = Find "accrual/vmc/12p05zz1234/2"

  (Collection "refund").insert
    doc_id: "refund/vmc/12p05zz1234/1"

    doc_type: "refund"
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    on: (new Date 2004, 6, 25, 17).getTime()
    by: sandeep_head.doc_id
    amount: 8023
    reason: "Don't like his face"
    proof: "photograph?"
  refund1 = Find "refund/vmc/12p05zz1234"

  Log "> Content"
  (Collection "question").insert
    doc_id: "question/[subject/vmc/physics].[teacher/vmc/1]/350"

    doc_type: "question"
    org: vmc.doc_id
    subject: physics.doc_id
    teacher: anirudh_teacher.doc_id
    id: "350"

    question: "question here"
    answer: "B"
    topic: f_and_m.doc_id # can be an array
    difficulty: "easy"
    public: true
  question1 = Find "question/[subject/vmc/physics].[teacher/vmc/1]/350"

  (Collection "solution").insert
    doc_id: "solution/[subject/vmc/physics].[teacher/vmc/1]/350/2"

    doc_type: "solution"
    org: vmc.doc_id
    subject: physics.doc_id
    question: question1.doc_id
    id: "2"

    teacher: anirudh_teacher.doc_id
    solution: "big fatass solution"
    # no public declaration, hence the solution is private
  solution1 = Find "solution/[subject/vmc/physics].[teacher/vmc/1]/350/2"

  (Collection "admission_test").insert
    doc_id: "admission_test/vmc/12p2005/1"

    doc_type: "admission_test"
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
    questions: [ question1.doc_id ]
  adm_test = Find "admission_test/vmc/12p2005/1"

  (Collection "admission_test_attempt").insert
    doc_id: "admission_test_attempt/vmc/12p2005/1/12p05zz1234"

    org: vmc.doc_id
    admission_test: adm_test.doc_id
    id: "12p05zz1234"

    answers: [ "A" ]
  answer_sheet1 = Find "admission_test_attempt/vmc/12p2005/1/12p05zz1234"

  Log "> Marks"
  (Collection "marks_type").insert
    doc_id: "marks_type/vmc/total"

    doc_type: "marks_type"
    org: vmc.doc_id
    id: "total"

    doc_name: "Total Marks"
  marks_total = Find "marks_type/vmc/total"

  (Collection "marks_type").insert
    doc_id: "marks_type/vmc/physics"

    doc_type: "marks_type"
    org: vmc.doc_id
    id: "physics"

    doc_name: "Marks in Physics"
  marks_physics = Find "marks_type/vmc/physics"

  (Collection "marks_type").insert
    doc_id: "marks_type/vmc/tough_questions"

    doc_type: "marks_type"
    org: vmc.doc_id
    id: "tough_questions"

    doc_name: "Marks in Tough Questions"
  marks_tough = Find "marks_type/vmc/tough_questions"

  (Collection "admission_test_marks").insert
    doc_id: "admission_test_marks/[admission_test/vmc/12p2005/1].[marks_type/vmc/total]/12p05zz1234"

    doc_type: "admission_test_marks"
    admission_test: adm_test.doc_id
    marks_type: marks_total.doc_id
    id: "12p05zz1234"

    marks: 180
    org: vmc.doc_id
  adm_test_marks = Find "admission_test_marks/[admission_test/vmc/12p2005/1].[marks_type/vmc/total]/12p05zz1234"

  Log "> Classes"
  (Collection "study_class").insert
    doc_id: "study_class/[group/[center/vmc/pitampura].[batch/vmc/12p2005]/1].[topic/vmc/physics/force_and_momentum]/1"

    doc_type: "study_class"
    org: vmc.doc_id
    center: pitampura.doc_id
    batch: xiip05.doc_id
    group: xiip1.doc_id
    topic: f_and_m.doc_id
    id: "1" # class no. for the same topic

    subject: physics.doc_id
    from: (moment.utc [2004, 4, 20, 15, 30]).valueOf()
    to: (moment.utc [2004, 4, 20, 18, 30]).valueOf()
    teacher: anirudh_teacher.doc_id
    room: room_3.doc_id
  class1 = Find "study_class/[group/[center/vmc/pitampura].[batch/vmc/12p2005]/1].[topic/vmc/physics/force_and_momentum]/1"

  (Collection "study_class").insert
    doc_id: "study_class/[group/[center/vmc/pitampura].[batch/vmc/12p2005]/2].[topic/vmc/physics/force_and_momentum]/1"

    doc_type: "study_class"
    org: vmc.doc_id
    center: pitampura.doc_id
    batch: xiip05.doc_id
    group: xiip2.doc_id
    topic: f_and_m.doc_id
    id: "1" # class no. for the same topic (for this group)

    subject: physics.doc_id
    from: (moment.utc [2004, 4, 21, 15, 30]).valueOf()
    to: (moment.utc [2004, 4, 21, 18, 30]).valueOf()
    teacher: anirudh_teacher.doc_id
    room: room_3.doc_id
  class2 = Find "study_class/[group/[center/vmc/pitampura].[batch/vmc/12p2005]/2].[topic/vmc/physics/force_and_momentum]/1"

  (Collection "absent").insert
    doc_id: "absent/[group/[center/vmc/pitampura].[batch/vmc/12p2005]/1].[topic/vmc/physics/force_and_momentum]/1/1"

    doc_type: "absent"
    org: vmc.doc_id
    center: pitampura.doc_id
    batch: xiip05.doc_id
    group: xiip1.doc_id
    topic: f_and_m.doc_id
    study_class: class1.doc_id
    id: "1"
    
    subject: physics.doc_id
    student: anup_student.doc_id
    reason: "class kyu ni aaya"
    rescheduled: class2.doc_id
  absent1 = Find "absent/[group/[center/vmc/pitampura].[batch/vmc/12p2005]/1].[topic/vmc/physics/force_and_momentum]/1/1"

  Log "> Duties"
  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/print"

    doc_type: "duty_type"
    org: vmc.doc_id
    id: "print"
  print = Find "duty_type/vmc/print"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/arrange"

    doc_type: "duty_type"
    org: vmc.doc_id
    id: "arrange"
  arrange = Find "duty_type/vmc/arrange"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/distribute"

    doc_type: "duty_type"
    org: vmc.doc_id
    id: "distribute"
  distribute = Find "duty_type/vmc/distribute"

  (Collection "center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[center_coordinator/vmc/pitampura/2].[duty_type/vmc/print]/1"

    doc_type: "center_coordinator_duty"
    org: vmc.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: print.doc_id
    id: "1"

    doc_name: "Print Attendance List for XIIth Pass 1 (Room 3)"
    center: pitampura.doc_id
    on: class1.from
    done: false
  duty_print = Find "center_coordinator_duty/[center_coordinator/vmc/pitampura/2].[duty_type/vmc/print]/1"

  # one time duty
  (Collection "center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[center_coordinator/vmc/pitampura/2].[duty_type/vmc/arrange]/2"

    doc_type: "center_coordinator_duty"
    org: vmc.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: arrange.doc_id
    id: "2"

    doc_name: "Arrange 23 copies of Physics Module 1 (2005)"
    center: pitampura.doc_id
    on: class1.from
    study_class: class1.doc_id
    group: xiip1.doc_id
    room: class1.room
    vendor: psingh_vendor.doc_id
    done: false
  duty_arrange = Find "center_coordinator_duty/[center_coordinator/vmc/pitampura/2].[duty_type/vmc/arrange]/2"

  (Collection "center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[center_coordinator/vmc/pitampura/2].[duty_type/vmc/distribute]/1"

    doc_type: "center_coordinator_duty"
    org: vmc.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: distribute.doc_id
    id: "1"

    doc_name: "Distribute Physics Module 1 (2005) in XIIth Pass 1 on 20 May 2004, 3:30 PM"
    center: pitampura.doc_id
    study_material: physics_module.doc_id
    group: xiip1.doc_id
    study_class: class1.doc_id
    on: class1.from
    done: false
  duty_distribute = Find "center_coordinator_duty/[center_coordinator/vmc/pitampura/2].[duty_type/vmc/distribute]/1"
  Log "Collections reset."


# DB
db_data_strings = [
  {
    type: "ts-total-12p"
    data: """
name,rollno,batch_100p,group_100p,paper1,paper2,total,rank
SNIGDHA BHANDARI,10p12a0154,Regular,Reg 2,175,172,347.0,1
SAUHARD GUPTA,10p12a0063,Regular,Reg 4,160,163,323.0,2
Prateek Jain,10p12ed0029,ECC Punjabi Bagh,ECC 18,169,145,314.0,3
DEEPAK SINGH,10p12ed0017,ECC Punjabi Bagh,ECC 12,175,124,299.0,4
SRISHTI GUPTA,10p12ee0149,ECC Punjabi Bagh,ECC 18,164,132,296.0,5
VARUN BATRA,10p12a0026,Regular,Reg 2,151,,287.0,6
Sagar Rastogi,10p12ee0075,ECC Anand Vihar,AV-V,151,133,284.0,7
Abhishek Aggarwal,12thp13bu0001,VCC Ludhiana 12THP13 VMC,VCC Ludhiana 12THP13 VMC,154,136,275.0,8
Shubham Rathi,10p12ed0103,ECC Punjabi Bagh,ECC 17,137,114,251.0,9
JAI BASSI,10p12a0221,Regular,Reg 2,122,113,235.0,10
ANMOL GAHLAWAT,10p12ed0288,ECC Punjabi Bagh,ECC 12,124,98,222.0,11
SUYASH YADAV,10p12ed0126,ECC Punjabi Bagh,ECC 13,112,103,215.0,12
ANSHUMAN MISHRA,10p12a0244,Regular,Reg 3,117,96,213.0,13
saurav  kaura,10p13za0040,All India test Series for 2013 Offline 1 year,All India test Series 1 year offline_new,98,84,182.0,14
SHUBHAM SHARMA,12thp13cp0007,VCC Moradabad 12THP13 VMC,VCC Moradabad 12THP13 VMC,93,89,182.0,15
SUMIT DAHIYA,10p12ed0114,ECC Punjabi Bagh,ECC O,76,94,170.0,16
Nishant Shreshth,11p13ls0001,Target X VCC Avanti Dehradun 11P13 VMC,Target X VCC Avanti Dehradun 11P13 VMC,100,67,167.0,17
AKSHIT GOEL,12thp13cp0001,VCC Moradabad 12THP13 VMC,VCC Moradabad 12THP13 VMC,79,76,155.0,18
Nitin Agarwal,12thp13by0006,VCC Dehradun 12THP13 VMC,VCC Dehradun 12THP13  MC,78,58,136.0,19
Maheep Kathuria,12thp13mw0001,VCC  Bhatinda 12THP13 VMC,VCC  Bhatinda 12THP13 VMC,76,45,121.0,20
ADARSH GUPTA,10p12a0102,Regular,Reg 4,111,N.A,111.0,21
Vinayak Mehta,10p12ee0247,ECC Punjabi Bagh,ECC 16,62,45,107.0,22
ISHA CHOUDHARY,12thp13cp0005,VCC Moradabad 12THP13 VMC,VCC Moradabad 12THP13 VMC,38,59,97.0,23
Tushar Bajaj,12thp13cp0006,VCC Moradabad 12THP13 VMC,VCC Moradabad 12THP13 VMC,62,33,95.0,24
AESHWARYA MUDGIL,12thp13cp0002,VCC Moradabad 12THP13 VMC,VCC Moradabad 12THP13 VMC,43,47,90.0,25
Sudhanshu Dube,12thp13by0001,VCC Dehradun 12THP13 VMC,VCC Dehradun 12THP13  MC,29,58,87.0,26
SHUBHAM RASTOGI,12thp13cp0004,VCC Moradabad 12THP13 VMC,VCC Moradabad 12THP13 VMC,40,41,81.0,27
Gaurav Bartwal,12thp13by0005,VCC Dehradun 12THP13 VMC,VCC Dehradun 12THP13  MC,51,24,75.0,28
KUNAL BATRA,10p12ed0199,ECC Punjabi Bagh,ECC 14,43,31,74.0,29
rahul mittal,10p13za0041,All India test Series for 2013 Offline 1 year,All India test Series 1 year offline_new,36,38,74.0,30
Aditya Chopra,12thp13by0002,VCC Dehradun 12THP13 VMC,VCC Dehradun 12THP13  MC,35,36,71.0,31
akshat jain,12thp13by0003,VCC Dehradun 12THP13 VMC,VCC Dehradun 12THP13  MC,21,43,64.0,32
Aditya  Bisht,12thp13by0008,VCC Dehradun 12THP13 VMC,VCC Dehradun 12THP13  MC,27,21,48.0,33
    """
  }
  {
    type: "ts-total-10p"
    data: """
    """
  }
]


rank = (id) ->
  all = Find "batch_test_marks", marks_type: "marks_type/vmc/total"
  sorted = (_.sortBy all, "marks").reverse()
  rankwise = _.pluck sorted, "id"
  (rankwise.indexOf id) + 1
