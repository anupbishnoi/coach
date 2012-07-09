refreshMeta = ->
  App.collection(name).remove({}) for name in [
    "doc_type"
  ]

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "org"
  org = App.find.one "doc_type", doc_id: "org"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "center"
  center = App.find.one "doc_type", doc_id: "center"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "batch"
  batch = App.find.one "doc_type", doc_id: "batch"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "due_installment"
  due_installment = App.find.one "doc_type", doc_id: "due_installment"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "group"
  group = App.find.one "doc_type", doc_id: "group"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "room"
  room = App.find.one "doc_type", doc_id: "room"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "subject"
  subject = App.find.one "doc_type", doc_id: "subject"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "topic"
  topic = App.find.one "doc_type", doc_id: "topic"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "study_material_type"
  study_material_type = App.find.one "doc_type", doc_id: "study_material_type"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "study_material"
  study_material = App.find.one "doc_type", doc_id: "study_material"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "person"
  person = App.find.one "doc_type", doc_id: "person"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_head"
  center_head = App.find.one "doc_type", doc_id: "center_head"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "vendor"
  vendor = App.find.one "doc_type", doc_id: "vendor"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_staff"
  center_staff = App.find.one "doc_type", doc_id: "center_staff"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_coordinator"
  center_coordinator = App.find.one "doc_type", doc_id: "center_coordinator"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "teacher"
  teacher = App.find.one "doc_type", doc_id: "teacher"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "in_out"
  in_out = App.find.one "doc_type", doc_id: "in_out"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "applicant"
  applicant = App.find.one "doc_type", doc_id: "applicant"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "applicant_discount"
  applicant_discount = App.find.one "doc_type", doc_id: "applicant_discount"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "applicant_receipt"
  applicant_receipt = App.find.one "doc_type", doc_id: "applicant_receipt"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "student"
  student = App.find.one "doc_type", doc_id: "student"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "student_discount"
  student_discount = App.find.one "doc_type", doc_id: "student_discount"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "student_receipt"
  student_receipt = App.find.one "doc_type", doc_id: "student_receipt"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "accrual"
  accrual = App.find.one "doc_type", doc_id: "accrual"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "refund"
  refund = App.find.one "doc_type", doc_id: "refund"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "question"
  question = App.find.one "doc_type", doc_id: "question"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "solution"
  solution = App.find.one "doc_type", doc_id: "solution"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "question_paper"
  question_paper = App.find.one "doc_type", doc_id: "question_paper"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "admission_test"
  admission_test = App.find.one "doc_type", doc_id: "admission_test"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "study_class"
  study_class = App.find.one "doc_type", doc_id: "study_class"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "absent"
  absent = App.find.one "doc_type", doc_id: "absent"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "duty_type"
  duty_type = App.find.one "doc_type", doc_id: "duty_type"

  App.collection("doc_type").insert
    doc_type: "doc_type"
    doc_id: "center_coordinator_duty"
  center_coordinator_duty = App.find.one "doc_type", doc_id: "center_coordinator_duty"
