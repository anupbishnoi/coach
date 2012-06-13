refreshPersonnel = ->
  collection.remove({}) for collection in [
    Person
    CenterHead
    CenterStaff
    CenterCoordinator
    CenterCoordinatorDuty
    Teacher
    InOut
    Applicant
    ApplicantDiscount
    ApplicantReceipt
    Student
    StudentReceipt
    StudentDiscount
    Accrual
    Refund
  ]

  vmc = Org.findOne doc_id: "vmc"
  pp = Center.findOne doc_id: "vmc/center/pp"
  xiip05 = Batch.findOne doc_id: "vmc/batch/12p2005"
  xiip1 = Group.findOne doc_id: "vmc/group/pp/12p2005/1"
  admtest = AdmissionTest.findOne doc_id: "vmc/admission_test/12p2005/1"
  physics = Subject.findOne doc_id: "vmc/subject/physics"

  Person.insert
    doc_id: "2012-04-26 19:00:00.000 GMT+0530 (IST) - Sandeep Mehta"

    timestamp: new Date 2012, 4, 26, 19, 0, 0, 0
    doc_name: "Sandeep Mehta"

    doc_type: "person"
    phone: "+91-9953001820"
    email: "sandeep@vidyamandir.com"
  sandeep_person = Person.findOne
    doc_id: "2012-04-26 19:00:00.000 GMT+0530 (IST) - Sandeep Mehta"

  Person.insert
    doc_id: "2012-04-26 19:05:00.000 GMT+0530 (IST) - Pradeep Singh"

    timestamp: new Date 2012, 4, 26, 19, 5, 0, 0
    doc_name: "Pradeep Singh"

    doc_type: "person"
    phone: "+91-8588801202"
  psingh_person = Person.findOne
    doc_id: "2012-04-26 19:05:00.000 GMT+0530 (IST) - Pradeep Singh"

  Person.insert
    doc_id: "2012-04-26 19:10:00.000 GMT+0530 (IST) - Sujeet Shivhare"

    timestamp: new Date 2012, 4, 26, 19, 10, 0, 0
    doc_name: "Sujeet Shivhare"

    doc_type: "person"
    phone: ["+91-8588801214", "+91-9013926056"]
    email: "sujeet.shivhare@vidyamandir.com"
  sujeet_person = Person.findOne
    doc_id: "2012-04-26 19:10:00.000 GMT+0530 (IST) - Sujeet Shivhare"

  Person.insert
    doc_id: "2012-04-26 19:12:00.000 GMT+0530 (IST) - Ajay Pathak"

    timestamp: new Date 2012, 4, 26, 19, 12, 0, 0
    doc_name: "Ajay Pathak"

    doc_type: "person"
    phone: "+91-8588801213"
    email: "pathak@vidyamandir.com"
  pathak_person = Person.findOne
    doc_id: "2012-04-26 19:12:00.000 GMT+0530 (IST) - Ajay Pathak"

  Person.insert
    doc_id: "2012-04-26 19:22:00.125 GMT+0530 (IST) - Divik Jain"

    timestamp: new Date 2012, 4, 26, 19, 22, 0, 125
    doc_name: "Divik Jain"

    doc_type: "person"
    phone: "+91-9582999301"
    email: "divik.jain@gmail.com"
  divik_person = Person.findOne doc_id: "2012-04-26 19:22:00.125 GMT+0530 (IST) - Divik Jain"

  Person.insert
    doc_id: "2012-04-26 19:22:10.125 GMT+0530 (IST) - Anirudh Mendiratta"

    timestamp: new Date 2012, 4, 26, 19, 22, 10, 125
    doc_name: "Anirudh Mendiratta"

    doc_type: "person"
    phone: "+91-9818394025"
    email: "anirudh@gmail.com"
  anirudh_person = Person.findOne
    doc_id: "2012-04-26 19:22:10.125 GMT+0530 (IST) - Anirudh Mendiratta"

  Person.insert
    doc_id: "2012-04-26 19:20:00.125 GMT+0530 (IST) - Anup Bishnoi"

    timestamp: new Date 2012, 4, 26, 19, 20, 0, 125
    doc_name: "Anup Bishnoi"

    doc_type: "person"
    dob: new Date "21 August, 1986"
    phone: "+91-9868768262"
    email: [ "pixelsallover@gmail.com"
           , "anup.bishnoi@vidyamandir.com"
           ]
    address: "39/H-33, Sector-3, Rohini, Delhi - 110085"
  anup_person = Person.findOne
    doc_id: "2012-04-26 19:20:00.125 GMT+0530 (IST) - Anup Bishnoi"

  Person.insert
    doc_id: "2012-04-26 19:15:00.000 GMT+0530 (IST) - Deepak"

    timestamp: new Date 2012, 4, 26, 19, 15, 0, 0
    doc_name: "Deepak"

    doc_type: "person"
    phone: "+91-9717556926"
  deepak_person = Person.findOne
    doc_id: "2012-04-26 19:15:00.000 GMT+0530 (IST) - Deepak"

  CenterHead.insert
    doc_id: "vmc/center_head/pp/1"

    org: vmc.doc_id
    doc_type: "center_head"
    center: pp.doc_id
    id: 1

    doc_name: "Sandeep Bhaiya"
    person: sandeep_person.doc_id
    active: true
  sandeep_head = CenterHead.findOne doc_id: "vmc/center_head/pp/1"

  Vendor.insert
    doc_id: "vmc/vendor/1"

    org: vmc.doc_id
    doc_type: "vendor"
    id: 1

    doc_name: "Pradeep Singh"
    person: psingh_person.doc_id
    active: true
  psingh_vendor = Vendor.findOne doc_id: "vmc/vendor/1"

  CenterStaff.insert
    doc_id: "vmc/center_staff/pp/1"

    org: vmc.doc_id
    doc_type: "center_staff"
    center: pp.doc_id
    id: 1

    doc_name: "Deepak"
    intime: "9 AM"
    outtime: "8 PM"
    person: deepak_person.doc_id
    active: true
  deepak_staff = CenterStaff.findOne doc_id: "vmc/center_staff/pp/1"

  CenterCoordinator.insert
    doc_id: "vmc/center_coordinator/pp/2"

    org: vmc.doc_id
    doc_type: "center_coordinator"
    center: pp.doc_id
    id: 2

    person: sujeet_person.doc_id
    active: true
  sujeet_coordinator = CenterCoordinator.findOne doc_id: "vmc/center_coordinator/pp/2"

  Teacher.insert
    doc_id: "vmc/teacher/pp/physics/1"
    
    org: vmc.doc_id
    doc_type: "teacher"
    center: pp.doc_id
    core_subject: physics.doc_id
    id: 1

    doc_name: "Anirudh Bhaiya"
    person: anirudh_person.doc_id
    active: true
  anirudh_teacher = Teacher.findOne doc_id: "vmc/teacher/pp/physics/1"
  
  InOut.insert
    doc_id: "vmc/in_out/center_coordinator/pp/2"

    org: vmc.doc_id
    doc_type: "in_out"
    personnel_type: sujeet_coordinator.doc_type
    personnel: sujeet_coordinator.doc_id

    in: new Date "26 May 2012, 9:30 AM"
    center: pp.doc_id
  in_out = InOut.findOne doc_id: "vmc/in_out/center_coordinator/pp/2"

  Applicant.insert
    doc_id: "vmc/applicant/12p2005/1/pp3010"

    org: vmc.doc_id
    doc_type: "applicant"
    admission_test: admtest.doc_id
    rollno: "pp3010"

    center: pp.doc_id # enrollment center
    batch: xiip05.doc_id
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
  anup_applicant = Applicant.findOne doc_id: "vmc/applicant/12p2005/1/pp3010"

  ApplicantDiscount.insert
    doc_id: "vmc/applicant_discount/12p2005/1/pp3010/1"

    org: vmc.doc_id
    doc_type: "applicant_discount"
    applicant: anup_applicant.doc_id
    id: 1

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 200
    on: new Date "20 February 2004, 10:45 AM"
    by: sandeep_head.doc_id
    reason: "NTSE Scholar"
    proof: "attach proof"
  adm_discount = ApplicantDiscount.findOne
    doc_id: "vmc/applicant_discount/12p2005/1/pp3010/1"

  ApplicantReceipt.insert
    doc_id: "vmc/applicant_receipt/12p2005/1/pp3010/1"

    org: vmc.doc_id
    doc_type: "applicant_receipt"
    applicant: anup_applicant.doc_id
    id: 1

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 500
    on: new Date "20 February 2004, 11:00 AM"
    proof: "scanned photo of receipt (and cheque)"
  adm_receipt = ApplicantReceipt.findOne
    doc_id: "vmc/applicant_receipt/12p2005/1/pp3010/1"

  Student.insert
    doc_id: "vmc/student/12p05zz1234"

    org: vmc.doc_id
    doc_type: "student"
    rollno: "12p05zz1234"

    center: pp.doc_id # allotted center
    batch: xiip05.doc_id
    group: xiip1.doc_id # can be an array
    applicant: anup_applicant.doc_id
    person: anup_person.doc_id
    active: true
  anup_student = Student.findOne doc_id: "vmc/student/12p05zz1234"

  StudentDiscount.insert
    doc_id: "vmc/student_discount/12p05zz1234/1"

    org: vmc.doc_id
    doc_type: "student_discount"
    rollno: anup_student.doc_id
    id: 1

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10000
    on: new Date "10 June 2004, 10:00 AM"
    by: sandeep_head.doc_id
    reason: "just realised he's awesome. wakau!"
    proof: "attach proof of awesomeness"
  stud_discount = StudentDiscount.findOne
    doc_id: "vmc/student_discount/12p05zz1234/1"

  StudentReceipt.insert
    doc_id: "vmc/student_receipt/12p05zz1234/1"

    org: vmc.doc_id
    doc_type: "student_receipt"
    rollno: anup_student.doc_id
    id: 1

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
  stud_receipt = StudentReceipt.findOne
    doc_id: "vmc/student_receipt/12p05zz1234/1"

  Accrual.insert
    doc_id: "vmc/accrual/12p05zz1234/1"

    org: vmc.doc_id
    doc_type: "accrual"
    rollno: anup_student.doc_id
    id: 1

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 10212
    on: new Date "1 June 2004, 10:30 AM"
  accr1 = Accrual.findOne doc_id: "vmc/accrual/12p05zz1234/1"

  Accrual.insert
    doc_id: "vmc/accrual/12p05zz1234/2"

    org: vmc.doc_id
    doc_type: "accrual"
    rollno: anup_student.doc_id
    id: 2

    center: pp.doc_id
    batch: xiip05.doc_id
    amount: 13235
    on: new Date "1 July 2004, 10:30 AM"
  accr2 = Accrual.findOne doc_id: "vmc/accrual/12p05zz1234/2"

  Refund.insert
    doc_id: "vmc/refund/12p05zz1234"

    org: vmc.doc_id
    doc_type: "refund"
    rollno: anup_student.doc_id

    on: new Date "25 July 2004, 5:00 PM"
    by: sandeep_head.doc_id
    amount: 8023
    reason: "Don't like his face"
    proof: "photograph?"
  refund = Refund.findOne doc_id: "vmc/refund/12p05zz1234"
