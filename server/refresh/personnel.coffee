refreshPersonnel = ->
  App.collection(name).remove({}) for name in [
    "person"
    "center_head"
    "vendor"
    "center_staff"
    "center_staff_in_out"
    "center_coordinator"
    "teacher"
    "applicant"
    "applicant_discount"
    "applicant_receipt"
    "student"
    "student_discount"
    "student_receipt"
    "accrual"
    "refund"
  ]

  person = App.find.one "doc_type", doc_id: "person"
  center_head = App.find.one "doc_type", doc_id: "center_head"
  vendor = App.find.one "doc_type", doc_id: "vendor"
  center_staff = App.find.one "doc_type", doc_id: "center_staff"
  center_coordinator = App.find.one "doc_type", doc_id: "center_coordinator"
  teacher = App.find.one "doc_type", doc_id: "teacher"
  in_out = App.find.one "doc_type", doc_id: "in_out"
  applicant = App.find.one "doc_type", doc_id: "applicant"
  applicant_discount = App.find.one "doc_type", doc_id: "applicant_discount"
  applicant_receipt = App.find.one "doc_type", doc_id: "applicant_receipt"
  student = App.find.one "doc_type", doc_id: "student"
  student_discount = App.find.one "doc_type", doc_id: "student_discount"
  student_receipt = App.find.one "doc_type", doc_id: "student_receipt"
  accrual = App.find.one "doc_type", doc_id: "accrual"
  refund = App.find.one "doc_type", doc_id: "refund"
  vmc = App.find.one "org", doc_id: "org/vmc"
  pp = App.find.one "center", doc_id: "center/vmc/pp"
  xiip05 = App.find.one "batch", doc_id: "batch/vmc/12p2005"
  xiip1 = App.find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"
  physics = App.find.one "subject", doc_id: "subject/vmc/physics"

  App.collection("person").insert
    doc_id: "person/1"

    doc_type: person.doc_id
    id: "1"

    doc_name: "Sandeep Mehta"
    timestamp: new Date 2012, 4, 26, 19, 0, 0, 0
    phone: ["+91-9953001820"]
    email: ["sandeep@vidyamandir.com"]
  sandeep_person = App.find.one "person",
    doc_id: "person/1"

  App.collection("person").insert
    doc_id: "person/2"

    doc_type: person.doc_id
    id: "2"

    doc_name: "Pradeep Singh"
    timestamp: new Date 2012, 4, 26, 19, 5, 0, 0
    phone: ["+91-8588801202"]
  psingh_person = App.find.one "person",
    doc_id: "person/2"

  App.collection("person").insert
    doc_id: "person/3"

    doc_type: person.doc_id
    id: "3"

    doc_name: "Sujeet Shivhare"
    timestamp: new Date 2012, 4, 26, 19, 10, 0, 0
    phone: ["+91-8588801214", "+91-9013926056"]
    email: ["sujeet.shivhare@vidyamandir.com"]
  sujeet_person = App.find.one "person",
    doc_id: "person/3"

  App.collection("person").insert
    doc_id: "person/4"

    doc_type: person.doc_id
    id: "4"

    doc_name: "Ajay Pathak"
    timestamp: new Date 2012, 4, 26, 19, 12, 0, 0
    phone: ["+91-8588801213"]
    email: ["pathak@vidyamandir.com"]
  pathak_person = App.find.one "person",
    doc_id: "person/4"

  App.collection("person").insert
    doc_id: "person/5"

    doc_type: person.doc_id
    id: "5"

    doc_name: "Deepak"
    timestamp: new Date 2012, 4, 26, 19, 15, 0, 0
    phone: ["+91-9717556926"]
  deepak_person = App.find.one "person",
    doc_id: "person/5"

  App.collection("person").insert
    doc_id: "person/6"

    doc_type: person.doc_id
    id: "6"

    doc_name: "Divik Jain"
    timestamp: new Date 2012, 4, 26, 19, 22, 0, 125
    phone: ["+91-9582999301"]
    email: ["divik.jain@gmail.com"]
  divik_person = App.find.one "person",
    doc_id: "person/6"

  App.collection("person").insert
    doc_id: "person/7"

    doc_type: person.doc_id
    id: "7"

    doc_name: "Anirudh Mendiratta"
    timestamp: new Date 2012, 4, 26, 19, 22, 10, 125
    phone: ["+91-9818394025"]
    email: ["anirudh@gmail.com"]
  anirudh_person = App.find.one "person",
    doc_id: "person/7"

  App.collection("person").insert
    doc_id: "person/8"

    doc_type: person.doc_id
    id: "8"

    doc_name: "Anup Bishnoi"
    timestamp: new Date 2012, 4, 26, 19, 20, 0, 125
    dob: new Date "21 August, 1986"
    phone: ["+91-9868768262", "+91-11-27517704"]
    email: [ "pixelsallover@gmail.com"
           , "anup.bishnoi@vidyamandir.com"
           ]
    address: "39/H-33, Sector-3, Rohini, Delhi - 110085"
  anup_person = App.find.one "person",
    doc_id: "person/8"

  App.collection("center_head").insert
    doc_id: "center_head/vmc/pp/1"

    doc_type: center_head.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "1"

    doc_name: "Sandeep Bhaiya"
    person: sandeep_person.doc_id
    active: true
  sandeep_head = App.find.one "center_head", doc_id: "center_head/vmc/pp/1"

  App.collection("vendor").insert
    doc_id: "vendor/vmc/1"

    doc_type: vendor.doc_id
    org: vmc.doc_id
    id: "1"

    doc_name: "Pradeep Singh"
    person: psingh_person.doc_id
    active: true
  psingh_vendor = App.find.one "vendor", doc_id: "vendor/vmc/1"

  App.collection("center_staff").insert
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
  deepak_staff = App.find.one "center_staff", doc_id: "center_staff/vmc/pp/1"

  App.collection("center_staff_in_out").insert
    doc_id: "in_out/vmc/pp/1/1"

    doc_type: in_out.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_staff: deepak_staff.doc_id
    id: "1"

    in: new Date "26 May 2012, 9:30 AM"
    out: new Date "26 May 2012, 7:30 PM"
  in_out1 = App.find.one "center_staff_in_out", doc_id: "in_out/vmc/pp/1/1"

  App.collection("center_coordinator").insert
    doc_id: "center_coordinator/vmc/pp/2"

    doc_type: center_coordinator.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    id: "2"

    person: sujeet_person.doc_id
    active: true
  sujeet_coordinator = App.find.one "center_coordinator", doc_id: "center_coordinator/vmc/pp/2"

  App.collection("teacher").insert
    doc_id: "teacher/vmc/1"
    
    doc_type: teacher.doc_id
    org: vmc.doc_id
    id: "1"

    doc_name: "Anirudh Bhaiya"
    subject: [physics.doc_id]
    person: anirudh_person.doc_id
    active: true
  anirudh_teacher = App.find.one "teacher", doc_id: "teacher/vmc/1"
  
  App.collection("applicant").insert
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
      time: new Date "5 May 2004, 9:00 AM"
      center: pp.doc_id # registration center
      slot: "1"
      discount: "20%"
    active: true
  anup_applicant = App.find.one "applicant", doc_id: "applicant/vmc/12p2005/1/pp3010"

  App.collection("applicant_discount").insert
    doc_id: "applicant_discount/vmc/12p2005/1/pp3010/1"

    doc_type: applicant_discount.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    admission_test: "admission_test/vmc/12p2005/1"
    applicant: anup_applicant.doc_id
    id: "1"

    center: pp.doc_id
    amount: 200
    on: new Date "20 February 2004, 10:45 AM"
    by: sandeep_head.doc_id
    reason: "NTSE Scholar"
    proof: "attach proof"
  adm_discount = App.find.one "applicant_discount",
    doc_id: "applicant_discount/vmc/12p2005/1/pp3010/1"

  App.collection("applicant_receipt").insert
    doc_id: "applicant_receipt/vmc/12p2005/1/pp3010/1"

    doc_type: applicant_receipt.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    admission_test: "admission_test/vmc/12p2005/1"
    applicant: anup_applicant.doc_id
    id: "1"

    center: pp.doc_id
    amount: 500
    on: new Date "20 February 2004, 11:00 AM"
    proof: "scanned photo of receipt (and cheque)"
  adm_receipt = App.find.one "applicant_receipt",
    doc_id: "applicant_receipt/vmc/12p2005/1/pp3010/1"

  App.collection("student").insert
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
  anup_student = App.find.one "student", doc_id: "student/vmc/12p05zz1234"

  App.collection("student_discount").insert
    doc_id: "student_discount/vmc/12p05zz1234/1"

    doc_type: student_discount.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10000
    on: new Date "10 June 2004, 10:00 AM"
    by: sandeep_head.doc_id
    reason: "just realised he's awesome. wakau!"
    proof: "attach proof of awesomeness"
  stud_discount = App.find.one "student_discount",
    doc_id: "student_discount/vmc/12p05zz1234/1"

  App.collection("student_receipt").insert
    doc_id: "student_receipt/vmc/12p05zz1234/1"

    doc_type: student_receipt.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 40000
    on: new Date "5 May 2004, 11:30 AM"
    cheque:
      favorof: "Vidyamandir Classes"
      branch: "blah"
      deposited:
        by: deepak_staff.doc_id
        on: new Date "7 May 2004, 10:00 AM"
    proof: "attached scanned link"
  stud_receipt = App.find.one "student_receipt",
    doc_id: "student_receipt/vmc/12p05zz1234/1"

  App.collection("accrual").insert
    doc_id: "accrual/vmc/12p05zz1234/1"

    doc_type: accrual.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10212
    on: new Date "1 June 2004, 10:30 AM"
  accr1 = App.find.one "accrual", doc_id: "accrual/vmc/12p05zz1234/1"

  App.collection("accrual").insert
    doc_id: "accrual/vmc/12p05zz1234/2"

    doc_type: accrual.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "2"

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 13235
    on: new Date "1 July 2004, 10:30 AM"
  accr2 = App.find.one "accrual", doc_id: "accrual/vmc/12p05zz1234/2"

  App.collection("refund").insert
    doc_id: "refund/vmc/12p05zz1234/1"

    doc_type: refund.doc_id
    org: vmc.doc_id
    student: anup_student.doc_id
    id: "1"

    on: new Date "25 July 2004, 5:00 PM"
    by: sandeep_head.doc_id
    amount: 8023
    reason: "Don't like his face"
    proof: "photograph?"
  refund1 = App.find.one "refund", doc_id: "refund/vmc/12p05zz1234"
