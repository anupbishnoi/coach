Collection.add  [
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
  "rank_range"

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
  "admission_test"
  "admission_test_attempt"
  "batch_test_type"
  "batch_test"
  "batch_test_attempt"
  "group_test"
  "group_test_attempt"

  "marks_type"
  "batch_test_marks"
  "group_test_marks"
  "admission_test_marks"

  "study_class"
  "absent"

  "duty_type"
  "center_coordinator_duty"
]

DocIdfy.addParent
  "org":                       "doc_type"
  "center":                    "org"
  "batch":                     "org"
  "due_installment":           "batch"
  "group":                     [ "center", "batch" ]
  "room":                      "center"
  "subject":                   "org"
  "topic":                     "subject"
  "study_material_type":       "org"
  "study_material":            [ "batch", "subject", "study_material_type" ]
  "admission_test":            "batch"
  "batch_test_type":           "org"
  "batch_test":                [ "batch", "batch_test_type" ]
  "group_test":                [ "group", "subject" ]
  "center_head":               "center"
  "center_manager":            "center"
  "vendor":                    "org"
  "center_staff":              "center"
  "center_staff_in_out":       "center_staff"
  "center_coordinator":        "center"
  "teacher":                   "org"
  "applicant":                 "admission_test"
  "applicant_discount":        "applicant"
  "applicant_receipt":         "applicant"
  "student":                   "org"
  "student_discount":          "student"
  "student_receipt":           "student"
  "accrual":                   "student"
  "refund":                    "student"
  "question":                  [ "subject", "teacher" ]
  "question_paper":            "teacher"
  "study_class":               [ "group", "topic" ]
  "absent":                    "study_class"
  "duty_type":                 "org"
  "center_coordinator_duty":   [ "center_coordinator", "duty_type" ]

Find.addDefault (
  _.difference Collection.list()
  , [ "doc_type"
     "org"
     "person" ]
), org: "vmc"    #todo later: disgusting!

Find.addDefault [
  "group"
  "room"
  "center_head"
  "center_manager"
  "vendor"
  "center_staff"
  "center_coordinator"
  "teacher"
], active: true

Find.addSelectorFilter
  rank_range: -> {}
  subject: -> {}
  student:
    "rank_range": (selector) ->
      [ selector ] = Match arguments, [ "object" ], 1
                     , "Find.addFilter#student#rank_range"
      for type in [ "batch", "group", "admission" ]
        test_type = "#{type}_test"
        if selector[test_type]?
          test = selector[test_type]
          break
      if not test?
        Ensure.error "rank_range (#{Json selector.rank_range}) also needs" +
          "a Test (batch/group/admission) in: #{Json selector}"
      { from, to } = Find selector.rank_range, true
      (student) ->
        marks_selector = {}
        marks_selector[test_type] = selector[test_type]
        marks_selector.id = student.id
        marks = Get "marks"
                , (Find "#{test_type}_marks", marks_selector, true)
                , true
        true if from <= marks <= to


Get.addField
  student:
    "due_installment": (doc) ->
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

    "last_paid_on": (doc) ->
      receipt = Find.one "student_receipt"
                , { student: doc.doc_id }
                , { sort: on: 1 }
      (moment receipt.on).format("D MMM YYYY") if receipt?.on?

  study_class:
    "topic_and_id": (doc) ->
      name = Get "topic/doc_name"
             , doc
             , true
      "#{name} - #{doc.id}"

    "from_and_to": (doc) ->
      { from, to } = doc
      "#{(moment from).format("D MMM YYYY")}" +
        ", #{(moment from).format("h:mm A") } - #{(moment to).format("h:mm A")}"

    "subject_and_batch": (doc) ->
      "#{Get "subject/doc_name", doc, true}, #{Get "batch/doc_name", doc, true}"

QueryFilter.addSearchable
  "student": [ "id"
               "person/doc_name"
               "email"
               "person/phone"
               "person/address"
               "center/doc_name"
               "center/id"
               "org/doc_name"
               "batch/doc_name"
               "batch/id" ]
  "study_class": [ "center/doc_name"
                   "center/id"
                   "batch/doc_name"
                   "batch/id"
                   "group/doc_name"
                   "subject/doc_name"
                   "topic/doc_name"
                   "teacher/doc_name"
                   "room/doc_name" ]

DocMap.add
  "result_view/record/student/center_manager":
    identification:
      main:           "person/doc_name"
      secondary:      "id"
      more:           [ "person/phone"
                        "person/address" ]
    information:
      "Group":        "group/doc_name"
      "Due":          "due_installment"
      "Last Paid":    "last_paid_on"
    action: [
      "'pay_installment'"
    ]

  "result_view/record/study_class/center_manager":
    identification:
      main:           "topic_and_id"
      secondary:      "teacher/doc_name"
      more:           [ "from_and_to"
                        "subject_and_batch" ]
    information:
      "Group":        "group/doc_name"
      "Room":         "room/doc_name"
    action: [
      "'nothing'"
    ]

  "result_view/record/student/center_head":
    identification:
      main:           "person/doc_name"
      secondary:      "id"
      more:           [ "batch/doc_name"
                        "group/doc_name" ]
    information:
      "Next Class":   "next_class_on"
      "Test Marks":   "marks_in_last_test"
    action: [
      "'nothing'"
    ]

    "result_view/record/batch_test/center_head":
      identification:
        main:         "doc_name"
        secondary:    "held_on"
        more:         [ "total_marks"
                        "" ]
      information:
        "Topper":       "topper_with_marks"
        "Most Between": "most_marks_between"
      action: [
        "'nothing'"
      ]

    "result_view/record/teacher/center_head":
      identification:
        main:         "person/doc_name"
        secondary:    "current_topics"
        more:         [ "person/phone"
                        "classes_this_week" ]
      information:
        "Next Class": "next_class_on"
        "Entry":      "last_entry_time"
      action: [
        "'nothing'"
      ]
