refreshContent = ->
  collection.remove({}) for collection in [
    Question
    Solution
  ]

  vmc = Org.findOne doc_id: "vmc"
  pp = Center.findOne doc_id: "vmc/center/pp"
  xiip05 = Batch.findOne doc_id: "vmc/batch/12p2005"
  anirudh_teacher = Teacher.findOne doc_id: "vmc/teacher/pp/physics/1"
  physics = Subject.findOne doc_id: "vmc/subject/physics"
  topic = Topic.findOne doc_id: "vmc/topic/physics/force_and_momentum"

  Question.insert
    doc_id: "vmc/question/physics/350"

    org: vmc.doc_id
    doc_type: "question"
    subject: physics.doc_id
    id: 350

    contributor: anirudh_teacher.doc_id
    question: "question here"
    answer: "B"
    topic: topic.doc_id # can be an array
    difficulty: "easy"
    public: true
  question = Question.findOne doc_id: "vmc/question/physics/350"

  Solution.insert
    doc_id: "vmc/solution/physics/350/2"

    org: vmc.doc_id
    doc_type: "solution"
    question: question.doc_id
    id: 2

    subject: physics.doc_id
    contributor: anirudh_teacher.doc_id
    solution: "big fatass solution"
    # no public declaration, hence the solution is private
  solution = Solution.findOne doc_id: "vmc/solution/physics/350/2"

