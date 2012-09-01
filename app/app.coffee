Collection.add  [ "doc_type"

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

                  "person"
                  "center_head"
                  "center_manager"
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

                  "question"
                  "solution"
                  "question_paper"
                  "admission_test"

                  "study_class"
                  "absent"

                  "duty_type"
                  "center_coordinator_duty" ]

DocIdfy.addParent
  "org": "doc_type"
  "center": "org"
  "batch": "org"
  "due_installment": "batch"
  "group": ["center", "batch"]
  "room": "center"
  "subject": "org"
  "topic": "subject"
  "study_material_type": "org"
  "study_material": [
    "batch"
    "subject"
    "study_material_type"
  ]
  "center_head": "center"
  "center_manager": "center"
  "vendor": "org"
  "center_staff": "center"
  "center_staff_in_out": "center_staff"
  "center_coordinator": "center"
  "teacher": "org"
  "applicant": "admission_test"
  "applicant_discount": "applicant"
  "applicant_receipt": "applicant"
  "student": "org"
  "student_discount": "student"
  "student_receipt": "student"
  "accrual": "student"
  "refund": "student"
  "question": ["subject", "teacher"]
  "question_paper": "teacher"
  "admission_test": "batch"
  "study_class": ["group", "topic"]
  "absent": "study_class"
  "duty_type": "org"
  "center_coordinator_duty": ["center_coordinator", "duty_type"]

Find.addDefaults (
  _.difference Collection.list()
  , [ "doc_type"
     "org"
     "person" ]
), org: "vmc"    #mark disgusting!

Find.addDefaults (
  _.difference Collection.list()
  , [ "doc_type"
      "person"
      "center_staff_in_out"
      "applicant_discount"
      "applicant_receipt"
      "student_discount"
      "student_receipt"
      "question"
      "solution"
      "question_paper"
      "admission_test"
      "accrual"
      "refund"
      "absent" ]
), active: true

Get.addAlternate [
  "center_head"
  "center_manager"
  "vendor"
  "center_staff"
  "center_coordinator"
  "teacher"
  "student"
], "person"

Get.addField
  "doc_type":
    doc_name: (doc) -> Str.printable doc.id

  "student":
    due_installment: (doc) ->
      receipts = Find "student_receipt"
                 , student: doc.doc_id
      dues = Find "due_installment"
             , batch: doc.batch
      if dues.length is 0
        due = 0
      else if receipts.length is 0
        Ensure "integer", dues[0].amount
        , "Due document must have an integer amount field"
        due = dues[0].amount
      else
        for d in dues
          Ensure "integer", d.amount
          , "Due document must have an integer amount field"
        for r in receipts
          Ensure "integer", r.amount
          , "Receipt document must have an integer amount field"
        due = (Arr.sum _.pluck dues, "amount") -
              (Arr.sum _.pluck receipts, "amount")
      due > 0 and due

    last_paid_on: (doc) ->
      receipt = Find.one "student_receipt"
                , { student: doc.doc_id }
                , { sort: on: 1 }
      (moment receipt.on).format("D MMM YYYY") if receipt?.on?

  "study_class":
    topic_and_id: (doc) ->
      name = Get "topic/doc_name"
             , doc
             , true
      "#{name} - #{doc.id}"
    from_and_to: (doc) ->
      { from, to } = doc
      "#{(moment from).format("D MMM YYYY")}" +
        ", #{(moment from).format("h:mm A") } - #{(moment to).format("h:mm A")}"
    subject_and_batch: (doc) ->
      "#{Get "subject/doc_name", doc, true}, #{Get "batch/doc_name", doc, true}"

