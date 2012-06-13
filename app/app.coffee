App = {}

App.collection_ids = [
  "org"
  "center"
  "batch"
  "group"
  "room"
  "day_type"
  "duty_type"

  "subject"
  "topic"
  "question"
  "solution"
  "question_paper"
  "admission_test"
  "study_material_type"
  "study_material"
  "study_material_to_distribute"

  "person"
  "center_head"
  "vendor"
  "center_staff"
  "center_coordinator"
  "center_coordinator_duty"
  "teacher"
  "in_out"
  "applicant"
  "applicant_discount"
  "applicant_receipt"
  "student"
  "student_receipt"
  "student_discount"
  "accrual"
  "refund"

  "class"
  "absent"
]

[ 
  Org
  Center
  Batch
  Group
  Room
  DayType
  DutyType

  Subject
  Topic
  Question
  Solution
  QuestionPaper
  AdmissionTest
  StudyMaterialType
  StudyMaterial
  StudyMaterialToDistribute

  Person
  CenterHead
  Vendor
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

  Class
  Absent
] = (new Meteor.Collection(id) for id in App.collection_ids)
