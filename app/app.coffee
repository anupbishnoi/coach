((log, json, ensure, its, inside, error)->

  App.collection.add [
    "doc_type"

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
    "center_coordinator_duty"
  ]

  App.docIdfy.addParent
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

  App.find.addDefaults (_.difference App.collection.list()
                        , [ "doc_type"
                            "org"
                            "person" ])
  , App.docIdfy org: App.org

  App.find.addDefaults (_.difference App.collection.list()
                        , [ "doc_type"
                            "person"
                            "center_staff_in_out"
                            "applicant_discount"
                            "applicant_receipt"
                            "student_discount"
                            "student_receipt"
                            "accrual"
                            "refund"
                            "absent"
                          ])
  , active: true

  App.get.addField "doc_type"
  , doc_name: (doc)-> _.printable doc.doc_id

  App.get.addField "student"
  , due_installment: (doc)->
      receipts = App.find "student_receipt"
      , student: doc.doc_id
      dues = App.find "due_installment"
      , batch: doc.batch
      if dues.length is 0
        due = 0
      else if receipts.length is 0
        ensure "defined", dues[0].amount
        due = dues[0].amount
      else
        ensure "defined", d.amount for d in dues
        ensure "defined", r.amount for r in receipts
        due = (_.sum _.pluck dues, "amount") -
              (_.sum _.pluck receipts, "amount")
      due > 0 and due

  , last_paid_on: (doc)->
      receipt = App.find.one "student_receipt"
      , { student: doc.doc_id }
      , { sort: on: 1 }
      receipt and receipt.on and
        (_.date new Date receipt.on)

  App.get.addAlternate [
      "center_head"
      "vendor"
      "center_staff"
      "center_coordinator"
      "teacher"
      "student"
    ]
  , "person"

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
