refreshContent = ->
  (Collection name).remove({}) for name in [
    "question"
    "solution"

    "question_paper"
    "admission_test"
  ]

  question = Find.one "doc_type", doc_id: "question"
  solution = Find.one "doc_type", doc_id: "solution"
  question_paper = Find.one "doc_type", doc_id: "question_paper"
  admission_test = Find.one "doc_type", doc_id: "admission_test"
  vmc = Find.one "org", doc_id: "org/vmc"
  pp = Find.one "center", doc_id: "center/vmc/pp"
  xiip05 = Find.one "batch", doc_id: "batch/vmc/12p2005"
  anirudh_teacher = Find.one "teacher", doc_id: "teacher/vmc/1"
  physics = Find.one "subject", doc_id: "subject/vmc/physics"
  f_and_m = Find.one "topic", doc_id: "topic/vmc/physics/force_and_momentum"

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
  question1 = Find.one "question", doc_id: "question/vmc/[vmc/physics].[vmc/1]/350"

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
  solution1 = Find.one "solution", doc_id: "solution/vmc/[vmc/physics].[vmc/1]/350/2"

  (Collection "question_paper").insert
    doc_id: "question_paper/vmc/1/359"

    doc_type: question_paper.doc_id
    org: vmc.doc_id
    teacher: anirudh_teacher.doc_id
    id: "359"

    questions: []
  q_paper = Find.one "question_paper",
    doc_id: "question_paper/vmc/1/359"

  (Collection "admission_test").insert
    doc_id: "admission_test/vmc/12p2005/1"

    doc_type: admission_test.doc_id
    org: vmc.doc_id
    batch: xiip05.doc_id
    id: "1"

    doc_name: "Vidyamandir XIIth Pass Admission Test for IITJEE - 2005"
    from: (new Date 2004, 1, 29, 15).getTime()
    to: (new Date 2004, 1, 29, 18).getTime()
    duration: "3 hours"
    sections: [] # marking scheme and total marks are part of sections
    instructions: []
    styling: {}
    question_paper: question_paper.doc_id
  adm_test = Find.one "admission_test", doc_id: "admission_test/vmc/12p2005/1"
